data modify storage vr:work bench.mode set value "linear"
scoreboard players operation #bench_repeats vr.tmp = #bench_count vr.tmp
scoreboard players set #sat vr.stat 0
scoreboard players set #bvh vr.stat 0
scoreboard players set #linear vr.stat 0
scoreboard players set #contacts vr.stat 0
scoreboard players set #overflow vr.stat 0
stopwatch remove vr:geometry
stopwatch create vr:geometry
function vr:profile/geometry_repeat
execute store result score #linear_us vr.prof run stopwatch query vr:geometry 1000000
stopwatch remove vr:geometry
scoreboard players operation #linear_sat vr.prof = #sat vr.stat
scoreboard players operation #linear_bvh vr.prof = #bvh vr.stat
scoreboard players operation #linear_linear vr.prof = #linear vr.stat
scoreboard players operation #linear_contacts vr.prof = #contacts vr.stat
scoreboard players operation #linear_overflow vr.prof = #overflow vr.stat
