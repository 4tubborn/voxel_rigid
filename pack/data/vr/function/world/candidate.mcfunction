execute store result score #query.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e346"]}}
execute store result storage vr:work query.ox int 1 run scoreboard players get #a.o.x vr.num
execute store result score #query.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e347"]}}
execute store result storage vr:work query.oy int 1 run scoreboard players get #a.o.y vr.num
execute store result score #query.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e348"]}}
execute store result storage vr:work query.oz int 1 run scoreboard players get #a.o.z vr.num
execute store result storage vr:work query.x float 0.0001 run scoreboard players get #query.x vr.num
execute store result storage vr:work query.y float 0.0001 run scoreboard players get #query.y vr.num
execute store result storage vr:work query.z float 0.0001 run scoreboard players get #query.z vr.num
function vr:world/block with storage vr:work query
