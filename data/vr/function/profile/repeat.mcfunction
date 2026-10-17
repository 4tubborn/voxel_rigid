execute if score #bench_repeats vr.tmp matches ..0 run return 0
function vr:profile/dispatch with storage vr:work bench
scoreboard players remove #bench_repeats vr.tmp 1
return run function vr:profile/repeat
