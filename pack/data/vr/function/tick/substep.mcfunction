execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:body/integrate
execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen] at @s run function vr:body/world
execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen] at @s run function vr:pair/outer
