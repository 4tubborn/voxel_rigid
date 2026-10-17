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
function vr:math/matrix
execute store result storage vr:work draw.id int 1 run scoreboard players get @s vr.id
execute store result storage vr:work draw.ox int 1 run scoreboard players get #a.o.x vr.num
execute store result storage vr:work draw.px float 0.0001 run scoreboard players get #a.p.x vr.num
execute store result storage vr:work draw.oy int 1 run scoreboard players get #a.o.y vr.num
execute store result storage vr:work draw.py float 0.0001 run scoreboard players get #a.p.y vr.num
execute store result storage vr:work draw.oz int 1 run scoreboard players get #a.o.z vr.num
execute store result storage vr:work draw.pz float 0.0001 run scoreboard players get #a.p.z vr.num
execute store result storage vr:work draw.qx float 0.0001 run scoreboard players get #a.q.x vr.num
execute store result storage vr:work draw.qy float 0.0001 run scoreboard players get #a.q.y vr.num
execute store result storage vr:work draw.qz float 0.0001 run scoreboard players get #a.q.z vr.num
execute store result storage vr:work draw.qw float 0.0001 run scoreboard players get #a.q.w vr.num
function vr:dispatch/render with storage vr:work a
