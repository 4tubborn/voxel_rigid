execute unless score @s vr.input matches 1.. run function vr:input/assign
scoreboard players operation #owner vr.input = @s vr.input
scoreboard players set #boxes vr.tmp 0
execute as @e[type=minecraft:interaction,tag=vr.attack_input] if score @s vr.input = #owner vr.input run scoreboard players set #boxes vr.tmp 1
execute if score #boxes vr.tmp matches 0 run execute summon minecraft:interaction run function vr:input/new_box
execute as @e[type=minecraft:interaction,tag=vr.attack_input] if score @s vr.input = #owner vr.input run function vr:input/follow
