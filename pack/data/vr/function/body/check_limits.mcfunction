data modify storage vr:work a set from entity @s data
scoreboard players operation #a.o.x vr.num = @s vr.ox
scoreboard players operation #a.o.y vr.num = @s vr.oy
scoreboard players operation #a.o.z vr.num = @s vr.oz
scoreboard players operation #a.p.x vr.num = @s vr.px
scoreboard players operation #a.p.y vr.num = @s vr.py
scoreboard players operation #a.p.z vr.num = @s vr.pz
scoreboard players operation #a.v.x vr.num = @s vr.vx
scoreboard players operation #a.v.y vr.num = @s vr.vy
scoreboard players operation #a.v.z vr.num = @s vr.vz
execute store result score #local_whole vr.tmp run compute default float vr:e1247 1
scoreboard players operation #coordinate vr.tmp = @s vr.ox
scoreboard players operation #coordinate vr.tmp += #local_whole vr.tmp
execute store result score #limit vr.tmp run data get storage vr:config limits.min_x 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1248 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #limit vr.tmp run data get storage vr:config limits.max_x 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1249 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #local_whole vr.tmp run compute default float vr:e1250 1
scoreboard players operation #coordinate vr.tmp = @s vr.oy
scoreboard players operation #coordinate vr.tmp += #local_whole vr.tmp
execute store result score #limit vr.tmp run data get storage vr:config limits.min_y 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1251 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #limit vr.tmp run data get storage vr:config limits.max_y 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1252 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #local_whole vr.tmp run compute default float vr:e1253 1
scoreboard players operation #coordinate vr.tmp = @s vr.oz
scoreboard players operation #coordinate vr.tmp += #local_whole vr.tmp
execute store result score #limit vr.tmp run data get storage vr:config limits.min_z 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1254 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #limit vr.tmp run data get storage vr:config limits.max_z 1
scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp
execute if score #limit vr.tmp matches ..-1 run return run function vr:body/discard
execute store result score #fraction vr.tmp run compute default float vr:e1255 10000
execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches 1.. run return run function vr:body/discard
execute store result score #overspeed vr.tmp run compute default float vr:e1256 10000
execute if score #overspeed vr.tmp matches 1.. run return run function vr:body/discard
return 1
