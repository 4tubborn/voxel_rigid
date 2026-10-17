execute store result score #draw.t.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e4"]}}
execute store result score #draw.t.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e5"]}}
execute store result score #draw.t.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e6"]}}
function vr:render/voxel_0 with storage vr:work draw
