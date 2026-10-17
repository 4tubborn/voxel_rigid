# 清理、材料与声音

配置保存在 `vr:config` storage；reload 仅补齐缺失字段，不覆盖已有配置。

```mcfunction
data modify storage vr:config limits set value {min_x:-30000000,max_x:30000000,min_y:-128,max_y:1024,min_z:-30000000,max_z:30000000,max_speed:100.0}
data modify storage vr:config materials set value {density_scale:1.0,min_density:0.05,max_density:100.0,elasticity:0.1}
data modify storage vr:config audio set value {min_speed:4.0,volume_scale:0.05}

# 修改最近结构的恢复系数，范围 0..1
execute as @e[type=minecraft:marker,tag=vr.root,sort=nearest,limit=1] run function vr:api/set_elasticity {elasticity:0.9}
```

边界为闭区间；坐标配置使用整数，速度单位 block/s。每 tick 的调度计数阶段检查所有已加载结构，积分前以及写回后传送前也检查。超限时调用现有 remove 路径，同时移除关联 display。暂停引擎时不自动清理；卸载区块中的结构在加载后检查。位置比较采用整数原点和局部偏移，避免三千万格附近 float32 精度丢失。速度比较使用向量模，乘 20 转为 block/s；原有离散碰撞的 0.45 block/tick 运动限速继续保留。

原生方块转换（包含 looked_block）使用 `#bs.block:get_hardness` 和 `#bs.block:get_sounds`，在移除原方块之前缓存输出。预设 spawn 通过 `#bs.block:lookup_type` 查询其显示材料，避免把生成位置的空气或地板当作结构材料。预设生成现在也需要 Bookshelf block 模块。正常材料密度为 hardness × density_scale，限制在 min_density..max_density；质量仍由密度 × 单位体素数得出，沿用现有质量与惯性同步更新路径。配置应保持 0.05 ≤ min_density ≤ max_density ≤ 100；自定义多体素形状还应保证总质量不超过现有 API 的 1000 上限。

负硬度作为 2147483647 密度处理：精确密度与体素数乘积以实体 `data.material_density` / `data.material_mass` 保存。该值无法放入现有 ×10000 的 32 位记分板，因此 vr.mass/vr.den 使用最大整数哨兵，逆质量和逆惯性取零。在当前精度下对碰撞冲量完全不响应，重力仍驱动其移动。这是对“几乎推不动”的无限质量近似；不是任意大质量的通用精度扩展。有限质量 API 对这类结构返回 0，因为不能从已归零的逆惯性恢复有限惯性。原有 conversion_disallowed 标签仍会拒绝基岩、屏障等材料；本次不扩大允许转换的方块范围。

弹性在现有法向冲量 `j = -(1+e) vn / effective_mass` 中参与计算，两个结构取较大恢复系数并限制为 0..1，世界碰撞同样使用该规则。原有低速反弹抑制阈值（1.6 block/s）继续保留。

水采样从无浸水转为有浸水时播放 generic.splash。高速碰撞按接触点相对法向速度判定，包含角速度贡献；volume = 撞击速度 × volume_scale。世界碰撞播放结构缓存的 hit 声音和被撞方块的 hit 声音；结构间播放双方缓存的 hit 声音。每结构每子步限制一次，避免多个子盒或求解迭代反复播放；听众范围为 32 格。旧结构没有声音缓存时只能播放可取得的一方声音，重新创建后有完整材料缓存。

额外成本：每 tick 遍历已加载根做清理检查，检查只导入位置与线速度；每次积分和传送还有边界检查。材料读取只在创建时发生；世界声音查询只在超过阈值的接触上发生。没有进行性能基准，不能据此宣称性能改善。

使用 Impulse Tool 命中未被地形遮挡的结构时，在攻击玩家位置播放该结构缓存的 hit 声音，音量和音调均为 1，32 格内玩家可听见。静态结构也可触发；没有声音缓存的旧结构不播放，避免复用上一次目标的声音。读取缓存发生在命中确认后，不增加每 tick 的方块查询。

验证：生成器运行、宏边界静态检查、发射后 provider 数学测试（对角线超速、恰好达到阈值、密度上下限、弹性组合）通过。读取了本地 Bookshelf 压缩包的 getter 实现及 sounds 输出，未启动游戏执行新函数。仍需游戏内验证实际清理、世界/结构反弹、入水声音、双方碰撞声音及宏命令实例化。

同时修复 score_backend 在 Windows 上以 `/shape/` 匹配反斜杠路径的问题，防止初始化退回 NBT 数值而没有初始化记分板。边界测试也包含碰撞修正后局部位置未归一化的情况。已安装版本的 conversion_disallowed 标签和 from_block 注释原本与生成源码不同，本次保留这些运行文件；pack/ 中仍沿用生成器原有内容。

接口参考：[Bookshelf block 文档](https://docs.mcbookshelf.dev/en/latest/modules/block/)。旧 README 与早期技术文档中固定默认密度、完整方块世界碰撞等描述不代表当前实现；本文件说明本次改动。
