execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
data modify entity @s data.state set value "static"
scoreboard players set @s vr.j01 0
scoreboard players set @s vr.j12 0
scoreboard players set @s vr.im 0
scoreboard players set @s vr.wy 0
scoreboard players set @s vr.wz 0
scoreboard players set @s vr.j22 0
scoreboard players set @s vr.j20 0
scoreboard players set @s vr.j02 0
scoreboard players set @s vr.j10 0
scoreboard players set @s vr.j00 0
scoreboard players set @s vr.vx 0
scoreboard players set @s vr.j11 0
scoreboard players set @s vr.wx 0
scoreboard players set @s vr.vy 0
scoreboard players set @s vr.vz 0
scoreboard players set @s vr.j21 0
return 1
