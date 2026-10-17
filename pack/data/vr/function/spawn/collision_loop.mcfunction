execute unless data storage vr:work conversion.collision.shape[0] run return 0
execute if score #geometry_count vr.tmp matches 64.. run return 0
execute store result score #geometry.minx vr.num run data get storage vr:work conversion.collision.shape[0][0] 10000
execute store result score #geometry.miny vr.num run data get storage vr:work conversion.collision.shape[0][1] 10000
execute store result score #geometry.minz vr.num run data get storage vr:work conversion.collision.shape[0][2] 10000
execute store result score #geometry.maxx vr.num run data get storage vr:work conversion.collision.shape[0][3] 10000
execute store result score #geometry.maxy vr.num run data get storage vr:work conversion.collision.shape[0][4] 10000
execute store result score #geometry.maxz vr.num run data get storage vr:work conversion.collision.shape[0][5] 10000
scoreboard players set #geometry.offsetx vr.num 0
execute if data storage vr:work conversion.collision.offset.x run execute store result score #geometry.offsetx vr.num run data get storage vr:work conversion.collision.offset.x 10000
scoreboard players set #geometry.offsetz vr.num 0
execute if data storage vr:work conversion.collision.offset.z run execute store result score #geometry.offsetz vr.num run data get storage vr:work conversion.collision.offset.z 10000
execute store result score #geometry.c.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1150"]}}
execute store result score #geometry.h.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1151"]}}
execute store result score #geometry.c.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1152"]}}
execute store result score #geometry.h.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1153"]}}
execute store result score #geometry.c.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1154"]}}
execute store result score #geometry.h.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1155"]}}
execute store result score #geometry.radius vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1156"]}}
execute store result storage vr:work geometry.c.x float 0.0001 run scoreboard players get #geometry.c.x vr.num
execute store result storage vr:work geometry.c.y float 0.0001 run scoreboard players get #geometry.c.y vr.num
execute store result storage vr:work geometry.c.z float 0.0001 run scoreboard players get #geometry.c.z vr.num
data modify storage vr:work geometry.entry.c set from storage vr:work geometry.c
execute store result storage vr:work geometry.h.x float 0.0001 run scoreboard players get #geometry.h.x vr.num
execute store result storage vr:work geometry.h.y float 0.0001 run scoreboard players get #geometry.h.y vr.num
execute store result storage vr:work geometry.h.z float 0.0001 run scoreboard players get #geometry.h.z vr.num
data modify storage vr:work geometry.entry.h set from storage vr:work geometry.h
data modify storage vr:work conversion.boxes append from storage vr:work geometry.entry
scoreboard players add #geometry_count vr.tmp 1
data remove storage vr:work conversion.collision.shape[0]
return run function vr:spawn/collision_loop
