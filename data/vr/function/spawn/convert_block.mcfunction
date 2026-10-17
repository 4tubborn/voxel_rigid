execute unless loaded ~ ~ ~ run return 0
execute if block ~ ~ ~ #vr:conversion_disallowed run return 0
scoreboard players set #block_read vr.tmp 0
execute store success score #block_read vr.tmp run function #bs.block:get_block
execute unless score #block_read vr.tmp matches 1 run return 0
execute unless data storage bs:out block.type run return 0
data modify storage vr:work conversion.verify set value {type:"minecraft:air",state:""}
data modify storage vr:work conversion.verify.type set from storage bs:out block.type
execute if data storage bs:out block.state run data modify storage vr:work conversion.verify.state set from storage bs:out block.state
execute store result score #source_valid vr.tmp run function vr:spawn/validate_source with storage vr:work conversion.verify
execute unless score #source_valid vr.tmp matches 1 run return 0
data modify storage vr:work conversion.display set value {id:"minecraft:air",properties:{}}
data modify storage vr:work conversion.display.id set from storage bs:out block.type
execute if data storage bs:out block.properties run data modify storage vr:work conversion.display.properties set from storage bs:out block.properties
execute unless function vr:spawn/read_material run return 0
execute unless function vr:spawn/read_collision run return 0
scoreboard players set #converted vr.tmp 0
execute positioned ~0.5 ~0.5 ~0.5 summon minecraft:marker run function vr:spawn/converted_root
execute unless score #converted vr.tmp matches 1 run return run function vr:spawn/conversion_rollback
scoreboard players set #removed vr.tmp 0
execute store success score #removed vr.tmp run setblock ~ ~ ~ minecraft:air
execute unless score #removed vr.tmp matches 1 run return run function vr:spawn/conversion_rollback
return 1
