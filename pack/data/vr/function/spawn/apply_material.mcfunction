scoreboard players operation #requested_mass vr.num = #material.density vr.num
function vr:api/apply_mass
execute if data storage vr:work conversion{unbreakable:1b} run function vr:spawn/unbreakable
execute if data storage vr:work conversion.sounds run data modify entity @s data.sounds set from storage vr:work conversion.sounds
data modify entity @s data.unbreakable set from storage vr:work conversion.unbreakable
