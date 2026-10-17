$execute store result score #requested_density vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(density)]}}
execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
data modify storage vr:work a set from entity @s data
scoreboard players operation #a.count vr.num = @s vr.count
execute store result score #requested_mass vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e650"]}}
return run function vr:api/apply_mass
