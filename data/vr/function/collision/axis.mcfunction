execute store result score #length vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1066"]}}
execute store result score #deg vr.tmp run compute default float vr:e1067 1000000
execute if score #deg vr.tmp matches ..100 run return 1
execute store result score #n.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1068"]}}
execute store result score #n.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1069"]}}
execute store result score #n.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1070"]}}
execute store result score #signed vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1071"]}}
execute store result score #depth vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1072"]}}
execute store result score #sep vr.tmp run compute default float vr:e1073 1000000
execute if score #sep vr.tmp matches ..0 run return 0
execute store result score #better vr.tmp run compute default float vr:e1074 1000000
execute if score #better vr.tmp matches ..-1 run function vr:collision/best
return 1
