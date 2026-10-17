tag @s add vr.root
function vr:shape/cube/init
function vr:spawn/apply_material
data modify entity @s data.shape set value "custom"
data modify entity @s data.boxes set from storage vr:work conversion.boxes
execute store result score @s vr.rad run scoreboard players get #geometry.radius vr.num
scoreboard players operation #converted_id vr.tmp = @s vr.id
execute as @e[type=minecraft:block_display,tag=vr.display] if score @s vr.id = #converted_id vr.tmp run function vr:spawn/converted_display
