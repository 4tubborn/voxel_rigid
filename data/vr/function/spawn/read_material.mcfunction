function #bs.block:get_hardness
execute unless data storage bs:out block.hardness run return 0
execute store result score #material.hardness vr.num run data get storage bs:out block.hardness 10000
execute store result score #material.density vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1257"]}}
execute store result score #negative_hardness vr.tmp run compute default float vr:e1258 10000
data modify storage vr:work conversion.unbreakable set value 0b
execute if score #negative_hardness vr.tmp matches ..-1 run data modify storage vr:work conversion.unbreakable set value 1b
data remove storage vr:work conversion.sounds
function #bs.block:get_sounds
execute unless data storage bs:out block.sounds.hit run return 0
data modify storage vr:work conversion.sounds set from storage bs:out block.sounds
return 1
