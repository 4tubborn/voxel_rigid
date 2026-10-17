$scoreboard players set #new_ups vr.cfg $(updates_per_second)
$scoreboard players set #new_substeps vr.cfg $(substeps)
$scoreboard players set #new_solver vr.cfg $(solver_iterations)
$scoreboard players set #new_step_ticks vr.cfg $(step_ticks)
execute unless score #new_ups vr.cfg matches 1..256 run return 0
execute unless score #new_substeps vr.cfg matches 1..8 run return 0
execute unless score #new_solver vr.cfg matches 1..16 run return 0
execute unless score #new_step_ticks vr.cfg matches 1..20 run return 0
scoreboard players operation #ups vr.cfg = #new_ups vr.cfg
scoreboard players operation #substeps vr.cfg = #new_substeps vr.cfg
scoreboard players operation #solver vr.cfg = #new_solver vr.cfg
scoreboard players operation #step_ticks vr.cfg = #new_step_ticks vr.cfg
return 1
