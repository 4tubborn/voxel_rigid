scoreboard players add #world vr.stat 1
data modify storage bs:out hitbox set value {shape:[],offset:{x:0.0d,z:0.0d}}
function #bs.hitbox:get_block_collision
data modify storage vr:work terrain set from storage bs:out hitbox
function vr:world/shape_loop
