data modify storage vr:work a set from entity @s data
scoreboard players operation #a.J.r00 vr.num = @s vr.j00
scoreboard players operation #a.J.r01 vr.num = @s vr.j01
scoreboard players operation #a.J.r02 vr.num = @s vr.j02
scoreboard players operation #a.J.r10 vr.num = @s vr.j10
scoreboard players operation #a.J.r11 vr.num = @s vr.j11
scoreboard players operation #a.J.r12 vr.num = @s vr.j12
scoreboard players operation #a.J.r20 vr.num = @s vr.j20
scoreboard players operation #a.J.r21 vr.num = @s vr.j21
scoreboard players operation #a.J.r22 vr.num = @s vr.j22
scoreboard players operation #a.R.r00 vr.num = @s vr.r00
scoreboard players operation #a.R.r01 vr.num = @s vr.r01
scoreboard players operation #a.R.r02 vr.num = @s vr.r02
scoreboard players operation #a.R.r10 vr.num = @s vr.r10
scoreboard players operation #a.R.r11 vr.num = @s vr.r11
scoreboard players operation #a.R.r12 vr.num = @s vr.r12
scoreboard players operation #a.R.r20 vr.num = @s vr.r20
scoreboard players operation #a.R.r21 vr.num = @s vr.r21
scoreboard players operation #a.R.r22 vr.num = @s vr.r22
scoreboard players operation #a.e vr.num = @s vr.e
scoreboard players operation #a.inv_mass vr.num = @s vr.im
scoreboard players operation #a.mu vr.num = @s vr.mu
scoreboard players operation #a.o.x vr.num = @s vr.ox
scoreboard players operation #a.o.y vr.num = @s vr.oy
scoreboard players operation #a.o.z vr.num = @s vr.oz
scoreboard players operation #a.p.x vr.num = @s vr.px
scoreboard players operation #a.p.y vr.num = @s vr.py
scoreboard players operation #a.p.z vr.num = @s vr.pz
scoreboard players operation #a.previous.o.x vr.num = @s vr.oldox
scoreboard players operation #a.previous.o.y vr.num = @s vr.oldoy
scoreboard players operation #a.previous.o.z vr.num = @s vr.oldoz
scoreboard players operation #a.previous.p.x vr.num = @s vr.oldpx
scoreboard players operation #a.previous.p.y vr.num = @s vr.oldpy
scoreboard players operation #a.previous.p.z vr.num = @s vr.oldpz
scoreboard players operation #a.previous.q.w vr.num = @s vr.oldqw
scoreboard players operation #a.previous.q.x vr.num = @s vr.oldqx
scoreboard players operation #a.previous.q.y vr.num = @s vr.oldqy
scoreboard players operation #a.previous.q.z vr.num = @s vr.oldqz
scoreboard players operation #a.q.w vr.num = @s vr.qw
scoreboard players operation #a.q.x vr.num = @s vr.qx
scoreboard players operation #a.q.y vr.num = @s vr.qy
scoreboard players operation #a.q.z vr.num = @s vr.qz
scoreboard players operation #a.v.x vr.num = @s vr.vx
scoreboard players operation #a.v.y vr.num = @s vr.vy
scoreboard players operation #a.v.z vr.num = @s vr.vz
scoreboard players operation #a.w.x vr.num = @s vr.wx
scoreboard players operation #a.w.y vr.num = @s vr.wy
scoreboard players operation #a.w.z vr.num = @s vr.wz
execute if data storage vr:work a{state:"static"} run return 0
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
scoreboard players set #bp.x vr.num 0
scoreboard players set #bp.y vr.num 0
scoreboard players set #bp.z vr.num 0
data modify storage vr:work contacts set value []
scoreboard players set #contact_count vr.tmp 0
scoreboard players set #unloaded vr.tmp 0
function vr:dispatch/world with storage vr:work a
execute if score #unloaded vr.tmp matches 1 run return run function vr:body/freeze
function vr:contact/solve_all
scoreboard players operation @s vr.ox = #a.o.x vr.num
scoreboard players operation @s vr.oy = #a.o.y vr.num
scoreboard players operation @s vr.oz = #a.o.z vr.num
scoreboard players operation @s vr.px = #a.p.x vr.num
scoreboard players operation @s vr.py = #a.p.y vr.num
scoreboard players operation @s vr.pz = #a.p.z vr.num
scoreboard players operation @s vr.qw = #a.q.w vr.num
scoreboard players operation @s vr.qx = #a.q.x vr.num
scoreboard players operation @s vr.qy = #a.q.y vr.num
scoreboard players operation @s vr.qz = #a.q.z vr.num
scoreboard players operation @s vr.vx = #a.v.x vr.num
scoreboard players operation @s vr.vy = #a.v.y vr.num
scoreboard players operation @s vr.vz = #a.v.z vr.num
scoreboard players operation @s vr.wx = #a.w.x vr.num
scoreboard players operation @s vr.wy = #a.w.y vr.num
scoreboard players operation @s vr.wz = #a.w.z vr.num
function vr:body/teleport
