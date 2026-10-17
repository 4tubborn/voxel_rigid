execute if entity @s[gamemode=spectator] run return 0
data modify storage bs:out hitbox set value {width:0.0d,height:0.0d,depth:0.0d,scale:1.0d}
function #bs.hitbox:get_entity
data modify storage vr:work entity_box set from storage bs:out hitbox
execute store result score #entity.width vr.num run data get storage vr:work entity_box.width 10000
execute store result score #entity.height vr.num run data get storage vr:work entity_box.height 10000
execute store result score #entity.depth vr.num run data get storage vr:work entity_box.depth 10000
execute store result score #entity.scale vr.num run data get storage vr:work entity_box.scale 10000
execute store result score #entity_width vr.tmp run compute default float vr:e1229 10000
execute unless score #entity_width vr.tmp matches 1.. run return 0
execute summon minecraft:marker run tag @s add vr.entity_probe
scoreboard players operation #negative vr.tmp = #a.o.x vr.num
scoreboard players operation #negative vr.tmp *= #minus_one vr.input
execute store result storage vr:work entity_offset.x int 1 run scoreboard players get #negative vr.tmp
scoreboard players operation #negative vr.tmp = #a.o.y vr.num
scoreboard players operation #negative vr.tmp *= #minus_one vr.input
execute store result storage vr:work entity_offset.y int 1 run scoreboard players get #negative vr.tmp
scoreboard players operation #negative vr.tmp = #a.o.z vr.num
scoreboard players operation #negative vr.tmp *= #minus_one vr.input
execute store result storage vr:work entity_offset.z int 1 run scoreboard players get #negative vr.tmp
function vr:entity/translate with storage vr:work entity_offset
execute store result score #entity.feet.x vr.num run data get entity @e[type=minecraft:marker,tag=vr.entity_probe,limit=1] Pos[0] 10000
execute store result score #entity.feet.y vr.num run data get entity @e[type=minecraft:marker,tag=vr.entity_probe,limit=1] Pos[1] 10000
execute store result score #entity.feet.z vr.num run data get entity @e[type=minecraft:marker,tag=vr.entity_probe,limit=1] Pos[2] 10000
kill @e[type=minecraft:marker,tag=vr.entity_probe]
execute store result score #bh.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1230"]}}
execute store result score #bh.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1231"]}}
execute store result score #bh.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1232"]}}
execute store result score #bc.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1233"]}}
execute store result score #bc.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1234"]}}
execute store result score #bc.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1235"]}}
scoreboard players set #b.R.r00 vr.num 10000
scoreboard players set #b.R.r01 vr.num 0
scoreboard players set #b.R.r02 vr.num 0
scoreboard players set #b.R.r10 vr.num 0
scoreboard players set #b.R.r11 vr.num 10000
scoreboard players set #b.R.r12 vr.num 0
scoreboard players set #b.R.r20 vr.num 0
scoreboard players set #b.R.r21 vr.num 0
scoreboard players set #b.R.r22 vr.num 10000
scoreboard players set #entity.push.x vr.num 0
scoreboard players set #entity.push.y vr.num 0
scoreboard players set #entity.push.z vr.num 0
scoreboard players set #entity_contacts vr.tmp 0
function vr:entity/dispatch with storage vr:work a
execute unless score #entity_contacts vr.tmp matches 1.. run return 0
execute store result score #entity.push_length vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1236"]}}
execute store result score #entity.push_scale vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1237"]}}
execute store result score #entity.destination.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1238"]}}
execute store result score #entity.destination.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1239"]}}
execute store result score #entity.destination.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1240"]}}
execute store result storage vr:work entity.destination.ox int 1 run scoreboard players get #a.o.x vr.num
execute store result storage vr:work entity.destination.oy int 1 run scoreboard players get #a.o.y vr.num
execute store result storage vr:work entity.destination.oz int 1 run scoreboard players get #a.o.z vr.num
execute store result storage vr:work entity.destination.x float 0.0001 run scoreboard players get #entity.destination.x vr.num
execute store result storage vr:work entity.destination.y float 0.0001 run scoreboard players get #entity.destination.y vr.num
execute store result storage vr:work entity.destination.z float 0.0001 run scoreboard players get #entity.destination.z vr.num
function vr:entity/teleport with storage vr:work entity.destination
execute if function #bs.hitbox:is_entity_in_blocks_collision run return run function vr:entity/rollback
scoreboard players add #entity_hits vr.stat 1
return 1
