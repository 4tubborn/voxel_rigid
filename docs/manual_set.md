<!-- 手工整理 -->

## 旋转

当前 **0.6 版没有直接输入欧拉角的 API**，旋转保存在根实体的四元数记分项中：`vr.qw/qx/qy/qz`，倍率为 **10000**。

例如，把最近结构设置为**绕 Y 轴旋转 90°**，依次执行：

```mcfunction
/tag @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] add vr.edit

/scoreboard players set @e[tag=vr.edit] vr.qw 7071
/scoreboard players set @e[tag=vr.edit] vr.qx 0
/scoreboard players set @e[tag=vr.edit] vr.qy 7071
/scoreboard players set @e[tag=vr.edit] vr.qz 0

/scoreboard players set @e[tag=vr.edit] vr.wx 0
/scoreboard players set @e[tag=vr.edit] vr.wy 0
/scoreboard players set @e[tag=vr.edit] vr.wz 0

/tag @e[tag=vr.edit] remove vr.edit
```

清零 `vr.wx/wy/wz` 是为了停止原有自转。**动态结构在下一次被调度更新时同步旋转矩阵与显示**；碰撞仍可能让它再次旋转。

单独绕某一轴旋转 θ 时：

\[
q_w=10000\cos(\theta/2),\qquad q_{\text{对应轴}}=10000\sin(\theta/2)
\]

其余两个分量设为 0，结果取整。例如绕 Y 轴：

| 角度 | `vr.qw` | `vr.qy` |
|---|---:|---:|
| 0° | 10000 | 0 |
| 45° | 9239 | 3827 |
| 90° | 7071 | 7071 |
| 180° | 0 | 10000 |

这是**设置绝对姿态**。不要直接修改 Display 的 `Rotation` 或 `transformation`，引擎渲染会覆盖它们。静态结构不会经过动态积分，上述方法不能自动完成其碰撞矩阵同步。

## 位置

结构位置由 **整数原点 + 放大 10000 倍的偏移**组成：

\[
x=\text{vr.ox}+\frac{\text{vr.px}}{10000}
\]

Y、Z 同理。这里的位置是结构的模拟中心。

例如，把最近结构移到 **`100.5 70.0 -20.25`**：

```mcfunction
# 选中最近结构
tag @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] add vr.edit

# 整数原点
scoreboard players set @e[tag=vr.edit] vr.ox 100
scoreboard players set @e[tag=vr.edit] vr.oy 70
scoreboard players set @e[tag=vr.edit] vr.oz -21

# 小数偏移：-21 + 0.75 = -20.25
scoreboard players set @e[tag=vr.edit] vr.px 5000
scoreboard players set @e[tag=vr.edit] vr.py 0
scoreboard players set @e[tag=vr.edit] vr.pz 7500

# 清除原有线速度（可选）
scoreboard players set @e[tag=vr.edit] vr.vx 0
scoreboard players set @e[tag=vr.edit] vr.vy 0
scoreboard players set @e[tag=vr.edit] vr.vz 0

# 同步根实体位置与显示
execute as @e[tag=vr.edit] run tp @s 100.5 70.0 -20.25
execute as @e[tag=vr.edit] at @s run function vr:render/body

tag @e[tag=vr.edit] remove vr.edit
```

上述代码适合放在**同一个函数**中执行，避免物理更新夹在多条手动命令之间。

**不能只用 `/tp`**：引擎仍会按记分板中的位置更新，之后会跳回去。动态结构移动后仍会继续受重力、碰撞影响。