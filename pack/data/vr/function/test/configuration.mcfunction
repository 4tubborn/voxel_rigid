scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 5000
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard objectives add vr.test dummy
scoreboard players set #config_fail vr.test 0
scoreboard players operation #save_ups vr.cfg = #ups vr.cfg
scoreboard players operation #save_substeps vr.cfg = #substeps vr.cfg
scoreboard players operation #save_solver vr.cfg = #solver vr.cfg
scoreboard players operation #save_step_ticks vr.cfg = #step_ticks vr.cfg
execute store result score #valid vr.test run function vr:api/configure {updates_per_second:32,substeps:2,solver_iterations:4,step_ticks:1}
execute unless score #valid vr.test matches 1 run scoreboard players add #config_fail vr.test 1
execute unless score #ups vr.cfg matches 32 run scoreboard players add #config_fail vr.test 1
execute store result score #invalid vr.test run function vr:api/set_budget {structures_per_tick:0}
execute unless score #invalid vr.test matches 0 run scoreboard players add #config_fail vr.test 1
execute unless score #ups vr.cfg matches 32 run scoreboard players add #config_fail vr.test 1
scoreboard players operation #ups vr.cfg = #save_ups vr.cfg
scoreboard players operation #substeps vr.cfg = #save_substeps vr.cfg
scoreboard players operation #solver vr.cfg = #save_solver vr.cfg
scoreboard players operation #step_ticks vr.cfg = #save_step_ticks vr.cfg
return run scoreboard players get #config_fail vr.test
