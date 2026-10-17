# 0.6 转换几何与可配置实体推动

本文件覆盖0.5文档中转换后仍用单位立方体的限制。

## 转换后的真实碰撞几何

spawn/from_block 在删除源块之前调用 #bs.hitbox:get_block_collision，立即复制shape与offset。空形状或超过64个子盒拒绝转换，原块保留。每个子盒从0..16坐标转为以原格中心为参考点的局部中心和半尺寸；例如底半砖：

```snbt
{shape:"custom",state:"dynamic",boxes:[{c:{x:0.0f,y:-0.25f,z:0.0f},h:{x:0.5f,y:0.25f,z:0.5f}}]}
```

固定几何仅在生成时写入根元数据data.boxes，数值运动状态继续scoreboard。迭代时复制列表作为短期游标，盒中心/半尺寸导入scoreboard，不逐Tick重写实体data。没有为子盒增加实体。

- 世界碰撞：各结构子OBB与Bookshelf世界子AABB的15轴SAT。
- 结构之间：双方各子盒的OBB SAT，支撑点使用双方真实半尺寸。
- 工具命中：各子盒局部射线slab求交，半砖空白区域不命中。
- 浮力：每盒8点采样，按实际体积缩放力量；重叠的提供器子盒可能重复计入排水体积。
- 显示：仍一个原方块状态的block_display，几何随刚体旋转。

预编译cube/bar等保持原几何。custom形状采用短列表遍历；custom A匹配预编译B时用flat候选和精确SAT，避免沿用只适合单位A的BVH边界。没有声称额外数据包空间索引比原版实体选择器更快。

重要：本次更新的是碰撞几何。默认质量仍0.7，重心参考点仍原格中心，惯性仍沿用cube近似并按质量缩放，没有从复杂几何重算质心/惯性。碰撞形状正确不等于物理质量分布精确。超出原版方块尺寸的第三方几何需要扩大世界邻域；动态几何不建立BVH。

0.5及更早生成的cube结构不自动补写几何，符合移除迁移逻辑的要求。需要用新版重新转换源方块。

## 实体碰撞配置

默认全局关闭。新结构的vr.ec默认1（单结构允许）。开启：

```mcfunction
function vr:api/entity_collision {enabled:1,players:1,tagged:1,max_targets:16,max_push:0.2}
```

| 参数 | 含义 | 范围 |
|---|---|---|
| enabled | 全局开关 | 0/1 |
| players | 处理附近非旁观玩家 | 0/1 |
| tagged | 处理带vr.collidable标签的实体 | 0/1 |
| max_targets | 每结构每子步、每类选择器上限 | 1..64 |
| max_push | 每次实体处理最大位移（格） | 0.0001..1.0 |

玩家和标签类分别各有max_targets预算，总数最多两倍该值；重复实体经候选标签去重。原生选择器按距离取最近目标，范围为刚体半径+4，适合普通实体；非常大的实体需要扩大范围。marker/Display/interaction不在标签类中处理。旁观玩家不处理。

选择实体：

```mcfunction
tag @e[type=minecraft:cow,distance=..10] add vr.collidable
```

对最近结构单独关闭：

```mcfunction
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/entity_collision_body {enabled:0}
```

设enabled:1恢复。现有旧结构没有vr.ec分数时不会参与此模块，显式调用该接口开启即可；没有NBT迁移。

关闭全局可以重新调用完整接口enabled:0，或：

```mcfunction
scoreboard players set #entity_enabled vr.cfg 0
```

## 实体响应的实际范围

这是单向位置修正，不是原版实体刚体求解器。使用 #bs.hitbox:get_entity 获取宽、高、深和scale，按普通实体脚部为基点构造AABB；测试全部结构子盒，汇总穿透方向，并将位移长度限制为max_push。通过tp移动实体，不写玩家NBT，不伪造玩家Motion。不会产生伤害，也不按实体质量反作用到结构，不保证移动平台载人、站立状态或连续碰撞。

移动后调用 #bs.hitbox:is_entity_in_blocks_collision；如果进入静态地形则撤回本次移动。只检查终点，不是扫掠，max_push较大仍可能越过薄障碍；多接触方向可能抵消。速度并未改为物理冲量，因此需要在客户端验证移动手感和联机表现。

每个主动结构每子步执行，受结构预算影响；静态结构也可推动实体。实体推动目标的标签筛选不替代原版空间索引。未启用时Tick不运行此模块。

## 依赖与验证

转换需要兼容26.3的Bookshelf block/hitbox及其依赖；工具Bookshelf遮挡/准星创建另外需要view/raycast。第三方库不捆绑。

官方26.3服务器使用与提供器契约相同的测试输出：底半砖生成h.y=0.25、c.y=-0.25；射线Y=80.75不命中，Y=80.25命中；旋转90度后空白区域/实体区域仍正确。普通代理实体在Y=80.55不动，在Y=80.45移到80.5；max_push=0.01时只到80.46；vr.ec=0时不再移动。test/custom_boxes、test/run、test/input、test/terrain_boxes、test/macro_bridge、test/configuration均返回0，静态宏检查通过23个边界。

这些不是实际Bookshelf包的集成测试，也不是玩家客户端测试。质量/惯性近似、平台载人和原生实体速度响应均不在以上验证范围。
