execute store result storage vr:work entity.feet.ox int 1 run scoreboard players get #a.o.x vr.num
execute store result storage vr:work entity.feet.oy int 1 run scoreboard players get #a.o.y vr.num
execute store result storage vr:work entity.feet.oz int 1 run scoreboard players get #a.o.z vr.num
execute store result storage vr:work entity.feet.x float 0.0001 run scoreboard players get #entity.feet.x vr.num
execute store result storage vr:work entity.feet.y float 0.0001 run scoreboard players get #entity.feet.y vr.num
execute store result storage vr:work entity.feet.z float 0.0001 run scoreboard players get #entity.feet.z vr.num
function vr:entity/teleport with storage vr:work entity.feet
return 0
