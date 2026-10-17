scoreboard players set #ray.enter vr.num 0
scoreboard players operation #ray.exit vr.num = #ray.best vr.num
scoreboard players operation #ray.u vr.num = #ray.origin.x vr.num
scoreboard players operation #ray.d vr.num = #ray.direction.x vr.num
execute store result score #ray.c vr.num run data get storage vr:work ray.center.x 10000
execute store result score #ray.half vr.num run data get storage vr:work ray.h.x 10000
execute unless function vr:input/slab run return 0
scoreboard players operation #ray.u vr.num = #ray.origin.y vr.num
scoreboard players operation #ray.d vr.num = #ray.direction.y vr.num
execute store result score #ray.c vr.num run data get storage vr:work ray.center.y 10000
execute store result score #ray.half vr.num run data get storage vr:work ray.h.y 10000
execute unless function vr:input/slab run return 0
scoreboard players operation #ray.u vr.num = #ray.origin.z vr.num
scoreboard players operation #ray.d vr.num = #ray.direction.z vr.num
execute store result score #ray.c vr.num run data get storage vr:work ray.center.z 10000
execute store result score #ray.half vr.num run data get storage vr:work ray.h.z 10000
execute unless function vr:input/slab run return 0
execute store result score #ray_closer vr.tmp run compute default float vr:e833 1000000
execute if score #ray_found vr.tmp matches 1 if score #ray_closer vr.tmp matches ..0 run return 0
scoreboard players operation #ray.best vr.num = #ray.enter vr.num
execute store result score #ray.lever.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e834"]}}
execute store result score #ray.lever.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e835"]}}
execute store result score #ray.lever.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e836"]}}
execute store result score #ray.world_direction.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e837"]}}
execute store result score #ray.world_direction.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e838"]}}
execute store result score #ray.world_direction.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e839"]}}
tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit
tag @s add vr.input_hit
scoreboard players set #ray_found vr.tmp 1
return 1
