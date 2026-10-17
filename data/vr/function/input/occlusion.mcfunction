execute store result score #ray_remaining vr.tmp run compute default float vr:e847 1000000
execute if score #ray_remaining vr.tmp matches ..0 run return 0
execute unless loaded ~ ~ ~ run return 1
execute unless block ~ ~ ~ #vr:passable run return 1
scoreboard players add #ray_steps vr.tmp 1
return run execute positioned ^ ^ ^0.05 run function vr:input/occlusion
