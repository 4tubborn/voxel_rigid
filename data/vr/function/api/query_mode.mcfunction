$scoreboard players set #new_query_mode vr.cfg $(mode)
execute unless score #new_query_mode vr.cfg matches 0..1 run return 0
scoreboard players operation #query_mode vr.cfg = #new_query_mode vr.cfg
return 1
