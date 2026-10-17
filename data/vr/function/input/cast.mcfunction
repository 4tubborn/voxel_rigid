kill @e[type=minecraft:marker,tag=vr.input_probe]
tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit
summon minecraft:marker ~ ~ ~ {Tags:["vr.input_probe","vr.entity"]}
execute store result score #ray.best vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e825"]}}
scoreboard players set #ray_found vr.tmp 0
execute store result score #ray.search_radius vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e826"]}}
execute store result storage vr:work ray.search_radius float 0.0001 run scoreboard players get #ray.search_radius vr.num
function vr:input/candidates with storage vr:work ray
kill @e[type=minecraft:marker,tag=vr.input_probe]
execute if score #ray_found vr.tmp matches 0 run return 0
scoreboard players set #ray_steps vr.tmp 0
execute unless score #bookshelf vr.input matches 1 if function vr:input/occlusion run return run function vr:input/blocked
execute as @e[type=minecraft:marker,tag=vr.input_hit,limit=1] run function vr:input/apply
tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit
