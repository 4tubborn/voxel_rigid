execute unless data storage vr:work contacts[0] run return 0
function vr:math/inertia
scoreboard players operation #solverleft vr.tmp = #solver vr.cfg
function vr:contact/solver_loop
scoreboard players operation #count vr.num = #contact_count vr.tmp
scoreboard players operation #count vr.num *= #scale vr.num
data modify storage vr:work queue set from storage vr:work contacts
function vr:contact/correct_loop
