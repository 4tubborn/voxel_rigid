# Stopwatch 性能评估与原版边界

本引擎不能预设 mcfunction 对相同工作比 Java 更快。优化目标是减少实际执行的命令、NBT/记分项访问和候选几何数量；原版选择器能完成的实体筛选继续交给原版。

## 原版筛选与 BVH 的职责

结构之间的候选仍使用：

```mcfunction
execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen,distance=..17] if score @s vr.id > #aid vr.tmp run function vr:pair/body
```

没有另写实体网格替换这个选择器。BVH 只查询结构内的体素几何。目前 Display 统一放在质心，体素相对位置由 transformation 表达；因此目标选择器的位置/包围盒不能直接当作已旋转的每体素 OBB。若改为每体素独立实体位置，应另测原版选择器剪枝、实体移动、实体 Tick 与同步开销的总和，不能只测选择器命令。

树节点的计算、函数派发、寄存器读写也有成本。小结构或大量叶子同时相交时，BVH 可能不如直接检查叶子。**新安装默认使用线性叶查询；BVH 作为显式可选模式保留。** 已有合法 query_mode 配置会保留。

```mcfunction
function vr:api/query_mode {mode:1}  # 线性叶查询
function vr:api/query_mode {mode:0}  # BVH
```

这里的线性查询与 BVH 叶子使用相同的包围球早退和 SAT，保留相同的碰撞判定精度。原版实体选择器保持不变。

## Stopwatch 的单位与正确测量位置

正式版 1.21.11+ 的语法为 `stopwatch create/remove/query/restart <id>`，query 接收 scale，将经过的**秒数**乘倍率后截断作为命令返回值。

官方说明：<https://www.minecraft.net/sv-se/article/minecraft-java-edition-1-21-11>。

例如在同一个 mcfunction 中：

```mcfunction
stopwatch create vr:measure
function vr:your_target
execute store result score #elapsed_us vr.prof run stopwatch query vr:measure 1000000
stopwatch remove vr:measure
```

scale=1000000 表示按微秒缩放的分数；不代表获得微秒测量精度。本次服务端样本呈毫秒级粒度。scale=1000 则是毫秒，默认 scale=1 对亚秒命令会截断为 0。不要在聊天栏分次手动执行计时器命令，否则计入的是人工等待与其他 Tick。

## 已加入的测量入口

通用函数测量（调用者须提供正确的 @s、执行位置与参数前置条件）：

```mcfunction
function vr:profile/run {entry:"vr:profile/empty",repeats:16}
scoreboard players get #elapsed_us vr.prof
```

`entry` 是受信任的函数 ID；只允许自己选择的入口。profile/run 不回滚目标函数的副作用，测量物理更新会真正推进状态。`repeats` 范围 1..16；超出命令链预算可能中途终止。elapsed_us=-1 表示没有完成计时，不应使用旧数据推断性能。

选择器独立样本：

```mcfunction
execute at @s run function vr:profile/run {entry:"vr:profile/select_roots",repeats:16}
scoreboard players get #elapsed_us vr.prof
scoreboard players get #native_count vr.prof
```

这是选择器加计数的耗时，不能与完成 SAT/接触生成的几何查询直接比较为同一种工作。

固定状态下比较结构内部几何：

```mcfunction
function vr:profile/geometry {shape:"raft",repeats:1,separation:0.0}
function vr:profile/results
# 交换测量次序，减少 JIT/缓存与先后顺序偏差
function vr:profile/geometry_reverse {shape:"raft",repeats:1,separation:0.0}
function vr:profile/results
```

A/B 都是指定形状、单位姿态，以 separation 沿 X 偏移。测量只生成接触，不积分、不求解、不创建实体、不修改世界；每次重复清空队列，使输入状态一致。它会覆盖引擎工作寄存器、Storage 与统计，所以仅从顶层调用，不要在正在执行的物理回调中重入。

`#bvh_us` / `#linear_us` 是整个批次耗时；SAT、contacts、overflow 等对照计数同样保存到 vr.prof。时间包括查询派发、循环、计时端点等开销。与空函数循环基线比较能辅助判断，但不能机械相减得到精确单命令纳秒耗时。先预热、再多轮交替，保存各样本并比较中位数与分布。

建议从 repeats=1 开始。一次 raft×raft 完全重叠的双模式 repeats=4 测试已实际触及默认 65536 命令预算，线性时间保留为 -1；该样本已判为无效。测量函数不修改 gamerule，不为了产生数字而隐藏预算中途终止。

## 本次样本（26.3 原版服务端）

| 查询 | 次序/重复 | BVH 批次 ms | 线性批次 ms | 对照 |
| --- | --- | ---: | ---: | --- |
| cube 完全重叠 | BVH 先，4 次 | 4 | 4 | 两者各 4 接触 |
| raft 完全重叠 | BVH 先，1 次 | 16 | 13 | 两者各 9 接触 |
| raft 完全重叠 | 线性先，1 次 | 20 | 24 | 交换次序样本 |
| raft 完全重叠 | BVH 先，1 次 | 10 | 6 | 预热后样本 |
| raft 完全重叠 | 线性先，1 次 | 8 | 6 | 预热后样本 |
| raft 分离 4 格 | BVH 先，1 次 | 1 | 2 | 两者 SAT=0 |

附近两个 marker 的原版选择器+计数入口，重复 16 次样本为 6 ms；该数字包括测量封装，没有移除空循环/JIT/计时开销。

这些样本足以否定“BVH 必然更快”，不足以确定通用交叉点或可靠加速比。分离场景能剪枝，密集小结构可选更简单的线性基线。后续应覆盖稀疏复杂结构、局部接触、密集堆叠、不同实体数量，并在同硬件、同输入与相同返回结果下比较。
