scoreboard players set #sweep.limit vr.num 10000
execute unless function vr:query/sweep_test run return 0
execute store result storage vr:work sweep.exact float 0.0001 run scoreboard players get #sweep.enter vr.num
scoreboard players set #sweep.lo vr.num 0
scoreboard players set #sweep.hi vr.num 10000
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
function vr:query/bisect
scoreboard players operation #sweep.toi vr.num = #sweep.hi vr.num
return 1
