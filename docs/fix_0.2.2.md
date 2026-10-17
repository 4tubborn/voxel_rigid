> 本文记录历史验证；0.5已移除数据迁移实现。

# 0.2.2：地形碰撞和浮力失效回归修复

## 根因

0.2 的记分板改写把 `query.x/y/z` 和 `sample.x/y/z` 转为 vr.num 寄存器，但宏调用仍从 Storage 读取参数。计算后的数值没有在调用边界导出：

```mcfunction
# 问题版本：数值只更新了记分板
execute store result score #query.x vr.num run compute default float ...
function vr:world/block with storage vr:work query
```

在清空这些临时字段后，宏缺少必要变量，世界与流体查询无法执行。有旧字段时，宏可能使用旧坐标，使同一包在不同存档中表现不同。主体不是实体迁移损坏；旧临时参数反而曾掩盖或改变这一回归的表现。

## 修复

数值仍保留在记分板。生成器识别每个本地宏的变量，只在调用前导出所需的数值字段：

```mcfunction
execute store result storage vr:work query.x float 0.0001 run scoreboard players get #query.x vr.num
execute store result storage vr:work query.y float 0.0001 run scoreboard players get #query.y vr.num
execute store result storage vr:work query.z float 0.0001 run scoreboard players get #query.z vr.num
function vr:world/block with storage vr:work query
```

sample 同样处理。这一规则覆盖所有本地 numeric macro 参数，而不是仅修补两个调用点。

## 复现与验证

26.3 原版服务端，默认更新配置（20/2/4/1），临时测试场景：石头平台 y=60，水池 y=61..66。

| 情况 | 世界接触/速度/浸水结果 |
| --- | --- |
| 0.2.1，删除 query/sample 后，方块在平台表面 | 世界候选计数 0，接触数 0，继续下降 |
| 0.2.1，水中质量 0.7 方块 | vy=-0.0399，wet=0 |
| 0.2.2，同一平台输入且删除临时参数 | 世界候选 18，接触 2，vy=0 |
| 0.2.2，同一水中输入且删除临时参数 | vy=+0.0171，wet=1.0 |
| 0.2.2，故意填入 x/y/z=123、origin=999 的旧参数 | 参数被新分数覆盖，vy=+0.0171，wet=1.0 |
| 同一水中结构质量改为 2.0，推进 3 次更新 | vy=-0.0423，正确下沉 |
| 从 y=65.5 下落，推进 40 次更新 | COM y≈61.4758，vy=0，停在平台附近 |
| 0.1 完整数值 NBT 结构自动迁移后 | schema=2，vy=0，平台接触恢复 |

约 0.0242 格静态穿透仍是当前位置修正近似的限制；宏修复没有声称消除所有接触稳定性问题。

此前 0.2/0.2.1 的纯数学和几何查询测试没有经过真实世界/流体宏边界，且测试世界保留了旧工作参数，未发现此回归。旧版本完整物理性能样本也可能受错误环境查询影响，不能作为正确完整物理模拟的加速证据。固定输入的 BVH/线性纯几何对照不涉及世界/流体参数，属于不同测试范围。

## 新增回归测试

```mcfunction
function vr:test/macro_bridge
scoreboard players get #bridge_fail vr.test
```

返回 0 表示：缺失参数和故意填入的旧参数都已被当前记分板值覆盖。该测试不改地形、不创建实体；会写工作参数，下一次物理查询会重新导出当前值。

`tests/test_macro_contract.py` 静态检查生成函数的所有数值宏调用前都具有对应 score→Storage 导出。此次检查通过 11 个调用点。端到端地形与水池测试使用临时测试世界，不会在用户世界自动创建测试平台。

## 更新方式

替换旧数据包，避免新旧副本同时启用，执行 `/reload`。无需删除存档、清空所有实体或清空全局 Storage；新查询会覆盖旧参数，原有合法配置和结构记分项保留。

已经掉入地下/虚空的结构不会自动传送回原生成位置，需重新生成或由使用者移回；当前世界位置分为整数原点与局部偏移，单独 tp marker 不会永久改变记分板中的位置。

大 step_ticks 的离散积分、复杂堆叠、半砖/楼梯完整方块近似等原有限制仍存在。排查时先用默认配置：

```mcfunction
function vr:api/configure {updates_per_second:20,substeps:2,solver_iterations:4,step_ticks:1}
```
