execute unless data storage vr:work terrain.shape[0] run return 0
execute store result score #box.minx vr.num run data get storage vr:work terrain.shape[0][0] 10000
execute store result score #box.miny vr.num run data get storage vr:work terrain.shape[0][1] 10000
execute store result score #box.minz vr.num run data get storage vr:work terrain.shape[0][2] 10000
execute store result score #box.maxx vr.num run data get storage vr:work terrain.shape[0][3] 10000
execute store result score #box.maxy vr.num run data get storage vr:work terrain.shape[0][4] 10000
execute store result score #box.maxz vr.num run data get storage vr:work terrain.shape[0][5] 10000
scoreboard players set #box.offsetx vr.num 0
execute if data storage vr:work terrain.offset.x run execute store result score #box.offsetx vr.num run data get storage vr:work terrain.offset.x 10000
scoreboard players set #box.offsetz vr.num 0
execute if data storage vr:work terrain.offset.z run execute store result score #box.offsetz vr.num run data get storage vr:work terrain.offset.z 10000
execute store result score #bc.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e858"]}}
execute store result score #box.h.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e859"]}}
execute store result score #bc.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e860"]}}
execute store result score #box.h.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e861"]}}
execute store result score #bc.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e862"]}}
execute store result score #box.h.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e863"]}}
function vr:world/sat
execute if score #hit vr.tmp matches 1 run function vr:world/contact
data remove storage vr:work terrain.shape[0]
return run function vr:world/shape_loop
