execute unless score #ups vr.cfg matches 1..256 run scoreboard players set #ups vr.cfg 20
execute unless score #substeps vr.cfg matches 1..8 run scoreboard players set #substeps vr.cfg 2
execute unless score #solver vr.cfg matches 1..16 run scoreboard players set #solver vr.cfg 4
execute unless score #step_ticks vr.cfg matches 1..20 run scoreboard players set #step_ticks vr.cfg 1
execute unless score #enabled vr.cfg matches 0..1 run scoreboard players set #enabled vr.cfg 1
execute unless data storage vr:config limits.min_x run data modify storage vr:config limits.min_x set value -30000000
execute unless data storage vr:config limits.max_x run data modify storage vr:config limits.max_x set value 30000000
execute unless data storage vr:config limits.min_y run data modify storage vr:config limits.min_y set value -128
execute unless data storage vr:config limits.max_y run data modify storage vr:config limits.max_y set value 1024
execute unless data storage vr:config limits.min_z run data modify storage vr:config limits.min_z set value -30000000
execute unless data storage vr:config limits.max_z run data modify storage vr:config limits.max_z set value 30000000
execute unless data storage vr:config limits.max_speed run data modify storage vr:config limits.max_speed set value 100.0
execute unless data storage vr:config materials.density_scale run data modify storage vr:config materials.density_scale set value 1.0
execute unless data storage vr:config materials.min_density run data modify storage vr:config materials.min_density set value 0.05
execute unless data storage vr:config materials.max_density run data modify storage vr:config materials.max_density set value 100.0
execute unless data storage vr:config materials.elasticity run data modify storage vr:config materials.elasticity set value 0.1
execute unless data storage vr:config audio.min_speed run data modify storage vr:config audio.min_speed set value 4.0
execute unless data storage vr:config audio.volume_scale run data modify storage vr:config audio.volume_scale set value 0.05
