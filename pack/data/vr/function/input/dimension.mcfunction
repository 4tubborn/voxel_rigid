tag @e[type=minecraft:interaction,tag=vr.attack_input] remove vr.input_live
execute as @a[gamemode=!spectator] at @s if items entity @s weapon.mainhand *[minecraft:custom_data~{vr:{impulse_tool:1b}}] run function vr:input/player
kill @e[type=minecraft:interaction,tag=vr.attack_input,tag=!vr.input_live]
