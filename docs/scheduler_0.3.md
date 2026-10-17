# 0.3：结构更新预算与轮转调度

`updates_per_second` 从本版起具有新的含义：**每个游戏 Tick 最多主动更新多少个已加载结构**，不再表示每秒次数。该字段名保留以便沿用旧命令；建议使用含义清楚的专用接口：

```mcfunction
function vr:api/set_budget {structures_per_tick:2}
```

或同时配置子步和求解器：

```mcfunction
function vr:api/configure {updates_per_second:2,substeps:2,solver_iterations:4,step_ticks:1}
```

预算范围 1..256，默认 20。子步数仍为 1..8，求解次数为 1..16。参数验证失败返回 0，配置保留。

## N / B 的准确含义

在已加载结构数量 N、预算 B 不变且命令没有中途终止的情况下：

`完成一轮的 Tick 数 T = ceil(N/B)`。

| N | B | 一轮 Tick 数 | 正常 20 TPS 下的一轮时间 |
| ---: | ---: | ---: | ---: |
| 5 | 2 | 3 | 0.15 秒 |
| 100 | 20 | 5 | 0.25 秒 |
| 100 | 1 | 100 | 5 秒 |
| 3 | 20 | 1 | 0.05 秒 |

这不是接触求解的迭代次数。`solver_iterations` 继续表示每批接触执行几轮冲量求解，不能用 N/B 替代。

每轮中，已加载结构只会被主动选择一次；当最后一批不足 B 时，只处理剩余结构，不在同一个 Tick 内开始下一轮或重复处理同一结构。原版选择器的任意顺序可能因实体位置变化而改变，因此不是保证每个结构严格固定间隔 T，而是保证固定成员的一轮完成次数。

N 包括已加载 marker 根（含静态结构）；静态结构的积分入口会快速返回。区块卸载、新增、删除结构或修改预算会改变轮次成员/长度，公式只针对固定 N/B。引擎不主动加载区块。

## 时间推进

每个被主动选择的结构推进 `step_ticks` 个模拟 Tick，分成 `substeps` 个子步。默认 step_ticks=1，分批会相应减慢模拟：N=100、B=20 时，一轮 5 个游戏 Tick，每结构每轮只推进 1 模拟 Tick。

本版本不按等待时间自动补偿 dt，以避免低预算时积累出大步长和穿地。想保持较高模拟速度应优先增加预算；提高 step_ticks 会带来离散碰撞误差，不自动变成 CCD。

## 执行方式与原版边界

调度不维护 Storage 实体队列，也不重建实体空间索引。使用原版选择器和标签：

- `vr.round_done`：本轮已处理。
- `vr.selected`：当前 Tick 已选中的本批结构。
- `vr.render_dirty`：碰撞响应改变了未主动更新的邻体，需要同步显示。

每 Tick 的 B 是三个原版维度合计预算，按 overworld→nether→end 分配剩余额度。当前维度没有未处理结构时才去下一维度；已完成轮次的结构保持 done，因此下一维度不会被持续重选的主世界结构饿死。完整一轮结束后清除已加载根的 done 标记，再开始下一轮。

新的 scheduler/pick 入口：

```mcfunction
$execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.round_done,limit=$(budget)] run function vr:scheduler/mark
```

每个被选择的根做配置子步、世界碰撞、刚体碰撞和显示更新。常规 `/function vr:tick` 使用此预算；`vr:tick/dimension` 保留为显式完整维度更新测试入口，主动调用它会绕过预算。

## 邻体响应与预算边界

预算限制主动积分更新数，而不是所有实体读写的硬上限。被选中的 A 仍使用原版 distance 选择器检测邻体 B；即使 B 尚未轮到，也可收到冲量/位置修正，并刷新 Display。这些被动响应不增加 B 的主动更新计数。

若 A/B 都在本批，则按 ID 只求解一次无序结构对；若只有 A 在本批，则不能因为 B 的 ID 更小而跳过碰撞。因此本版新增了 selected-aware 对枚举。

异步分批不是同一时间点的全局同步求解器，复杂堆叠/高预算延迟会影响稳定性。一个复杂结构仍可能超过命令预算，所以 B 不是耗时上限。

## 查看与验证

```mcfunction
function vr:api/config_status
function vr:api/scheduler_stats
scoreboard players get #processed vr.stat
scoreboard players get #loaded vr.stat
scoreboard players get @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.updates
```

`#processed` 是本 Tick 主动选择数，`vr.updates` 是该根累计主动选择数（不会因被动碰撞响应增加）。`#round vr.cfg` 为累计开始的轮次。

正式版服务端实测：5 个结构，B=2，连续三次 Tick 入口分别选择 2、2、1 个；每个结构累计选择次数均为 1。第四次 Tick 开始下一轮，选择 2 个。另测只选择较大 ID 的结构碰撞未被选择的较小 ID 邻体，验证被动邻体得到响应但主动计数仍为 0。数值、配置与宏参数回归测试均返回 0。

## 版本迁移

旧合法数字配置会保留，但语义改变：旧 updates_per_second=1 现在表示每 Tick 1 个结构，而非 1 Hz。无需清除持久物理数值或旧结构；0.2.2 的宏参数修复继续保留。
