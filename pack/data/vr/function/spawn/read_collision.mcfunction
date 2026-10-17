data modify storage bs:out hitbox set value {shape:[],offset:{x:0.0d,z:0.0d}}
function #bs.hitbox:get_block_collision
data modify storage vr:work conversion.collision set from storage bs:out hitbox
execute unless data storage vr:work conversion.collision.shape[0] run return 0
data modify storage vr:work conversion.boxes set value []
scoreboard players set #geometry_count vr.tmp 0
scoreboard players set #geometry.radius vr.num 0
function vr:spawn/collision_loop
execute if data storage vr:work conversion.collision.shape[0] run return 0
execute if score #geometry_count vr.tmp matches 1..64 run return 1
return 0
