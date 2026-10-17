execute store result score #sweep.limit vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e617"]}}
function vr:query/sweep_test
execute if score #sweep_hit vr.tmp matches 1 run scoreboard players operation #sweep.hi vr.num = #sweep.limit vr.num
execute if score #sweep_hit vr.tmp matches 0 run scoreboard players operation #sweep.lo vr.num = #sweep.limit vr.num
