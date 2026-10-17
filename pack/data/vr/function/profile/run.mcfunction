$data modify storage vr:work bench.entry set value "$(entry)"
$scoreboard players set #bench_repeats vr.tmp $(repeats)
execute unless score #bench_repeats vr.tmp matches 1..16 run return 0
scoreboard players set #elapsed_us vr.prof -1
stopwatch remove vr:profile
stopwatch create vr:profile
function vr:profile/repeat
execute store result score #elapsed_us vr.prof run stopwatch query vr:profile 1000000
stopwatch remove vr:profile
return run scoreboard players get #elapsed_us vr.prof
