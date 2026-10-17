execute unless entity @e[type=minecraft:marker,tag=vr.root] run return 0
function vr:config/prepare
scoreboard players operation #subleft vr.tmp = #substeps vr.cfg
function vr:tick/substep_loop
execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:render/body
