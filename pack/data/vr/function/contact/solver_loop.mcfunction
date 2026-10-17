execute if score #solverleft vr.tmp matches ..0 run return 0
data modify storage vr:work queue set from storage vr:work contacts
function vr:contact/loop
scoreboard players remove #solverleft vr.tmp 1
return run function vr:contact/solver_loop
