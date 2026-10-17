$data modify storage vr:work bench.shape set value "$(shape)"
$scoreboard players set #bench_count vr.tmp $(repeats)
$execute store result score #bench_sep vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(separation)]}}
execute unless score #bench_count vr.tmp matches 1..16 run return 0
function vr:profile/fixture with storage vr:work bench
scoreboard players set #bvh_us vr.prof -1
scoreboard players set #linear_us vr.prof -1
function vr:profile/bvh_batch
function vr:profile/linear_batch
return 1
