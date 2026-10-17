$scoreboard players set #new_budget vr.cfg $(structures_per_tick)
execute unless score #new_budget vr.cfg matches 1..256 run return 0
scoreboard players operation #ups vr.cfg = #new_budget vr.cfg
return 1
