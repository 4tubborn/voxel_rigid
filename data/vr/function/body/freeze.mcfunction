tag @s add vr.frozen
scoreboard players operation #a.o.x vr.num = #a.previous.o.x vr.num
scoreboard players operation #a.o.y vr.num = #a.previous.o.y vr.num
scoreboard players operation #a.o.z vr.num = #a.previous.o.z vr.num
scoreboard players operation #a.p.x vr.num = #a.previous.p.x vr.num
scoreboard players operation #a.p.y vr.num = #a.previous.p.y vr.num
scoreboard players operation #a.p.z vr.num = #a.previous.p.z vr.num
scoreboard players operation #a.q.w vr.num = #a.previous.q.w vr.num
scoreboard players operation #a.q.x vr.num = #a.previous.q.x vr.num
scoreboard players operation #a.q.y vr.num = #a.previous.q.y vr.num
scoreboard players operation #a.q.z vr.num = #a.previous.q.z vr.num
scoreboard players set #a.v.x vr.num 0
scoreboard players set #a.v.y vr.num 0
scoreboard players set #a.v.z vr.num 0
scoreboard players set #a.w.x vr.num 0
scoreboard players set #a.w.y vr.num 0
scoreboard players set #a.w.z vr.num 0
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
return 0
