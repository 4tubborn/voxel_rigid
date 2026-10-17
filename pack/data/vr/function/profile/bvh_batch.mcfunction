data modify storage vr:work bench.mode set value "bvh"
scoreboard players operation #bench_repeats vr.tmp = #bench_count vr.tmp
scoreboard players set #sat vr.stat 0
scoreboard players set #bvh vr.stat 0
scoreboard players set #linear vr.stat 0
scoreboard players set #contacts vr.stat 0
scoreboard players set #overflow vr.stat 0
stopwatch remove vr:geometry
stopwatch create vr:geometry
function vr:profile/geometry_repeat
execute store result score #bvh_us vr.prof run stopwatch query vr:geometry 1000000
stopwatch remove vr:geometry
scoreboard players operation #bvh_sat vr.prof = #sat vr.stat
scoreboard players operation #bvh_bvh vr.prof = #bvh vr.stat
scoreboard players operation #bvh_linear vr.prof = #linear vr.stat
scoreboard players operation #bvh_contacts vr.prof = #contacts vr.stat
scoreboard players operation #bvh_overflow vr.prof = #overflow vr.stat
