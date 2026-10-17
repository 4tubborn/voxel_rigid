scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard players set #node.x vr.num 0
scoreboard players set #node.y vr.num 0
scoreboard players set #node.z vr.num 0
execute store result score #nc.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e76"]}}
execute store result score #nc.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e77"]}}
execute store result score #nc.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e78"]}}
execute store result score #bound vr.tmp run compute default float vr:e79 1000000
scoreboard players add #bvh vr.stat 1
execute if score #bound vr.tmp matches 1.. run return 0
function vr:shape/raft/bvh/1
function vr:shape/raft/bvh/8
