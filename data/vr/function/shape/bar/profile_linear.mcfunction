scoreboard players set #local.x vr.num -10000
scoreboard players set #local.y vr.num 0
scoreboard players set #local.z vr.num 0
execute store result score #ac.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e738"]}}
execute store result score #ac.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e739"]}}
execute store result score #ac.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e740"]}}
function vr:shape/bar/linear
scoreboard players set #local.x vr.num 0
scoreboard players set #local.y vr.num 0
scoreboard players set #local.z vr.num 0
execute store result score #ac.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e741"]}}
execute store result score #ac.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e742"]}}
execute store result score #ac.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e743"]}}
function vr:shape/bar/linear
scoreboard players set #local.x vr.num 10000
scoreboard players set #local.y vr.num 0
scoreboard players set #local.z vr.num 0
execute store result score #ac.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e744"]}}
execute store result score #ac.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e745"]}}
execute store result score #ac.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e746"]}}
function vr:shape/bar/linear
