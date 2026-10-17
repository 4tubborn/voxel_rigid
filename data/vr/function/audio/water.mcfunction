execute store result score #wet_now vr.tmp run compute default float vr:e1271 10000
execute if score #wet_now vr.tmp matches 1.. unless entity @s[tag=vr.wet] run playsound minecraft:entity.generic.splash block @a[distance=..32] ~ ~ ~ 1 1
execute if score #wet_now vr.tmp matches 1.. run tag @s add vr.wet
execute if score #wet_now vr.tmp matches 0 run tag @s remove vr.wet
