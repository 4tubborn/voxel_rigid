execute store result score #ray_parallel vr.tmp run compute default float vr:e1160 1000000
execute if score #ray_parallel vr.tmp matches ..100 run return run function vr:input/parallel
execute store result score #ray.t0 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1161"]}}
execute store result score #ray.t1 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1162"]}}
execute store result score #ray.enter vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1163"]}}
execute store result score #ray.exit vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1164"]}}
execute store result score #ray_interval vr.tmp run compute default float vr:e1165 1000000
execute if score #ray_interval vr.tmp matches 1.. run return 0
return 1
