execute store result score #outside vr.tmp run compute default float vr:e616 1000000
execute if score #outside vr.tmp matches 1.. run return 0
return 1
