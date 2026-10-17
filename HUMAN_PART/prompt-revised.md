<!-- 基于Gemini 3.5 Flash-Lite润色过人类的版本进行二次修订 -->

# 角色设定

你是一位精通 Minecraft Java Edition 数据包架构、高级命令（Commands）、1.21+ 宏（Macros）、实体方块渲染（Block Display Entities）以及高性能数据包数学库（如线性代数库 `math3.2_lalib`）的顶级技术专家和游戏引擎架构师。

# 项目背景与可用工具

在 Minecraft Java Edition 26.3 中实现一个**轻量级、高性能的体素刚体物理引擎**。
在开发和优化过程中，我们可以/将会使用以下工具、库与底层技巧：

- **数学与数据支持**：`xiaodou8593/math3.2` 及其线性代数扩展库 `xiaodou8593/math3.2_lalib`、[卡尔的数学库 (large_number)](https://github.com/kaer-3058/large_number/wiki/%E5%8D%A1%E5%84%BF%E7%9A%84%E6%95%B0%E5%AD%A6%E5%BA%93-Wiki%E2%80%90%E4%B8%AD%E6%96%87)、[Minecraft Bookshelf 文档](https://docs.mcbookshelf.dev/zh-cn/latest/#) 以及原版 `context_int_provider` / `context_float_provider`。
  - Bookshelf: 提供了射线投射(Raycast & View)，方块属性获取（包括碰撞箱），实体管理（Link, Interaction等）以及其他实用开发工具。
  
- **原版数据包触发器时序表**：[Misode tick_order.md](https://gist.github.com/misode/77ee37217a69a3c74032679d8084d6c6#file-tick_order-md)
- **核心性能技巧**：
  - **预生成 + 二分法**：可用于筛选，避免线性的低效遍历。

# 任务目标

请帮我编写一套完整的物理引擎架构。视觉渲染依赖 `minecraft:block_display` 实体，物理结构需支持与世界原生方块及其他物理结构互动。命名空间为 `tuy`。

请从以下几个维度为我提供设计方案、关键代码和完整数据包：

## 1. 架构设计与高级技巧应用

- **状态维护**：如何利用记分板、Storage 以及数学库中的向量/矩阵结构来维护刚体的位置、速度、旋转矩阵和角速度？
- **宏派发设计**：可以适量使用 `function $(macro)` 的调用契约，来动态处理不同类型刚体或不同物理状态的分发。
- **二分法加速**：在处理静态体素碰撞或光线投射/求交时，如何构建预生成的数据结构并利用二分法（Binary Search）在单 Tick 内高效完成判定？
- **数据流与 NBT 隔离**：设计一个典型的刚体 Tick 周期内，如何将实体状态批量进行代数计算、再更新 Display 实体坐标的完整闭环。
- **并行执行与控制流**：倾向多实体同时执行( `execute as @e[筛选条件] run command` )，这样的性能会比单纯 `run command` 明显好（注意不是并行运算，数据包是严格的单线程），结合 `if function` 和 `return` 实现高效的多刚体计算与碰撞短路返回。
- **二分法加速**：在处理静态体素碰撞或求交时，如何利用预生成的数据结构与二分法（Binary Search）在单 Tick 内高效完成判定？
- **IO优化**：对于频繁读写的数字字段使用计分板存储。
- **数据包边界**：考虑bvh空间分割等一般优化方案是否真正比原版命令高效。

## 2. 核心物理模块（分阶段实现）

1. **基础物理与碰撞检测（Gravity & Collision）**：
   - 运动学积分与重力加速度计算。
   - 结合二分法或优化算法的方块级静态碰撞检测与刚体间碰撞响应。
2. **摩擦力与阻尼（Friction & Damping）**：
   - 利用数学库计算切向摩擦力、空气阻力并实现平滑衰减。
3. **浮力系统（Buoyancy - 进阶）**：
   - 流体环境检测。
   - 基于浸入体积计算浮力与水流阻力，实现浮沉与漂浮。

## 3. 输出要求

- 给出清晰的 Tick 循环执行流向图。
- 针对关键模块（特别是**宏派发**和**二分法碰撞优化**），提供具体的命令、函数结构或 Storage JSON 格式示例。
- 评估这套方案在处理多个复杂刚体时的性能表现与优化空间。
- 完整的数据包。
