scoreboard players set #ah.x vr.num 5000
scoreboard players set #ah.y vr.num 5000
scoreboard players set #ah.z vr.num 5000
scoreboard players set #bh.x vr.num 5000
scoreboard players set #bh.y vr.num 5000
scoreboard players set #bh.z vr.num 5000
$data modify storage vr:work query set value {x:$(stale)f,y:$(stale)f,z:$(stale)f}
$data modify storage vr:work sample set value {x:$(stale)f,y:$(stale)f,z:$(stale)f}
