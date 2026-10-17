execute if score #contact_count vr.tmp matches 32.. run return run function vr:contact/overflow
scoreboard players operation #c.n.x vr.num = #best.n.x vr.num
scoreboard players operation #c.n.y vr.num = #best.n.y vr.num
scoreboard players operation #c.n.z vr.num = #best.n.z vr.num
scoreboard players operation #c.depth vr.num = #best.depth vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1117"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1118"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1119"]}}
execute store result score #sign vr.tmp run compute default float vr:e1120 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1121"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1122"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1123"]}}
execute store result score #sign vr.tmp run compute default float vr:e1124 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1125"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1126"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1127"]}}
execute store result score #sign vr.tmp run compute default float vr:e1128 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1129"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1130"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1131"]}}
scoreboard players operation #support_a.x vr.num = #support.x vr.num
scoreboard players operation #support_a.y vr.num = #support.y vr.num
scoreboard players operation #support_a.z vr.num = #support.z vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1132"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1133"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1134"]}}
execute store result score #sign vr.tmp run compute default float vr:e1135 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1136"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1137"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1138"]}}
execute store result score #sign vr.tmp run compute default float vr:e1139 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1140"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1141"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1142"]}}
execute store result score #sign vr.tmp run compute default float vr:e1143 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1144"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1145"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1146"]}}
scoreboard players operation #support_b.x vr.num = #support.x vr.num
scoreboard players operation #support_b.y vr.num = #support.y vr.num
scoreboard players operation #support_b.z vr.num = #support.z vr.num
execute store result score #c.point.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1147"]}}
execute store result score #c.point.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1148"]}}
execute store result score #c.point.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1149"]}}
function vr:audio/world
execute store result storage vr:work c.depth float 0.0001 run scoreboard players get #c.depth vr.num
execute store result storage vr:work c.n.x float 0.0001 run scoreboard players get #c.n.x vr.num
execute store result storage vr:work c.n.y float 0.0001 run scoreboard players get #c.n.y vr.num
execute store result storage vr:work c.n.z float 0.0001 run scoreboard players get #c.n.z vr.num
execute store result storage vr:work c.point.x float 0.0001 run scoreboard players get #c.point.x vr.num
execute store result storage vr:work c.point.y float 0.0001 run scoreboard players get #c.point.y vr.num
execute store result storage vr:work c.point.z float 0.0001 run scoreboard players get #c.point.z vr.num
data modify storage vr:work contacts append from storage vr:work c
scoreboard players add #contact_count vr.tmp 1
scoreboard players add #contacts vr.stat 1
