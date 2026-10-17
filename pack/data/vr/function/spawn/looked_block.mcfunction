execute unless entity @s[type=minecraft:player] run return 0
execute store result storage vr:work conversion_view.reach double 0.0001 run attribute @s minecraft:block_interaction_range get 10000
return run function vr:spawn/looked_block_macro with storage vr:work conversion_view
