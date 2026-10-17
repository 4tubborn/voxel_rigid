$execute store result score #requested_mass vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(mass)]}}
return run function vr:api/apply_mass
