data merge entity @s {Tags:["vr.display","vr.entity"],block_state:{id:"minecraft:copper_block"},teleport_duration:1,interpolation_duration:1,view_range:1.0f,shadow_radius:0.0f}
function vr:render/assign with storage vr:work owner
scoreboard players set @s vr.voxel 1
