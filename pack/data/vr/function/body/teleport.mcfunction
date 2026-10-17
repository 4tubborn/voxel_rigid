execute unless function vr:body/check_limits run return 0
execute store result storage vr:work tp.x float 0.0001 run scoreboard players get #a.p.x vr.num
execute store result storage vr:work tp.y float 0.0001 run scoreboard players get #a.p.y vr.num
execute store result storage vr:work tp.z float 0.0001 run scoreboard players get #a.p.z vr.num
execute store result storage vr:work tp.ox int 1 run scoreboard players get #a.o.x vr.num
execute store result storage vr:work tp.oy int 1 run scoreboard players get #a.o.y vr.num
execute store result storage vr:work tp.oz int 1 run scoreboard players get #a.o.z vr.num
function vr:body/tp_macro with storage vr:work tp
