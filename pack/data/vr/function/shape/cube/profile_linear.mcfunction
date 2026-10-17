scoreboard players set #local.x vr.num 0
scoreboard players set #local.y vr.num 0
scoreboard players set #local.z vr.num 0
execute store result score #ac.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e726"]}}
execute store result score #ac.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e727"]}}
execute store result score #ac.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e728"]}}
function vr:shape/cube/linear
