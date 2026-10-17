scoreboard players set #a.R.r00 vr.num 10000
scoreboard players set #a.R.r01 vr.num 0
scoreboard players set #a.R.r02 vr.num 0
scoreboard players set #a.R.r10 vr.num 0
scoreboard players set #a.R.r11 vr.num 10000
scoreboard players set #a.R.r12 vr.num 0
scoreboard players set #a.R.r20 vr.num 0
scoreboard players set #a.R.r21 vr.num 0
scoreboard players set #a.R.r22 vr.num 10000
scoreboard players set #b.R.r00 vr.num 10000
scoreboard players set #b.R.r01 vr.num 0
scoreboard players set #b.R.r02 vr.num 0
scoreboard players set #b.R.r10 vr.num 0
scoreboard players set #b.R.r11 vr.num 10000
scoreboard players set #b.R.r12 vr.num 0
scoreboard players set #b.R.r20 vr.num 0
scoreboard players set #b.R.r21 vr.num 0
scoreboard players set #b.R.r22 vr.num 10000
scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 2500
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard players set #ac.x vr.num 0
scoreboard players set #ac.y vr.num -2500
scoreboard players set #ac.z vr.num 0
scoreboard players set #bc.x vr.num 0
scoreboard players set #bc.y vr.num 6000
scoreboard players set #bc.z vr.num 0
execute if function vr:collision/sat run return 1
scoreboard players set #bc.x vr.num 0
scoreboard players set #bc.y vr.num 4000
scoreboard players set #bc.z vr.num 0
execute unless function vr:collision/sat run return 2
execute store result score #custom_depth vr.tmp run compute default float vr:e1227 10000
execute unless score #custom_depth vr.tmp matches 999..1001 run return 3
return 0
