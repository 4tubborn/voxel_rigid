execute store result score #shift vr.tmp run compute default float vr:e199 1
execute store result score #shift vr.num run scoreboard players get #shift vr.tmp
execute store result score #a.p.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e200"]}}
execute store result score #a.o.x vr.num run compute default integer {"type":"minecraft:add","inputs":[{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#a.o.x"},"score":"vr.num","fallback":0},{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#shift"},"score":"vr.num","fallback":0}]}
execute store result score #shift vr.tmp run compute default float vr:e201 1
execute store result score #shift vr.num run scoreboard players get #shift vr.tmp
execute store result score #a.p.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e202"]}}
execute store result score #a.o.y vr.num run compute default integer {"type":"minecraft:add","inputs":[{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#a.o.y"},"score":"vr.num","fallback":0},{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#shift"},"score":"vr.num","fallback":0}]}
execute store result score #shift vr.tmp run compute default float vr:e203 1
execute store result score #shift vr.num run scoreboard players get #shift vr.tmp
execute store result score #a.p.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e204"]}}
execute store result score #a.o.z vr.num run compute default integer {"type":"minecraft:add","inputs":[{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#a.o.z"},"score":"vr.num","fallback":0},{"type":"minecraft:score","target":{"type":"minecraft:fixed","name":"#shift"},"score":"vr.num","fallback":0}]}
