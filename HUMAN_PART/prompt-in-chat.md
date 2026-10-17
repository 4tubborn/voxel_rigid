<!-- 真正在开发环境输入的提示词 -->
<!-- 分割线区分不同次输入 -->

---

**# 角色设定**
你是一位精通 Minecraft Java Edition 数据包架构、高级命令（Commands）、1.21+ 宏（Macros）、实体方块渲染（Block Display Entities）以及高性能数据包数学库（如线性代数库 \`math3.2_lalib\`）的顶级技术专家和游戏引擎架构师。

**# 项目背景与可用工具**
在 Minecraft Java Edition 26.3 中实现一&#x4E2A;**\*\*轻量级、高性能的体素刚体物理引擎\*\***。
在开发和优化过程中，我们可以/将会使用以下工具、库与底层技巧：
\- **\*\*数学与数据支持\*\***：\`xiaodou8593/math3.2\` 及其线性代数扩展库 \`xiaodou8593/math3.2_lalib\`、[卡尔的数学库 (large_number)]\([https://github.com/kaer-3058/large_number/wiki/%E5%8D%A1%E5%84%BF%E7%9A%84%E6%95%B0%E5%AD%A6%E5%BA%93-Wiki%E2%80%90%E4%B8%AD%E6%96%87)、\[Minecraft](https://github.com/kaer-3058/large_number/wiki/%E5%8D%A1%E5%84%BF%E7%9A%84%E6%95%B0%E5%AD%A6%E5%BA%93-Wiki%E2%80%90%E4%B8%AD%E6%96%87\)、\[Minecraft) Bookshelf 文档]\([https://docs.mcbookshelf.dev/zh-cn/latest/#](https://docs.mcbookshelf.dev/zh-cn/latest/#)) 以及原版 \`context_int_provider\` / \`context_float_provider\`。
\- **\*\*核心性能技巧\*\***：
  - **\*\*预生成 + 二分法\*\***：用于快速求交、碰撞检测或空间查找，避免线性的低效遍历。
  - **\*\*宏与动态函数派发\*\***：大量使用 \`function $(macro)\` 和数据存储（Storage）传参，消除传统的 \`execute if score\` 分支地狱，实现高效的分发与逻辑复用。

**# 任务目标**
请帮我编写一套完整的物理引擎架构。视觉渲染依赖 \`minecraft:block_display\` 实体，物理结构需支持与世界原生方块及其他物理结构互动。

请从以下几个维度为我提供设计方案、关键代码和完整数据包：

**## 1. 架构设计与高级技巧应用**
\- **\*\*状态维护\*\***：如何利用记分板、Storage 以及 \`math3.2\` 的向量/矩阵结构来维护刚体的位置、速度、旋转矩阵和角速度？
\- **\*\*宏派发设计\*\***：如何规划 \`function $(macro)\` 的调用契约，来动态处理不同类型刚体或不同物理状态的分发？
\- **\*\*二分法加速\*\***：在处理静态体素碰撞或光线投射/求交时，如何构建预生成的数据结构并利用二分法（Binary Search）在单 Tick 内高效完成判定？
\- **\*\*数据流与 NBT 隔离\*\***：设计一个典型的刚体 Tick 周期内，如何将实体状态批量导入 Storage、利用 \`math3.2_lalib\` 进行线性代数计算、再更新 Display 实体坐标的完整闭环。
\- **\*\*并行执行与控制流\*\***：倾向多实体同时执行(execute as @e[筛选条件] run command)这样的性能会比单纯run command明显好，结合 \`if function\` 和 \`return\` 实现高效的多刚体计算与碰撞短路返回。
\- **\*\*二分法加速\*\***：在处理静态体素碰撞或求交时，如何利用预生成的数据结构与二分法（Binary Search）在单 Tick 内高效完成判定？

**## 2. 核心物理模块（分阶段实现）**
1\. **\*\*基础物理与碰撞检测（Gravity & Collision）\*\***：
   - 运动学积分与重力加速度计算。
   - 结合二分法或优化算法的方块级静态碰撞检测与刚体间碰撞响应。
2\. **\*\*摩擦力与阻尼（Friction & Damping）\*\***：
   - 利用数学库计算切向摩擦力、空气阻力并实现平滑衰减。
3\. **\*\*浮力系统（Buoyancy - 进阶）\*\***：
   - 流体环境检测。
   - 基于浸入体积计算浮力与水流阻力，实现浮沉与漂浮。

**## 3. 输出要求**
\- 给出清晰的 Tick 循环执行流向图。
\- 针对关键模块（特别&#x662F;**\*\*宏派发\*\***&#x548C;**\*\*二分法碰撞优化\*\***），提供具体的命令、函数结构或 Storage JSON 格式示例。
\- 评估这套方案在处理多个复杂刚体时的性能表现与优化空间。
\- 完整的数据包。

---

让迭代次数和tick速率可配置 例如：1iteration/s

另外 每个物理结构的重量是否是可配置的？

请不要过度依赖实体的data字段 尽量使用scoreboard存储 虽然会损失精度 但是换来了较大的性能提升 数值提供器本身就有type:"score"的数据来源

---

同时注意数据包的边界 数据包的模拟基本不会比java底层更加快 考虑bvh等空间分割是否真正比原版目标选择器高效

1.21.11+的stopwatch create/remove/query可以对命令进行性能评估 在命令执行前create stopwatch 在命令执行后query即可获得命令耗时 可考虑使用execute store result score ... run stopwatch ... query进行显示

---

我在游戏里实测后发现物体都穿过了方块地形 无法响应碰撞 同时浮力也未生效 查看是否为改写导致 或者是我存档里上一版的遗留数据造成的

---

能否让updates_per_second具有新的含义：表示每tick处理的结构数量或者是迭代次数=structure_count/updates_per_second

---

我想到一个功能：玩家左键攻击结构 结构会有对应的冲量响应 考虑在玩家周围包一个大interaction实现左键检测

---

必然会影响玩家正常左键 所以考虑做成手持特定物品进行检测 使用advancement检测interaction左键player_attacked_entity，然后execute as @n[type=interaction]进行响应

---

写出完整的代码

---

考虑使用bookshelf view进行实现检测

**#bs.hitbox:bake_entity可以创建自定义aabb虚拟碰撞箱**

**#bs.hitbox:get_block_collision**
可以获取方块碰撞形状

---

并没有生成interaction 我无法进行测试

---

新增：max_distance由player的block_interaction_range决定 使用execute store result ... run attribute @s ... get 10000获取

修改：结构与世界进行碰撞时使用bookshelf block提供&#x7684;**#bs.hitbox:get_block_collision**
获取碰撞箱 然后进行检测

---

1. 删除数据迁移部分
2. 增加玩家生成结构的能力。例如：的把执行位置的方块变成结构

---

可使用bookshelf的block模块

---

注意生成的方块的碰撞箱 使&#x7528;**#bs.hitbox:get_block_collision获取结构碰撞箱**

新增：结构对于实体的碰撞，可配置

---
