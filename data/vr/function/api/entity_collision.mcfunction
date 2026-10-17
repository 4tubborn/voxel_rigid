$scoreboard players set #new_entity_enabled vr.cfg $(enabled)
$scoreboard players set #new_entity_players vr.cfg $(players)
$scoreboard players set #new_entity_tagged vr.cfg $(tagged)
$scoreboard players set #new_entity_limit vr.cfg $(max_targets)
$execute store result score #new_entity_push vr.cfg run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(max_push)]}}
execute unless score #new_entity_enabled vr.cfg matches 0..1 run return 0
execute unless score #new_entity_players vr.cfg matches 0..1 run return 0
execute unless score #new_entity_tagged vr.cfg matches 0..1 run return 0
execute unless score #new_entity_limit vr.cfg matches 1..64 run return 0
execute unless score #new_entity_push vr.cfg matches 1..10000 run return 0
scoreboard players operation #entity_enabled vr.cfg = #new_entity_enabled vr.cfg
scoreboard players operation #entity_players vr.cfg = #new_entity_players vr.cfg
scoreboard players operation #entity_tagged vr.cfg = #new_entity_tagged vr.cfg
scoreboard players operation #entity_limit vr.cfg = #new_entity_limit vr.cfg
scoreboard players operation #entity_push vr.cfg = #new_entity_push vr.cfg
return 1
