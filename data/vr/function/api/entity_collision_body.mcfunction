$scoreboard players set #ec vr.tmp $(enabled)
execute unless score #ec vr.tmp matches 0..1 run return 0
execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
scoreboard players operation @s vr.ec = #ec vr.tmp
return 1
