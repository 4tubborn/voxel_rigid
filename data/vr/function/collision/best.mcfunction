scoreboard players operation #best.depth vr.num = #depth vr.num
scoreboard players operation #best.n.x vr.num = #n.x vr.num
scoreboard players operation #best.n.y vr.num = #n.y vr.num
scoreboard players operation #best.n.z vr.num = #n.z vr.num
execute store result score #sign vr.tmp run compute default float vr:e410 1000000
execute if score #sign vr.tmp matches ..-1 run execute store result score #best.n.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e411"]}}
execute if score #sign vr.tmp matches ..-1 run execute store result score #best.n.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e412"]}}
execute if score #sign vr.tmp matches ..-1 run execute store result score #best.n.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e413"]}}
