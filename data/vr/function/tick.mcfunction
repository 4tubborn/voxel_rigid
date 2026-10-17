execute unless score #enabled vr.cfg matches 1 run return 0
execute unless score #ups vr.cfg matches 1..256 run return 0
scoreboard players set #sat vr.stat 0
scoreboard players set #bvh vr.stat 0
scoreboard players set #linear vr.stat 0
scoreboard players set #world vr.stat 0
scoreboard players set #contacts vr.stat 0
scoreboard players set #overflow vr.stat 0
scoreboard players set #pairs vr.stat 0
scoreboard players set #processed vr.stat 0
scoreboard players set #loaded vr.stat 0
scoreboard players set #pending vr.tmp 0
execute in minecraft:overworld run function vr:scheduler/count
execute in minecraft:the_nether run function vr:scheduler/count
execute in minecraft:the_end run function vr:scheduler/count
execute if score #loaded vr.stat matches 0 run return 0
execute if score #pending vr.tmp matches 0 run function vr:scheduler/new_round
scoreboard players operation #budget_left vr.tmp = #ups vr.cfg
execute in minecraft:overworld run function vr:scheduler/dimension
execute in minecraft:the_nether run function vr:scheduler/dimension
execute in minecraft:the_end run function vr:scheduler/dimension
