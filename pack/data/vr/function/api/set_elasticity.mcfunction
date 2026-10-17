execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
$execute store result score #elasticity vr.tmp run compute default float $(elasticity) 10000
execute unless score #elasticity vr.tmp matches 0..10000 run return 0
scoreboard players operation @s vr.e = #elasticity vr.tmp
return 1
