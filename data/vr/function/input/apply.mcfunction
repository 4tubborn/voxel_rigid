data modify storage vr:work a set from entity @s data
scoreboard players operation #a.Ibody.r00 vr.num = @s vr.i00
scoreboard players operation #a.Ibody.r01 vr.num = @s vr.i01
scoreboard players operation #a.Ibody.r02 vr.num = @s vr.i02
scoreboard players operation #a.Ibody.r10 vr.num = @s vr.i10
scoreboard players operation #a.Ibody.r11 vr.num = @s vr.i11
scoreboard players operation #a.Ibody.r12 vr.num = @s vr.i12
scoreboard players operation #a.Ibody.r20 vr.num = @s vr.i20
scoreboard players operation #a.Ibody.r21 vr.num = @s vr.i21
scoreboard players operation #a.Ibody.r22 vr.num = @s vr.i22
scoreboard players operation #a.J.r00 vr.num = @s vr.j00
scoreboard players operation #a.J.r01 vr.num = @s vr.j01
scoreboard players operation #a.J.r02 vr.num = @s vr.j02
scoreboard players operation #a.J.r10 vr.num = @s vr.j10
scoreboard players operation #a.J.r11 vr.num = @s vr.j11
scoreboard players operation #a.J.r12 vr.num = @s vr.j12
scoreboard players operation #a.J.r20 vr.num = @s vr.j20
scoreboard players operation #a.J.r21 vr.num = @s vr.j21
scoreboard players operation #a.J.r22 vr.num = @s vr.j22
scoreboard players operation #a.K.r00 vr.num = @s vr.k00
scoreboard players operation #a.K.r01 vr.num = @s vr.k01
scoreboard players operation #a.K.r02 vr.num = @s vr.k02
scoreboard players operation #a.K.r10 vr.num = @s vr.k10
scoreboard players operation #a.K.r11 vr.num = @s vr.k11
scoreboard players operation #a.K.r12 vr.num = @s vr.k12
scoreboard players operation #a.K.r20 vr.num = @s vr.k20
scoreboard players operation #a.K.r21 vr.num = @s vr.k21
scoreboard players operation #a.K.r22 vr.num = @s vr.k22
scoreboard players operation #a.R.r00 vr.num = @s vr.r00
scoreboard players operation #a.R.r01 vr.num = @s vr.r01
scoreboard players operation #a.R.r02 vr.num = @s vr.r02
scoreboard players operation #a.R.r10 vr.num = @s vr.r10
scoreboard players operation #a.R.r11 vr.num = @s vr.r11
scoreboard players operation #a.R.r12 vr.num = @s vr.r12
scoreboard players operation #a.R.r20 vr.num = @s vr.r20
scoreboard players operation #a.R.r21 vr.num = @s vr.r21
scoreboard players operation #a.R.r22 vr.num = @s vr.r22
scoreboard players operation #a.count vr.num = @s vr.count
scoreboard players operation #a.density vr.num = @s vr.den
scoreboard players operation #a.e vr.num = @s vr.e
scoreboard players operation #a.inv_mass vr.num = @s vr.im
scoreboard players operation #a.mass vr.num = @s vr.mass
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
scoreboard players operation #a.radius vr.num = @s vr.rad
scoreboard players operation #a.v.x vr.num = @s vr.vx
scoreboard players operation #a.v.y vr.num = @s vr.vy
scoreboard players operation #a.v.z vr.num = @s vr.vz
scoreboard players operation #a.w.x vr.num = @s vr.wx
scoreboard players operation #a.w.y vr.num = @s vr.wy
scoreboard players operation #a.w.z vr.num = @s vr.wz
execute if data storage vr:work a{state:"static"} run return 0
function vr:math/matrix
function vr:math/inertia
execute store result score #ray.impulse.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e848"]}}
execute store result score #ray.impulse.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e849"]}}
execute store result score #ray.impulse.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e850"]}}
execute store result score #a.v.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e851"]}}
execute store result score #a.v.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e852"]}}
execute store result score #a.v.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e853"]}}
execute store result score #a.w.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e854"]}}
execute store result score #a.w.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e855"]}}
execute store result score #a.w.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e856"]}}
scoreboard players operation @s vr.i00 = #a.Ibody.r00 vr.num
scoreboard players operation @s vr.i01 = #a.Ibody.r01 vr.num
scoreboard players operation @s vr.i02 = #a.Ibody.r02 vr.num
scoreboard players operation @s vr.i10 = #a.Ibody.r10 vr.num
scoreboard players operation @s vr.i11 = #a.Ibody.r11 vr.num
scoreboard players operation @s vr.i12 = #a.Ibody.r12 vr.num
scoreboard players operation @s vr.i20 = #a.Ibody.r20 vr.num
scoreboard players operation @s vr.i21 = #a.Ibody.r21 vr.num
scoreboard players operation @s vr.i22 = #a.Ibody.r22 vr.num
scoreboard players operation @s vr.j00 = #a.J.r00 vr.num
scoreboard players operation @s vr.j01 = #a.J.r01 vr.num
scoreboard players operation @s vr.j02 = #a.J.r02 vr.num
scoreboard players operation @s vr.j10 = #a.J.r10 vr.num
scoreboard players operation @s vr.j11 = #a.J.r11 vr.num
scoreboard players operation @s vr.j12 = #a.J.r12 vr.num
scoreboard players operation @s vr.j20 = #a.J.r20 vr.num
scoreboard players operation @s vr.j21 = #a.J.r21 vr.num
scoreboard players operation @s vr.j22 = #a.J.r22 vr.num
scoreboard players operation @s vr.k00 = #a.K.r00 vr.num
scoreboard players operation @s vr.k01 = #a.K.r01 vr.num
scoreboard players operation @s vr.k02 = #a.K.r02 vr.num
scoreboard players operation @s vr.k10 = #a.K.r10 vr.num
scoreboard players operation @s vr.k11 = #a.K.r11 vr.num
scoreboard players operation @s vr.k12 = #a.K.r12 vr.num
scoreboard players operation @s vr.k20 = #a.K.r20 vr.num
scoreboard players operation @s vr.k21 = #a.K.r21 vr.num
scoreboard players operation @s vr.k22 = #a.K.r22 vr.num
scoreboard players operation @s vr.r00 = #a.R.r00 vr.num
scoreboard players operation @s vr.r01 = #a.R.r01 vr.num
scoreboard players operation @s vr.r02 = #a.R.r02 vr.num
scoreboard players operation @s vr.r10 = #a.R.r10 vr.num
scoreboard players operation @s vr.r11 = #a.R.r11 vr.num
scoreboard players operation @s vr.r12 = #a.R.r12 vr.num
scoreboard players operation @s vr.r20 = #a.R.r20 vr.num
scoreboard players operation @s vr.r21 = #a.R.r21 vr.num
scoreboard players operation @s vr.r22 = #a.R.r22 vr.num
scoreboard players operation @s vr.count = #a.count vr.num
scoreboard players operation @s vr.den = #a.density vr.num
scoreboard players operation @s vr.e = #a.e vr.num
scoreboard players operation @s vr.im = #a.inv_mass vr.num
scoreboard players operation @s vr.mass = #a.mass vr.num
scoreboard players operation @s vr.mu = #a.mu vr.num
scoreboard players operation @s vr.ox = #a.o.x vr.num
scoreboard players operation @s vr.oy = #a.o.y vr.num
scoreboard players operation @s vr.oz = #a.o.z vr.num
scoreboard players operation @s vr.px = #a.p.x vr.num
scoreboard players operation @s vr.py = #a.p.y vr.num
scoreboard players operation @s vr.pz = #a.p.z vr.num
scoreboard players operation @s vr.oldox = #a.previous.o.x vr.num
scoreboard players operation @s vr.oldoy = #a.previous.o.y vr.num
scoreboard players operation @s vr.oldoz = #a.previous.o.z vr.num
scoreboard players operation @s vr.oldpx = #a.previous.p.x vr.num
scoreboard players operation @s vr.oldpy = #a.previous.p.y vr.num
scoreboard players operation @s vr.oldpz = #a.previous.p.z vr.num
scoreboard players operation @s vr.oldqw = #a.previous.q.w vr.num
scoreboard players operation @s vr.oldqx = #a.previous.q.x vr.num
scoreboard players operation @s vr.oldqy = #a.previous.q.y vr.num
scoreboard players operation @s vr.oldqz = #a.previous.q.z vr.num
scoreboard players operation @s vr.qw = #a.q.w vr.num
scoreboard players operation @s vr.qx = #a.q.x vr.num
scoreboard players operation @s vr.qy = #a.q.y vr.num
scoreboard players operation @s vr.qz = #a.q.z vr.num
scoreboard players operation @s vr.rad = #a.radius vr.num
scoreboard players operation @s vr.vx = #a.v.x vr.num
scoreboard players operation @s vr.vy = #a.v.y vr.num
scoreboard players operation @s vr.vz = #a.v.z vr.num
scoreboard players operation @s vr.wx = #a.w.x vr.num
scoreboard players operation @s vr.wy = #a.w.y vr.num
scoreboard players operation @s vr.wz = #a.w.z vr.num
tag @s add vr.render_dirty
return 1
