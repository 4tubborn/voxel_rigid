execute unless data storage vr:work queue[0] run return 0
execute store result score #c.depth vr.num run data get storage vr:work queue[0].depth 10000
execute store result score #c.n.x vr.num run data get storage vr:work queue[0].n.x 10000
execute store result score #c.n.y vr.num run data get storage vr:work queue[0].n.y 10000
execute store result score #c.n.z vr.num run data get storage vr:work queue[0].n.z 10000
execute store result score #c.point.x vr.num run data get storage vr:work queue[0].point.x 10000
execute store result score #c.point.y vr.num run data get storage vr:work queue[0].point.y 10000
execute store result score #c.point.z vr.num run data get storage vr:work queue[0].point.z 10000
data remove storage vr:work queue[0]
function vr:contact/impulse
return run function vr:contact/loop
