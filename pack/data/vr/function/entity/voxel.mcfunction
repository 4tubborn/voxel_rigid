execute store result score #ac.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1241"]}}
execute store result score #ac.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1242"]}}
execute store result score #ac.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1243"]}}
execute unless function vr:collision/sat run return 0
execute store result score #entity.push.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1244"]}}
execute store result score #entity.push.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1245"]}}
execute store result score #entity.push.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1246"]}}
scoreboard players add #entity_contacts vr.tmp 1
