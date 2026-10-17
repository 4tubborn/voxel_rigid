execute store result score #overspeed vr.tmp run compute default float vr:e1275 10000
execute if score #overspeed vr.tmp matches 1.. run return run function vr:body/discard
return 1
