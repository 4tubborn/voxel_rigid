execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
execute store result storage vr:work owner.id int 1 run scoreboard players get @s vr.id
function vr:api/remove_displays with storage vr:work owner
kill @s
