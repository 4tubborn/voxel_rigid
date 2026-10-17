execute store result score #ray_outside vr.tmp run compute default float vr:e1166 1000000
execute if score #ray_outside vr.tmp matches 1.. run return 0
return 1
