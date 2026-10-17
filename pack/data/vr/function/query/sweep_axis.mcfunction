execute store result score #length vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e602"]}}
execute store result score #deg vr.tmp run compute default float vr:e603 1000000
execute if score #deg vr.tmp matches ..100 run return 1
execute store result score #n.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e604"]}}
execute store result score #n.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e605"]}}
execute store result score #n.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e606"]}}
execute store result score #sweep.d vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e607"]}}
execute store result score #sweep.speed vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e608"]}}
execute store result score #sweep.radius vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e609"]}}
execute store result score #speed vr.tmp run compute default float vr:e610 1000000
execute if score #speed vr.tmp matches ..1 run return run function vr:query/sweep_parallel
execute store result score #sweep.t0 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e611"]}}
execute store result score #sweep.t1 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e612"]}}
execute store result score #sweep.enter vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e613"]}}
execute store result score #sweep.exit vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e614"]}}
execute store result score #interval vr.tmp run compute default float vr:e615 1000000
execute if score #interval vr.tmp matches 1.. run return 0
return 1
