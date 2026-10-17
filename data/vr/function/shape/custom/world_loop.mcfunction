execute unless data storage vr:work custom_a[0] run return 0
execute store result score #local.x vr.num run data get storage vr:work custom_a[0].c.x 10000
execute store result score #local.y vr.num run data get storage vr:work custom_a[0].c.y 10000
execute store result score #local.z vr.num run data get storage vr:work custom_a[0].c.z 10000
execute store result score #ah.x vr.num run data get storage vr:work custom_a[0].h.x 10000
execute store result score #ah.y vr.num run data get storage vr:work custom_a[0].h.y 10000
execute store result score #ah.z vr.num run data get storage vr:work custom_a[0].h.z 10000
function vr:world/voxel
data remove storage vr:work custom_a[0]
return run function vr:shape/custom/world_loop
