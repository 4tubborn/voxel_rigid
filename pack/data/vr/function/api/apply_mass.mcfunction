execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0
execute if data entity @s data.material_density run return 0
data modify storage vr:work a set from entity @s data
scoreboard players operation #a.Ibody.r00 vr.num = @s vr.i00
scoreboard players operation #a.Ibody.r01 vr.num = @s vr.i01
scoreboard players operation #a.Ibody.r02 vr.num = @s vr.i02
scoreboard players operation #a.Ibody.r10 vr.num = @s vr.i10
scoreboard players operation #a.Ibody.r11 vr.num = @s vr.i11
scoreboard players operation #a.Ibody.r12 vr.num = @s vr.i12
scoreboard players operation #a.Ibody.r20 vr.num = @s vr.i20
scoreboard players operation #a.Ibody.r21 vr.num = @s vr.i21
scoreboard players operation #a.Ibody.r22 vr.num = @s vr.i22
scoreboard players operation #a.J.r00 vr.num = @s vr.j00
scoreboard players operation #a.J.r01 vr.num = @s vr.j01
scoreboard players operation #a.J.r02 vr.num = @s vr.j02
scoreboard players operation #a.J.r10 vr.num = @s vr.j10
scoreboard players operation #a.J.r11 vr.num = @s vr.j11
scoreboard players operation #a.J.r12 vr.num = @s vr.j12
scoreboard players operation #a.J.r20 vr.num = @s vr.j20
scoreboard players operation #a.J.r21 vr.num = @s vr.j21
scoreboard players operation #a.J.r22 vr.num = @s vr.j22
scoreboard players operation #a.count vr.num = @s vr.count
scoreboard players operation #a.mass vr.num = @s vr.mass
execute if data storage vr:work a{state:"static"} run return 0
execute store result score #mass_check vr.tmp run compute default float vr:e628 10000
execute unless score #mass_check vr.tmp matches 500..10000000 run return 0
execute store result score #mass_ratio vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e629"]}}
execute store result score #a.J.r00 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e630"]}}
execute store result score #a.J.r01 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e631"]}}
execute store result score #a.J.r02 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e632"]}}
execute store result score #a.J.r10 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e633"]}}
execute store result score #a.J.r11 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e634"]}}
execute store result score #a.J.r12 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e635"]}}
execute store result score #a.J.r20 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e636"]}}
execute store result score #a.J.r21 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e637"]}}
execute store result score #a.J.r22 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e638"]}}
execute store result score #a.Ibody.r00 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e639"]}}
execute store result score #a.Ibody.r01 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e640"]}}
execute store result score #a.Ibody.r02 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e641"]}}
execute store result score #a.Ibody.r10 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e642"]}}
execute store result score #a.Ibody.r11 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e643"]}}
execute store result score #a.Ibody.r12 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e644"]}}
execute store result score #a.Ibody.r20 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e645"]}}
execute store result score #a.Ibody.r21 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e646"]}}
execute store result score #a.Ibody.r22 vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e647"]}}
scoreboard players operation #a.mass vr.num = #requested_mass vr.num
execute store result score #a.inv_mass vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e648"]}}
execute store result score #a.density vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e649"]}}
scoreboard players operation @s vr.i00 = #a.Ibody.r00 vr.num
scoreboard players operation @s vr.i01 = #a.Ibody.r01 vr.num
scoreboard players operation @s vr.i02 = #a.Ibody.r02 vr.num
scoreboard players operation @s vr.i10 = #a.Ibody.r10 vr.num
scoreboard players operation @s vr.i11 = #a.Ibody.r11 vr.num
scoreboard players operation @s vr.i12 = #a.Ibody.r12 vr.num
scoreboard players operation @s vr.i20 = #a.Ibody.r20 vr.num
scoreboard players operation @s vr.i21 = #a.Ibody.r21 vr.num
scoreboard players operation @s vr.i22 = #a.Ibody.r22 vr.num
scoreboard players operation @s vr.j00 = #a.J.r00 vr.num
scoreboard players operation @s vr.j01 = #a.J.r01 vr.num
scoreboard players operation @s vr.j02 = #a.J.r02 vr.num
scoreboard players operation @s vr.j10 = #a.J.r10 vr.num
scoreboard players operation @s vr.j11 = #a.J.r11 vr.num
scoreboard players operation @s vr.j12 = #a.J.r12 vr.num
scoreboard players operation @s vr.j20 = #a.J.r20 vr.num
scoreboard players operation @s vr.j21 = #a.J.r21 vr.num
scoreboard players operation @s vr.j22 = #a.J.r22 vr.num
scoreboard players operation @s vr.den = #a.density vr.num
scoreboard players operation @s vr.im = #a.inv_mass vr.num
scoreboard players operation @s vr.mass = #a.mass vr.num
return 1
