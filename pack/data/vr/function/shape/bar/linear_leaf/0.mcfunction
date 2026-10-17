scoreboard players set #node.x vr.num -10000
scoreboard players set #node.y vr.num 0
scoreboard players set #node.z vr.num 0
execute store result score #nc.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e656"]}}
execute store result score #nc.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e657"]}}
execute store result score #nc.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e658"]}}
execute store result score #bound vr.tmp run compute default float vr:e659 1000000
scoreboard players add #linear vr.stat 1
execute unless data storage vr:work a{shape:"custom"} if score #bound vr.tmp matches 1.. run return 0
scoreboard players operation #bc.x vr.num = #nc.x vr.num
scoreboard players operation #bc.y vr.num = #nc.y vr.num
scoreboard players operation #bc.z vr.num = #nc.z vr.num
function vr:collision/sat
execute if score #hit vr.tmp matches 1 run function vr:contact/append
