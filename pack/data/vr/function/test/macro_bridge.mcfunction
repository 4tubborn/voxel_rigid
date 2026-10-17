scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 5000
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
scoreboard objectives add vr.test dummy
scoreboard players set #bridge_fail vr.test 0
data remove storage vr:work query
data remove storage vr:work sample
scoreboard players set #query.x vr.num 2500
execute store result storage vr:work query.x float 0.0001 run scoreboard players get #query.x vr.num
function vr:test/probe_parameter with storage vr:work query
execute unless score #probe vr.test matches 2500 run scoreboard players add #bridge_fail vr.test 1
function vr:test/stale_parameters {stale:123.0}
scoreboard players set #sample.x vr.num -5000
execute store result storage vr:work sample.x float 0.0001 run scoreboard players get #sample.x vr.num
function vr:test/probe_parameter with storage vr:work sample
execute unless score #probe vr.test matches -5000 run scoreboard players add #bridge_fail vr.test 1
return run scoreboard players get #bridge_fail vr.test
