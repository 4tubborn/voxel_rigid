execute store result score #frac_y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e545"]}}
execute store result score #surface vr.tmp run compute default float vr:e546 1000000
execute if block ~ ~ ~ minecraft:water[level=0] unless block ~ ~1 ~ minecraft:water if score #surface vr.tmp matches 888889.. run return 0
execute store result score #df.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e547"]}}
execute store result score #df.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e548"]}}
execute store result score #df.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e549"]}}
execute store result score #force.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e550"]}}
execute store result score #force.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e551"]}}
execute store result score #force.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e552"]}}
execute store result score #torque.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e553"]}}
execute store result score #torque.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e554"]}}
execute store result score #torque.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e555"]}}
execute store result score #wet vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e556"]}}
