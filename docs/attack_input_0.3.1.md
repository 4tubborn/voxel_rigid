# 0.3.1：主手工具、攻击进度与偏心冲量

完整源代码生成器：src/attack_input.py。生成函数位于 data/vr/function/input，进度位于 data/vr/advancement/input/attack.json。

使用：

```mcfunction
function vr:input/give_tool
scoreboard players set #strength vr.input 2000
```

手持工具时，每玩家一个宽4高4的 interaction，脚部位置为玩家位置Y-1；切换主手物品、离线、转维度时清理未被本维度玩家标记的旧盒。用 scoreboard vr.input 关联玩家和盒，避免最近选择器误配。输入独立每游戏Tick运行，物理主动预算保留。

攻击进度使用 player_hurt_entity，奖励函数立即 revoke。26.3 的条件为类型化 loot condition 单对象，entity_properties 内实体谓词采用 minecraft:entity_type / minecraft:equipment / minecraft:nbt；旧版直接 type/equipment 不是本包采用格式。主手工具检查在奖励函数中再次执行。

从玩家眼睛发射3格射线，原版 distance 选择器仅查附近根；转入每根局部空间，以3轴 slab 对每个旋转体素解析求交，保存最近结构、距离和相对重心作用点。利用临时探针先减整数原点再读取×10000坐标，避免直接把世界绝对坐标乘10000。探针只在攻击时存在，不是每体素实体。

冲量 J = strength × 玩家视线方向；dv=J/m；dw=I_world^-1(r×J)。数值读写使用根的 scoreboard，少量元数据仍为 shape/state。静态结构可遮挡，但不改变速度。冻结根不参与攻击。冲量立即修改速度，运动等待根的下次调度。

## Bookshelf 模式

先安装与上传文档接口相符、可运行于26.3的 Bookshelf bs.view、bs.raycast、bs.hitbox 和其完整依赖，然后：

```mcfunction
scoreboard players set #bookshelf vr.input 1
```

攻击函数先从玩家执行：

```mcfunction
function #bs.view:at_aimed_point {run:"function vr:input/bookshelf_block",with:{entities:false,blocks:"function #bs.hitbox:callback/get_block_collision",max_distance:3.0}}
```

回调立刻复制 `$raycast.entry_distance bs.lambda`（×1000）到自己的 scoreboard，作为结构解析求交距离上限；只有回调内读取 lambda。不检测玩家交互盒，避免自身遮挡。减去0.001格使地形在几乎相同距离时优先。

本包未捆绑第三方库，也没有虚报其服务端验证；缺少库时保持 #bookshelf=0。开启前应手动验证上述函数存在且能够命中半砖/楼梯。Bookshelf模式依赖它对射线路径区块的处理，建议在已加载范围内使用。

`#bs.hitbox:set_entity {with:{width:2.0,height:1.0,depth:3.0,centered:true}}` 才是创建自定义虚拟AABB的接口；`bake_entity` 缓存原有实体尺寸。虚拟盒不改变原版客户端点击箱，也不随 block_display transformation 自动旋转。

因此当前混合实现不为每个旋转体素创建虚拟AABB：Bookshelf处理真实世界复杂方块形状，引擎解析OBB处理结构。若后续使用 bs.view:as_aimed_entity 直接命中结构，可给根设置粗略外包AABB，再做OBB细检；不能把外包盒命中直接当成实体真实命中，也不能因粗检假阳性跳过后面的结构。

## 内置模式与限制

#bookshelf=0：地形遮挡按0.05格采样，沿用 #vr:passable 的完整方块近似。可漏掉掠过方块角的短交段，半砖和楼梯会被当成完整方块。Bookshelf模式旨在替代这项近似，但本次没有安装兼容第三方包做集成测试。

客户端点击尚未验证：眼睛处于大盒内时的选中行为、跟随延迟、多人重叠盒、创造模式均需要客户端实测。攻击进度只说明哪个玩家点击了输入盒；本包不会把 @n 当成被击中盒。快速转头时服务端收到的视线可能与点击瞬间不同。持工具期间会截获其他原版操作，换物品后下一Tick清除。

## 已执行的服务端验证

官方26.3服务端成功加载全部新增函数和进度；test/input 的 slab 命中与平行轴排除返回0。0.7质量方块受0.2冲量，vz=2857（×10000），偏心0.3格得到 wy=-5143，符合质量与惯性计算；前方放置完整方块时无新增冲量。test/run、test/configuration、test/macro_bridge 均返回0。客户端点击链路和Bookshelf模式没有实测，以上数值验证直接调用cast入口。

## 0.3.2 创建修复

input/player 原来通过 execute store result ... run execute as @e[...] 判断盒是否存在。当选择器为空，后续命令不执行，#boxes 无初始分数或残留旧值，首次创建会失败。现在显式 set #boxes 0，再由匹配到的盒设置为1。

服务端以两个测试执行者检查创建、重复调用不重复生成、跟随移动、清理；结果分别为1盒、1盒、2盒，跟随与清理均通过。测试直接调用 input/player，仍不代表客户端点击链路实测。
