execute if score #subleft vr.tmp matches ..0 run return 0
execute as @e[type=minecraft:marker,tag=vr.root,tag=vr.selected] at @s run function vr:body/integrate
execute as @e[type=minecraft:marker,tag=vr.root,tag=vr.selected,tag=!vr.frozen] at @s run function vr:body/world
execute as @e[type=minecraft:marker,tag=vr.root,tag=vr.selected,tag=!vr.frozen] at @s run function vr:scheduler/pair_outer
execute if score #entity_enabled vr.cfg matches 1 as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen,tag=vr.selected] at @s run function vr:entity/body
scoreboard players remove #subleft vr.tmp 1
return run function vr:scheduler/substeps
