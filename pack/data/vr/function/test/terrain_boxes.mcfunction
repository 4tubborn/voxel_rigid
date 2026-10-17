scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 5000
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard players set #a.R.r00 vr.num 10000
scoreboard players set #a.R.r01 vr.num 0
scoreboard players set #a.R.r02 vr.num 0
scoreboard players set #a.R.r10 vr.num 0
scoreboard players set #a.R.r11 vr.num 10000
scoreboard players set #a.R.r12 vr.num 0
scoreboard players set #a.R.r20 vr.num 0
scoreboard players set #a.R.r21 vr.num 0
scoreboard players set #a.R.r22 vr.num 10000
scoreboard players set #b.Ibody.r00 vr.num 0
scoreboard players set #b.Ibody.r01 vr.num 0
scoreboard players set #b.Ibody.r02 vr.num 0
scoreboard players set #b.Ibody.r10 vr.num 0
scoreboard players set #b.Ibody.r11 vr.num 0
scoreboard players set #b.Ibody.r12 vr.num 0
scoreboard players set #b.Ibody.r20 vr.num 0
scoreboard players set #b.Ibody.r21 vr.num 0
scoreboard players set #b.Ibody.r22 vr.num 0
scoreboard players set #b.J.r00 vr.num 0
scoreboard players set #b.J.r01 vr.num 0
scoreboard players set #b.J.r02 vr.num 0
scoreboard players set #b.J.r10 vr.num 0
scoreboard players set #b.J.r11 vr.num 0
scoreboard players set #b.J.r12 vr.num 0
scoreboard players set #b.J.r20 vr.num 0
scoreboard players set #b.J.r21 vr.num 0
scoreboard players set #b.J.r22 vr.num 0
scoreboard players set #b.K.r00 vr.num 0
scoreboard players set #b.K.r01 vr.num 0
scoreboard players set #b.K.r02 vr.num 0
scoreboard players set #b.K.r10 vr.num 0
scoreboard players set #b.K.r11 vr.num 0
scoreboard players set #b.K.r12 vr.num 0
scoreboard players set #b.K.r20 vr.num 0
scoreboard players set #b.K.r21 vr.num 0
scoreboard players set #b.K.r22 vr.num 0
scoreboard players set #b.R.r00 vr.num 10000
scoreboard players set #b.R.r01 vr.num 0
scoreboard players set #b.R.r02 vr.num 0
scoreboard players set #b.R.r10 vr.num 0
scoreboard players set #b.R.r11 vr.num 10000
scoreboard players set #b.R.r12 vr.num 0
scoreboard players set #b.R.r20 vr.num 0
scoreboard players set #b.R.r21 vr.num 0
scoreboard players set #b.R.r22 vr.num 10000
scoreboard players set #b.count vr.num 0
scoreboard players set #b.density vr.num 0
scoreboard players set #b.e vr.num 1000
scoreboard players set #b.inv_mass vr.num 0
scoreboard players set #b.mass vr.num 0
scoreboard players set #b.mu vr.num 6500
scoreboard players set #b.o.x vr.num 0
scoreboard players set #b.o.y vr.num 0
scoreboard players set #b.o.z vr.num 0
scoreboard players set #b.p.x vr.num 0
scoreboard players set #b.p.y vr.num 0
scoreboard players set #b.p.z vr.num 0
scoreboard players set #b.previous.o.x vr.num 0
scoreboard players set #b.previous.o.y vr.num 0
scoreboard players set #b.previous.o.z vr.num 0
scoreboard players set #b.previous.p.x vr.num 0
scoreboard players set #b.previous.p.y vr.num 0
scoreboard players set #b.previous.p.z vr.num 0
scoreboard players set #b.previous.q.w vr.num 0
scoreboard players set #b.previous.q.x vr.num 0
scoreboard players set #b.previous.q.y vr.num 0
scoreboard players set #b.previous.q.z vr.num 0
scoreboard players set #b.q.w vr.num 0
scoreboard players set #b.q.x vr.num 0
scoreboard players set #b.q.y vr.num 0
scoreboard players set #b.q.z vr.num 0
scoreboard players set #b.radius vr.num 0
scoreboard players set #b.v.x vr.num 0
scoreboard players set #b.v.y vr.num 0
scoreboard players set #b.v.z vr.num 0
scoreboard players set #b.w.x vr.num 0
scoreboard players set #b.w.y vr.num 0
scoreboard players set #b.w.z vr.num 0
scoreboard players set #query.x vr.num 0
scoreboard players set #query.y vr.num 0
scoreboard players set #query.z vr.num 0
data modify storage vr:work contacts set value []
scoreboard players set #contact_count vr.tmp 0
scoreboard players set #ac.x vr.num 5000
scoreboard players set #ac.y vr.num 12000
scoreboard players set #ac.z vr.num 5000
data modify storage vr:work terrain set value {shape:[[0,0,0,16,8,16]]}
function vr:world/shape_loop
execute unless score #contact_count vr.tmp matches 0 run return 1
scoreboard players set #ac.x vr.num 5000
scoreboard players set #ac.y vr.num 9000
scoreboard players set #ac.z vr.num 5000
data modify storage vr:work terrain set value {shape:[[0,0,0,16,8,16]]}
function vr:world/shape_loop
execute unless score #contact_count vr.tmp matches 1 run return 2
execute store result score #terrain_depth vr.tmp run compute default float vr:e1065 10000
execute unless score #terrain_depth vr.tmp matches 999..1001 run return 3
return 0
