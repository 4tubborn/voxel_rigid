execute if score #budget_left vr.tmp matches ..0 run return 0
execute unless entity @e[type=minecraft:marker,tag=vr.root,tag=!vr.round_done] run return 0
tag @e[type=minecraft:marker,tag=vr.root] remove vr.selected
tag @e[type=minecraft:marker,tag=vr.root] remove vr.a
execute store result storage vr:work scheduling.budget int 1 run scoreboard players get #budget_left vr.tmp
function vr:scheduler/pick with storage vr:work scheduling
function vr:config/prepare
scoreboard players operation #subleft vr.tmp = #substeps vr.cfg
function vr:scheduler/substeps
execute as @e[type=minecraft:marker,tag=vr.root,tag=vr.selected] at @s run function vr:render/body
execute as @e[type=minecraft:marker,tag=vr.root,tag=vr.render_dirty,tag=!vr.selected] at @s run function vr:render/body
tag @e[type=minecraft:marker,tag=vr.root] remove vr.render_dirty
tag @e[type=minecraft:marker,tag=vr.root] remove vr.selected
