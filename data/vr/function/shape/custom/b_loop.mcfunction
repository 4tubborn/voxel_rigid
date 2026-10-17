execute unless data storage vr:work custom_b[0] run return 0
execute store result score #b_local.x vr.num run data get storage vr:work custom_b[0].c.x 10000
execute store result score #b_local.y vr.num run data get storage vr:work custom_b[0].c.y 10000
execute store result score #b_local.z vr.num run data get storage vr:work custom_b[0].c.z 10000
execute store result score #bh.x vr.num run data get storage vr:work custom_b[0].h.x 10000
execute store result score #bh.y vr.num run data get storage vr:work custom_b[0].h.y 10000
execute store result score #bh.z vr.num run data get storage vr:work custom_b[0].h.z 10000
execute store result score #bc.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1157"]}}
execute store result score #bc.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1158"]}}
execute store result score #bc.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1159"]}}
function vr:collision/sat
execute if score #hit vr.tmp matches 1 run function vr:contact/append
data remove storage vr:work custom_b[0]
return run function vr:shape/custom/b_loop
