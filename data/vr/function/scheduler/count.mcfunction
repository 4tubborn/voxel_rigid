tag @e[type=minecraft:marker,tag=vr.root] remove vr.impact_sound
execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:body/check_limits
execute store result score #local_count vr.tmp run execute if entity @e[type=minecraft:marker,tag=vr.root]
scoreboard players operation #loaded vr.stat += #local_count vr.tmp
execute store result score #local_pending vr.tmp run execute if entity @e[type=minecraft:marker,tag=vr.root,tag=!vr.round_done]
scoreboard players operation #pending vr.tmp += #local_pending vr.tmp
