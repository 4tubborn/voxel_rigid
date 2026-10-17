scoreboard objectives add vr.num dummy
scoreboard objectives add vr.cfg dummy
scoreboard objectives add vr.i00 dummy
scoreboard objectives add vr.i01 dummy
scoreboard objectives add vr.i02 dummy
scoreboard objectives add vr.i10 dummy
scoreboard objectives add vr.i11 dummy
scoreboard objectives add vr.i12 dummy
scoreboard objectives add vr.i20 dummy
scoreboard objectives add vr.i21 dummy
scoreboard objectives add vr.i22 dummy
scoreboard objectives add vr.j00 dummy
scoreboard objectives add vr.j01 dummy
scoreboard objectives add vr.j02 dummy
scoreboard objectives add vr.j10 dummy
scoreboard objectives add vr.j11 dummy
scoreboard objectives add vr.j12 dummy
scoreboard objectives add vr.j20 dummy
scoreboard objectives add vr.j21 dummy
scoreboard objectives add vr.j22 dummy
scoreboard objectives add vr.k00 dummy
scoreboard objectives add vr.k01 dummy
scoreboard objectives add vr.k02 dummy
scoreboard objectives add vr.k10 dummy
scoreboard objectives add vr.k11 dummy
scoreboard objectives add vr.k12 dummy
scoreboard objectives add vr.k20 dummy
scoreboard objectives add vr.k21 dummy
scoreboard objectives add vr.k22 dummy
scoreboard objectives add vr.r00 dummy
scoreboard objectives add vr.r01 dummy
scoreboard objectives add vr.r02 dummy
scoreboard objectives add vr.r10 dummy
scoreboard objectives add vr.r11 dummy
scoreboard objectives add vr.r12 dummy
scoreboard objectives add vr.r20 dummy
scoreboard objectives add vr.r21 dummy
scoreboard objectives add vr.r22 dummy
scoreboard objectives add vr.count dummy
scoreboard objectives add vr.den dummy
scoreboard objectives add vr.e dummy
scoreboard objectives add vr.im dummy
scoreboard objectives add vr.mass dummy
scoreboard objectives add vr.mu dummy
scoreboard objectives add vr.ox dummy
scoreboard objectives add vr.oy dummy
scoreboard objectives add vr.oz dummy
scoreboard objectives add vr.px dummy
scoreboard objectives add vr.py dummy
scoreboard objectives add vr.pz dummy
scoreboard objectives add vr.oldox dummy
scoreboard objectives add vr.oldoy dummy
scoreboard objectives add vr.oldoz dummy
scoreboard objectives add vr.oldpx dummy
scoreboard objectives add vr.oldpy dummy
scoreboard objectives add vr.oldpz dummy
scoreboard objectives add vr.oldqw dummy
scoreboard objectives add vr.oldqx dummy
scoreboard objectives add vr.oldqy dummy
scoreboard objectives add vr.oldqz dummy
scoreboard objectives add vr.qw dummy
scoreboard objectives add vr.qx dummy
scoreboard objectives add vr.qy dummy
scoreboard objectives add vr.qz dummy
scoreboard objectives add vr.rad dummy
scoreboard objectives add vr.vx dummy
scoreboard objectives add vr.vy dummy
scoreboard objectives add vr.vz dummy
scoreboard objectives add vr.wx dummy
scoreboard objectives add vr.wy dummy
scoreboard objectives add vr.wz dummy
scoreboard players set #scale vr.num 10000
scoreboard objectives add vr.id dummy
scoreboard objectives add vr.voxel dummy
scoreboard objectives add vr.tmp dummy
scoreboard objectives add vr.stat dummy
execute unless score #next vr.id matches 0.. run scoreboard players set #next vr.id 0
execute unless data storage vr:config settings run data modify storage vr:config settings set value {enabled:1b}
data modify storage vr:work blank set value {}
scoreboard objectives add vr.input dummy
execute unless score #input_next vr.input matches 0.. run scoreboard players set #input_next vr.input 0
execute unless score #strength vr.input matches 1..10000 run scoreboard players set #strength vr.input 2000
scoreboard players set #minus_one vr.input -1
execute unless score #bookshelf vr.input matches 0..1 run scoreboard players set #bookshelf vr.input 0
scoreboard players set #ten vr.input 10
scoreboard objectives add vr.ec dummy
execute unless score #entity_enabled vr.cfg matches 0..1 run scoreboard players set #entity_enabled vr.cfg 0
execute unless score #entity_players vr.cfg matches 0..1 run scoreboard players set #entity_players vr.cfg 1
execute unless score #entity_tagged vr.cfg matches 0..1 run scoreboard players set #entity_tagged vr.cfg 1
execute unless score #entity_limit vr.cfg matches 1..64 run scoreboard players set #entity_limit vr.cfg 16
execute unless score #entity_push vr.cfg matches 1..10000 run scoreboard players set #entity_push vr.cfg 2000
function vr:config/defaults
scoreboard objectives add vr.updates dummy
scoreboard objectives add vr.prof dummy
execute unless score #query_mode vr.cfg matches 0..1 run scoreboard players set #query_mode vr.cfg 1
