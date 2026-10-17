execute unless data storage vr:work custom_ray[0] run return 0
data modify storage vr:work ray.center set from storage vr:work custom_ray[0].c
data modify storage vr:work ray.h set from storage vr:work custom_ray[0].h
function vr:input/voxel
data remove storage vr:work custom_ray[0]
return run function vr:shape/custom/ray_loop
