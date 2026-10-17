execute store result storage vr:work draw.tx float 0.0001 run scoreboard players get #draw.t.x vr.num
execute store result storage vr:work draw.ty float 0.0001 run scoreboard players get #draw.t.y vr.num
execute store result storage vr:work draw.tz float 0.0001 run scoreboard players get #draw.t.z vr.num
function vr:render/update_3 with storage vr:work draw
