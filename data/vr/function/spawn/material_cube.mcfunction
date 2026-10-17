function #bs.block:lookup_type {type:"minecraft:oak_planks"}
execute unless data storage bs:out block.hardness run return 0
execute store result score #material.hardness vr.num run data get storage bs:out block.hardness 10000
execute store result score #requested_mass vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1259"]}}
function vr:api/apply_mass
execute if data storage bs:out block.sounds run data modify entity @s data.sounds set from storage bs:out block.sounds
execute store result score #negative_hardness vr.tmp run compute default float vr:e1260 10000
execute if score #negative_hardness vr.tmp matches ..-1 run function vr:spawn/unbreakable
