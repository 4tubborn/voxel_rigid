execute if score #bench_repeats vr.tmp matches ..0 run return 0
data modify storage vr:work contacts set value []
scoreboard players set #contact_count vr.tmp 0
function vr:profile/geometry_dispatch with storage vr:work bench
scoreboard players remove #bench_repeats vr.tmp 1
return run function vr:profile/geometry_repeat
