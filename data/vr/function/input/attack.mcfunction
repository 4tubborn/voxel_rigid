advancement revoke @s only vr:input/attack
execute unless items entity @s weapon.mainhand *[minecraft:custom_data~{vr:{impulse_tool:1b}}] run return 0
execute if entity @s[gamemode=spectator] run return 0
execute store result score #reach vr.input run attribute @s minecraft:block_interaction_range get 10000
execute unless score #reach vr.input matches 1.. run return 0
scoreboard players operation #block_limit vr.input = #reach vr.input
execute if score #bookshelf vr.input matches 1 run function vr:input/bookshelf_view
execute at @s anchored eyes positioned ^ ^ ^ run function vr:input/cast
