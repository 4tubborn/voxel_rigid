execute as @e[type=minecraft:block_display,tag=vr.display] if score @s vr.id = #converted_id vr.tmp run kill @s
execute as @e[type=minecraft:marker,tag=vr.root] if score @s vr.id = #converted_id vr.tmp run kill @s
return 0
