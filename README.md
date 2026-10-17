> **0.6：新转换结构从Bookshelf读取子碰撞箱，支持旋转后的多OBB；新增可配置的单向实体推动，默认关闭。详见 docs/custom_geometry_entities_0.6.md。**

> **0.5：移除旧NBT数据迁移，新增原生方块转换。转换需 Bookshelf block 模块；世界碰撞仍需 hitbox 模块。**

> **0.4 依赖变更：世界刚体碰撞必须安装兼容26.3的 Bookshelf hitbox 模块及其依赖。此包不捆绑 Bookshelf，也不再把缺失碰撞箱回退为完整方块。输入射程现在读取玩家 block_interaction_range。**

# Voxel Rigid 0.6 — Minecraft Java Edition 26.3

一个可运行、可修改的实验性体素刚体数据包。支持三维四元数旋转、逐体素 OBB 碰撞、角冲量、摩擦、阻尼、采样浮力，以及 block_display 渲染。默认使用 26.3 原版 context_float_provider，无外部数据包依赖。

本版本提供完整源码与生成后的数据包，适合作为引擎开发起点。世界碰撞把不在 passable 标签中的方块视为完整立方体；接触点使用近似支持特征，尚无面裁剪、接触缓存、自动睡眠和全引擎 CCD。复杂堆叠、薄小原版碰撞形状与高速运动仍需后续优化。

## 安装与运行

将 **voxel_rigid_26.3.zip 整个文件**放入世界 `datapacks` 目录，执行：

```mcfunction
reload
function vr:test/run
execute at @s positioned ~ ~3 ~ run function vr:spawn/cube
```

自测返回 `0` 表示没有失败项；自测使用临时 Storage，不创建实体、不改动世界方块。生成位置会对齐到所在方块中心。建议先在平坦石头地面上方测试。

```mcfunction
# 三个结构的演示：只生成实体，不修改地形
execute at @s run function vr:demo
# 单独生成：cube / bar / ell / raft
execute at @s positioned ~ ~4 ~ run function vr:spawn/raft
# 暂停与继续
function vr:api/pause
function vr:api/resume
# 查看本 tick 统计（玩家执行）
function vr:api/stats
# 删除引擎管理的所有已加载刚体与显示实体
function vr:api/clear
```

删除最近的刚体：

```mcfunction
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/remove
```

给最近刚体设置速度与角速度，倍率为 10000，单位分别为 block/tick 与 rad/tick：

```mcfunction
scoreboard players set @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.vx 1500
scoreboard players set @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.vy 1000
scoreboard players set @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.wx 200
scoreboard players set @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.wy 400
```

设为静态刚体（不可逆质量与惯性会清零，恢复动态时应重新生成或恢复原始参数）：

```mcfunction
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/static
```

均匀水流速度可设置为：

```mcfunction
data modify storage vr:config water_velocity set value {x:0.03f,y:0.0f,z:0.0f}
```

默认水流为零；该参数用于相对流速阻力，不自动推导原版流动水的局部流速。

## 文件与定制

- `data/vr/function/`：运行逻辑、碰撞求解、形状 BVH、测试。
- `data/vr/context_float_provider/`：生成的数值表达式。
- `src/build.py`：Python 3.10+ 生成器，标准库即可。
- `src/shapes.json`：体素坐标、密度与显示方块。
- `src/add_tests.py`：生成游戏内自测。
- `docs/architecture.md`：完整架构、命令契约、二分法、数学、性能与扩展路线。
- `docs/validation.md`：验证记录与实际限制。
- `adapters/lalib_matrix.mcfunction`：基于已核实接口的可选数学库适配示例。

解压后修改 `src/shapes.json`，运行：

```sh
python src/build.py
```

生成结果位于解压目录下的 `pack/`，把这个目录放入 `datapacks`。重新生成会覆盖 `pack/`，不会删除源代码或文档。形状最多 64 个单位体素，质心到最远体素中心距离须小于 7 格；建议最初使用 1–9 个体素、2–4 个刚体，按实际命令预算扩大。

三个原版维度已接入 tick；自定义维度可从自己的 tick 函数调用：

```mcfunction
execute in your:dimension run function vr:tick/dimension
```

清理函数只选择当前已加载实体；卸载区块内的刚体需要加载区块后清理。引擎不主动 forceload。遇到候选区块未加载时会回退本次积分并停止速度，等待周边加载。

## 0.3：每 Tick 结构预算

```mcfunction
# 每 Tick 最多主动更新 2 个已加载结构
function vr:api/set_budget {structures_per_tick:2}
# 沿用旧字段名，但含义已改成结构数/Tick
function vr:api/configure {updates_per_second:2,substeps:2,solver_iterations:4,step_ticks:1}
function vr:api/scheduler_stats
```

固定 N 个结构、预算 B，完成一轮需 ceil(N/B) 个 Tick。预算 1..256，默认 20。每轮每个根只被主动选择一次，最后不足 B 时不重复处理。solver_iterations 仍是接触求解次数；step_ticks 是每次主动更新推进的模拟时间，默认 1，低预算会减慢模拟而不会自动扩大 dt。

这是主动更新预算，碰撞邻体仍可能被读取和被动修改。详情见 `docs/scheduler_0.3.md`。旧 updates_per_second 数字保留，但不再代表每秒更新频率。

## 每结构质量与密度

```mcfunction
# 最近动态结构：总质量设为 10
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/set_mass {mass:10.0}
# 或按每体素密度设置（总质量=密度×体素数）
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/set_density {density:0.7}
scoreboard players get @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] vr.mass
```

质量范围 0.05..1000，返回 1 表示成功，0 表示对象/质量无效或静态结构。质量是引擎自定义单位，重力下重量=质量×重力加速度。质量更新同步调整逆质量、密度、惯性张量与逆惯性，保留线速度和角速度。不要只手改 vr.mass。

`vr.mass` 的记分值为质量×10000；默认质量来自 shapes.json 的 density×体素数。位置偏移、速度、角速度、四元数和矩阵也使用×10000 的记分项，整数原点 vr.ox/oy/oz 与体素数 vr.count 不缩放。实体 data 只含 shape/state。


## Stopwatch 与查询模式

新安装默认使用线性叶查询；原版目标选择器仍负责结构间候选筛选。可显式选择 BVH，并在同状态下比较：

```mcfunction
function vr:api/query_mode {mode:1}
function vr:profile/geometry {shape:"raft",repeats:1,separation:0.0}
function vr:profile/results
```

mode=1 为线性，mode=0 为 BVH。测量使用 stopwatch，时间保存为按微秒缩放的分数；实际计时粒度和封装开销需考虑。详见 `docs/profiling.md`，含反向测试顺序、原版选择器入口、预算中途终止识别与实测样本。

## 0.2.2 修复

修复改为记分板后世界/流体宏参数未同步的问题。无需清空存档或所有结构；替换旧包并 reload，新参数会覆盖残留数据。新增 `/function vr:test/macro_bridge` 与静态宏边界检查。根因、清空参数的对照测试、验证及更新方式见 `docs/fix_0.2.2.md`。

## 0.3.1 冲量工具

`/function vr:input/give_tool` 获取专用木棍。仅主手持工具时创建玩家交互盒，切换物品后清除；攻击进度触发旋转体素求交和偏心冲量。射程 3 格。

`/scoreboard players set #strength vr.input 2000` 表示冲量 0.2（数值×10000）。

安装兼容所附文档接口的 Bookshelf view/raycast/hitbox 及其依赖后，执行 `/scoreboard players set #bookshelf vr.input 1`，启用精确方块碰撞形状遮挡。默认 0 使用内置完整方块近似。详见 `docs/attack_input_0.3.1.md`。
## 从原生方块生成结构

```mcfunction
# 执行位置所在的方块；支持任意执行者
function vr:spawn/from_block
# 玩家脚下
execute at @s positioned ~ ~-1 ~ run function vr:spawn/from_block
# 玩家准星指向的方块，需要Bookshelf view/raycast
function vr:spawn/looked_block
```

保留方块id和properties，成功后移除原方块；空方块、方块实体（如容器）、门/床等跨格方块拒绝转换。单体素默认质量0.7，可用现有质量API修改。0.6新转换的方块使用Bookshelf真实子碰撞箱；质心和惯性仍采用原格中心与cube近似。详见 docs/convert_block_0.5.md。

## 开启实体推动

```mcfunction
function vr:api/entity_collision {enabled:1,players:1,tagged:1,max_targets:16,max_push:0.2}
tag @e[type=minecraft:cow,distance=..10] add vr.collidable
```

这是单向位置修正，不是双向冲量或移动平台载人。
