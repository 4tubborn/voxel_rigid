function vr:contact/velocity
execute store result score #vn vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e456"]}}
execute store result score #vn vr.tmp run compute default float vr:e457 1000000
execute if score #vn vr.tmp matches 0.. run return 0
execute store result score #bounce vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e458"]}}
execute if score #vn vr.tmp matches -80000.. run scoreboard players set #bounce vr.num 0
execute store result score #den vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e459"]}}
execute store result score #jn vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e460"]}}
execute store result score #imp.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e461"]}}
execute store result score #imp.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e462"]}}
execute store result score #imp.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e463"]}}
function vr:contact/apply
function vr:contact/velocity
execute store result score #vn vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e464"]}}
execute store result score #tan.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e465"]}}
execute store result score #tan.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e466"]}}
execute store result score #tan.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e467"]}}
execute store result score #tl vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e468"]}}
execute store result score #tl vr.tmp run compute default float vr:e469 1000000
execute if score #tl vr.tmp matches ..1 run return 0
execute store result score #tan.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e470"]}}
execute store result score #tan.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e471"]}}
execute store result score #tan.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e472"]}}
execute store result score #den vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e473"]}}
execute store result score #jt vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e474"]}}
execute store result score #imp.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e475"]}}
execute store result score #imp.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e476"]}}
execute store result score #imp.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e477"]}}
function vr:contact/apply
