execute unless data storage vr:work entity_geometry[0] run return 0
execute store result score #local.x vr.num run data get storage vr:work entity_geometry[0].c.x 10000
execute store result score #local.y vr.num run data get storage vr:work entity_geometry[0].c.y 10000
execute store result score #local.z vr.num run data get storage vr:work entity_geometry[0].c.z 10000
execute store result score #ah.x vr.num run data get storage vr:work entity_geometry[0].h.x 10000
execute store result score #ah.y vr.num run data get storage vr:work entity_geometry[0].h.y 10000
execute store result score #ah.z vr.num run data get storage vr:work entity_geometry[0].h.z 10000
function vr:entity/voxel
data remove storage vr:work entity_geometry[0]
return run function vr:entity/custom_loop
