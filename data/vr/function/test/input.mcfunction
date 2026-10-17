scoreboard players set #ray.half vr.num 5000
scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 5000
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard players set #ray.u vr.num 0
scoreboard players set #ray.d vr.num 10000
scoreboard players set #ray.c vr.num 20000
scoreboard players set #ray.enter vr.num 0
scoreboard players set #ray.exit vr.num 30000
execute unless function vr:input/slab run return 1
execute store result score #ray_test vr.tmp run compute default float vr:e857 10000
execute unless score #ray_test vr.tmp matches 15000 run return 2
scoreboard players set #ray.u vr.num 6000
scoreboard players set #ray.c vr.num 0
scoreboard players set #ray.d vr.num 0
execute if function vr:input/slab run return 3
return 0
