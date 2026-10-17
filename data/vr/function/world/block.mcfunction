$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) unless loaded ~ ~ ~ run scoreboard players set #unloaded vr.tmp 1
$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) if loaded ~ ~ ~ unless block ~ ~ ~ #vr:terrain_empty run function vr:world/solid
