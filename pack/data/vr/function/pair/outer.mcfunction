tag @s add vr.a
scoreboard players operation #aid vr.tmp = @s vr.id
execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen,distance=..17] if score @s vr.id > #aid vr.tmp run function vr:pair/body
tag @s remove vr.a
