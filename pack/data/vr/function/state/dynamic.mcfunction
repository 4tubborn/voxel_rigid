function vr:math/matrix
scoreboard players set #force.x vr.num 0
scoreboard players set #force.y vr.num 0
scoreboard players set #force.z vr.num 0
scoreboard players set #torque.x vr.num 0
scoreboard players set #torque.y vr.num 0
scoreboard players set #torque.z vr.num 0
scoreboard players set #wet vr.num 0
scoreboard players set #flow.x vr.num 0
scoreboard players set #flow.y vr.num 0
scoreboard players set #flow.z vr.num 0
execute if data storage vr:config water_velocity run data modify storage vr:work flow set from storage vr:config water_velocity
execute if data storage vr:config water_velocity run execute store result score #flow.x vr.num run data get storage vr:work flow.x 10000
execute if data storage vr:config water_velocity run execute store result score #flow.y vr.num run data get storage vr:work flow.y 10000
execute if data storage vr:config water_velocity run execute store result score #flow.z vr.num run data get storage vr:work flow.z 10000
function vr:dispatch/fluid with storage vr:work a
function vr:audio/water
function vr:math/inertia
execute store result score #a.v.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e171"]}}
execute store result score #a.v.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e172"]}}
execute store result score #a.v.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e173"]}}
execute store result score #a.w.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e174"]}}
execute store result score #a.w.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e175"]}}
execute store result score #a.w.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e176"]}}
execute unless function vr:body/check_work_speed run return 0
execute store result score #speed vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e177"]}}
execute store result score #spin vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e178"]}}
execute store result score #vs vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e179"]}}
execute store result score #ws vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e180"]}}
execute store result score #a.v.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e181"]}}
execute store result score #a.v.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e182"]}}
execute store result score #a.v.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e183"]}}
execute store result score #a.w.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e184"]}}
execute store result score #a.w.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e185"]}}
execute store result score #a.w.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e186"]}}
execute store result score #a.p.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e187"]}}
execute store result score #a.p.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e188"]}}
execute store result score #a.p.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e189"]}}
execute store result score #qn.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e190"]}}
execute store result score #qn.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e191"]}}
execute store result score #qn.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e192"]}}
execute store result score #qn.w vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e193"]}}
execute store result score #qlen vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e194"]}}
execute store result score #a.q.x vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e195"]}}
execute store result score #a.q.y vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e196"]}}
execute store result score #a.q.z vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e197"]}}
execute store result score #a.q.w vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e198"]}}
function vr:math/matrix
function vr:body/rebase
