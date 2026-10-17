# 0.4 玩家射程和真实方块碰撞箱

本文件覆盖旧版本文档中的固定3格工具射程、完整方块世界碰撞近似。必须安装与所附文档接口相符、支持26.3的 Bookshelf bs.hitbox 及其依赖；世界物理依赖 #bs.hitbox:get_block_collision。本压缩包不捆绑库。没有库时无法提供地形碰撞，不能仅将缺少库的状态当成空形状使用。工具的 Bookshelf view/raycast 遮挡开关仍独立，安装它们后 #bookshelf vr.input=1。

## 玩家射程

攻击奖励函数以玩家为执行者：

```mcfunction
execute store result score #reach vr.input run attribute @s minecraft:block_interaction_range get 10000
scoreboard players operation #block_limit vr.input = #reach vr.input
```

得到包括属性修饰符在内的实际属性值，×10000。值<=0不攻击。不使用 entity_interaction_range。转换为宏 double 后，Bookshelf max_distance使用相同射程；选择器粗检半径为射程+8，保留原版实体索引。内置解析求交和遮挡也不再使用旧3格/60步硬编码。

Bookshelf返回 entry_distance 为×1000，在回调内立即×10转入自己的×10000分数，并减1（0.0001格）使等距时优先地形。

## 世界结构碰撞

在候选方块的原生世界坐标执行：

```mcfunction
data modify storage bs:out hitbox set value {shape:[],offset:{x:0.0d,z:0.0d}}
function #bs.hitbox:get_block_collision
data modify storage vr:work terrain set from storage bs:out hitbox
function vr:world/shape_loop
```

ABI返回示例：

```snbt
{shape:[[0,0,0,16,8,16]],offset:{x:0.0d,z:0.0d}}
```

每个子盒(min,max)坐标在0..16尺度，允许碰撞几何越出单位格：

- 中心：candidate_min + (min+max)/32 + offset。
- 半尺寸：(max-min)/32。
- 用15轴SAT对旋转单位体素和各AABB逐一检测。
- B投影半径为 hx*abs(nx)+hy*abs(ny)+hz*abs(nz)，不再恒为单位立方体。
- 接触支撑点使用真实半尺寸；空shape不产生接触；多子盒分别入队。

Storage只用于接收不定长形状列表及已有接触队列。每盒数字立即导入×10000 scoreboard；不把形状逐Tick写入结构实体data，也不建额外实体。

候选邻域扩展为X/Z±1、Y=-2..1，覆盖栅栏/墙向上伸出的1.5格碰撞形状。原版空气/水/岩浆等确定无固体碰撞的方块用tag快速跳过；其他状态交给Bookshelf。任意超出原版形状范围的第三方碰撞盒仍需扩大邻域。结构间碰撞保持原来的单位体素OBB检测。

## 性能与边界

最多36候选方块/结构体素，非空候选调用库后每个子盒最多15个SAT轴；已有每结构32接触上限仍有效。复杂楼梯/墙体会增加形状数，Bookshelf查询本身也有成本。本版没有声称更快；优化应通过stopwatch比较库查询、SAT和接触求解。先正确支持半砖/楼梯，再考虑缓存；若缓存，需要对玩家放置/破坏和方块状态变化做失效。

## 已验证范围

官方26.3服务端成功加载新增函数。使用Bookshelf ABI格式的注入形状验证：底半砖上方、单位体素中心Y=1.2时不碰撞；中心Y=0.9时产生一个深度0.1的接触，test/terrain_boxes返回0。输入给定射程6格能命中5格处结构；射程4.5格不能命中。test/input、test/run、test/macro_bridge均返回0，宏ABI静态检查通过12边界。

这些测试验证形状消费与射程传递，不等于实际Bookshelf包、玩家属性读取或客户端点击链路已完成联机集成测试。需要在装有兼容库的存档里验证楼梯、半砖、栅栏门状态。
