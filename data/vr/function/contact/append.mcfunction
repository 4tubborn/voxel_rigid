execute if score #contact_count vr.tmp matches 32.. run return run function vr:contact/overflow
scoreboard players operation #c.n.x vr.num = #best.n.x vr.num
scoreboard players operation #c.n.y vr.num = #best.n.y vr.num
scoreboard players operation #c.n.z vr.num = #best.n.z vr.num
scoreboard players operation #c.depth vr.num = #best.depth vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1084"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1085"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1086"]}}
execute store result score #sign vr.tmp run compute default float vr:e1087 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1088"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1089"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1090"]}}
execute store result score #sign vr.tmp run compute default float vr:e1091 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1092"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1093"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1094"]}}
execute store result score #sign vr.tmp run compute default float vr:e1095 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1096"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1097"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1098"]}}
scoreboard players operation #support_a.x vr.num = #support.x vr.num
scoreboard players operation #support_a.y vr.num = #support.y vr.num
scoreboard players operation #support_a.z vr.num = #support.z vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1099"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1100"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1101"]}}
execute store result score #sign vr.tmp run compute default float vr:e1102 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1103"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1104"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1105"]}}
execute store result score #sign vr.tmp run compute default float vr:e1106 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1107"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1108"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1109"]}}
execute store result score #sign vr.tmp run compute default float vr:e1110 1000000
scoreboard players set #sgn vr.tmp 0
execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1
execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1
scoreboard players operation #sgn vr.num = #sgn vr.tmp
scoreboard players operation #sgn vr.num *= #scale vr.num
execute store result score #support.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1111"]}}
execute store result score #support.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1112"]}}
execute store result score #support.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1113"]}}
scoreboard players operation #support_b.x vr.num = #support.x vr.num
scoreboard players operation #support_b.y vr.num = #support.y vr.num
scoreboard players operation #support_b.z vr.num = #support.z vr.num
execute store result score #c.point.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1114"]}}
execute store result score #c.point.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1115"]}}
execute store result score #c.point.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1116"]}}
function vr:audio/pair
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
