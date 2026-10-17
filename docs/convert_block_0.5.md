# 0.5 原生方块转结构

## 已移除的数据迁移

删除 body/migrate 函数及生成代码，删除调度、完整维度Tick和质量API中的调用；新结构不写schema字段。已有scoreboard数值根仍按原方式运行，额外旧schema字段不参与计算；仅存旧NBT数值的根不再自动转换。

## 入口

```mcfunction
# 以执行位置所在的整数格为源块（自动align xyz，负坐标也向下取整）
function vr:spawn/from_block

# 站在方块上时转换脚下的方块
execute at @s positioned ~ ~-1 ~ run function vr:spawn/from_block

# 例如固定位置
execute positioned 10.0 64.0 -5.0 run function vr:spawn/from_block

# 玩家准星所指，读取block_interaction_range
function vr:spawn/looked_block
```

from_block成功返回1、拒绝/失败返回0。looked_block是Bookshelf view回调包装，外层函数返回值取决于view实现，不作为转换事务结果。

## 依赖与数据

转换需兼容26.3的 Bookshelf bs.block 及依赖，调用 #bs.block:get_block。

- bs:out block.type → block_display.block_state.id。
- bs:out block.properties → block_display.block_state.properties（26.3小写键）。
- 不保存 block.nbt，不模拟容器、红石或其他方块实体行为。

准星入口另外需要 bs.view / bs.raycast / bs.hitbox；位置转换本身不需要view。世界刚体碰撞仍依赖hitbox。

## 转换步骤

1. 检查源格已加载、不在 #vr:conversion_disallowed、没有方块实体id。
2. 调用Bookshelf后检查返回type，并用宏if block核对返回type[state]与源块一致；防止共享输出残留被用于错误转换。
3. 把id/properties复制到自己的一次性Storage桥接帧。
4. 创建cube根和一个Display，按相同vr.id精确关联；把Display改为源块状态。
5. 原方块setblock air成功后完成。创建绑定或移除失败时清理本次根/Display。

不调用destroy模式，不主动掉落物品。移除原方块会触发原版邻接更新，例如沙子掉落或附着物脱落；这些是原生方块移除的效果。

默认单体素质量0.7，重心为原格中心，速度/角速度为0。质量可随后用 vr:api/set_mass 修改。物理与工具命中仍使用单位体素cube：视觉上保存半砖、楼梯朝向，但其刚体碰撞形状不在本次动态生成。这与0.4支持世界静态半砖碰撞箱是两个方向的能力。

## 拒绝范围

空气、纯流体、门户、基岩、屏障、活塞头等，以及所有方块实体、门/床/常见双格植物。可修改 #vr:conversion_disallowed 扩充规则。普通方块转换会成为Display表现的刚体，不再运行原生方块随机刻、红石或生长逻辑。

## 验证

官方26.3服务端使用与Bookshelf get_block相同输出契约的测试提供器：横向oak_log[axis=x]转换返回1，源格变air，Display保留id和axis=x；再次render后属性仍保留；质量7000（0.7）；空气、箱子与读取失败均不删除源格，也不增加根。test/run与test/terrain_boxes返回0。第三方Bookshelf实际包和客户端准星回调未在本环境做集成验证。
