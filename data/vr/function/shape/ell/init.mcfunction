scoreboard players set @s vr.ec 1
data modify entity @s data set value {shape:"ell",state:"dynamic"}
scoreboard players set @s vr.i00 19833
scoreboard players set @s vr.i01 10500
scoreboard players set @s vr.i02 0
scoreboard players set @s vr.i10 10500
scoreboard players set @s vr.i11 47833
scoreboard players set @s vr.i12 0
scoreboard players set @s vr.i20 0
scoreboard players set @s vr.i21 0
scoreboard players set @s vr.i22 58333
scoreboard players set @s vr.j00 5705
scoreboard players set @s vr.j01 -1252
scoreboard players set @s vr.j02 0
scoreboard players set @s vr.j10 -1252
scoreboard players set @s vr.j11 2365
scoreboard players set @s vr.j12 0
scoreboard players set @s vr.j20 0
scoreboard players set @s vr.j21 0
scoreboard players set @s vr.j22 1714
scoreboard players set @s vr.k00 0
scoreboard players set @s vr.k01 0
scoreboard players set @s vr.k02 0
scoreboard players set @s vr.k10 0
scoreboard players set @s vr.k11 0
scoreboard players set @s vr.k12 0
scoreboard players set @s vr.k20 0
scoreboard players set @s vr.k21 0
scoreboard players set @s vr.k22 0
scoreboard players set @s vr.r00 10000
scoreboard players set @s vr.r01 0
scoreboard players set @s vr.r02 0
scoreboard players set @s vr.r10 0
scoreboard players set @s vr.r11 10000
scoreboard players set @s vr.r12 0
scoreboard players set @s vr.r20 0
scoreboard players set @s vr.r21 0
scoreboard players set @s vr.r22 10000
scoreboard players set @s vr.count 4
scoreboard players set @s vr.den 14000
scoreboard players set @s vr.e 1000
scoreboard players set @s vr.im 1786
scoreboard players set @s vr.mass 56000
scoreboard players set @s vr.mu 5500
scoreboard players set @s vr.ox 0
scoreboard players set @s vr.oy 0
scoreboard players set @s vr.oz 0
scoreboard players set @s vr.px 0
scoreboard players set @s vr.py 0
scoreboard players set @s vr.pz 0
scoreboard players set @s vr.oldox 0
scoreboard players set @s vr.oldoy 0
scoreboard players set @s vr.oldoz 0
scoreboard players set @s vr.oldpx 0
scoreboard players set @s vr.oldpy 0
scoreboard players set @s vr.oldpz 0
scoreboard players set @s vr.oldqw 0
scoreboard players set @s vr.oldqx 0
scoreboard players set @s vr.oldqy 0
scoreboard players set @s vr.oldqz 0
scoreboard players set @s vr.qw 10000
scoreboard players set @s vr.qx 0
scoreboard players set @s vr.qy 0
scoreboard players set @s vr.qz 0
scoreboard players set @s vr.rad 21408
scoreboard players set @s vr.vx 0
scoreboard players set @s vr.vy 0
scoreboard players set @s vr.vz 0
scoreboard players set @s vr.wx 0
scoreboard players set @s vr.wy 0
scoreboard players set @s vr.wz 0
scoreboard players add #next vr.id 1
scoreboard players operation @s vr.id = #next vr.id
data modify storage vr:work a set from entity @s data
scoreboard players operation #a.o.x vr.num = @s vr.ox
scoreboard players operation #a.o.y vr.num = @s vr.oy
scoreboard players operation #a.o.z vr.num = @s vr.oz
scoreboard players operation #a.p.x vr.num = @s vr.px
scoreboard players operation #a.p.y vr.num = @s vr.py
scoreboard players operation #a.p.z vr.num = @s vr.pz
scoreboard players operation #a.q.w vr.num = @s vr.qw
scoreboard players operation #a.q.x vr.num = @s vr.qx
scoreboard players operation #a.q.y vr.num = @s vr.qy
scoreboard players operation #a.q.z vr.num = @s vr.qz
execute store result score #a.o.x vr.num run data get entity @s Pos[0] 1
scoreboard players set #a.p.x vr.num 5000
execute store result score #a.o.y vr.num run data get entity @s Pos[1] 1
scoreboard players set #a.p.y vr.num 5000
execute store result score #a.o.z vr.num run data get entity @s Pos[2] 1
scoreboard players set #a.p.z vr.num 5000
scoreboard players operation @s vr.ox = #a.o.x vr.num
scoreboard players operation @s vr.oy = #a.o.y vr.num
scoreboard players operation @s vr.oz = #a.o.z vr.num
scoreboard players operation @s vr.px = #a.p.x vr.num
scoreboard players operation @s vr.py = #a.p.y vr.num
scoreboard players operation @s vr.pz = #a.p.z vr.num
execute store result storage vr:work owner.id int 1 run scoreboard players get @s vr.id
execute summon minecraft:block_display run function vr:shape/ell/display_0
execute summon minecraft:block_display run function vr:shape/ell/display_1
execute summon minecraft:block_display run function vr:shape/ell/display_2
execute summon minecraft:block_display run function vr:shape/ell/display_3
function vr:render/body
return 1
