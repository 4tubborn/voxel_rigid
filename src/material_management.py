"""Material creation, safety limits and contact audio; before score lowering."""
def amend(name, old, new):
 p=F/(name+'.mcfunction');s=p.read_text();assert old in s,name;write(p,s.replace(old,new))

# Config stays in storage: bounds must never be multiplied by the score scale.
defaults={'limits':{ 'min_x':-30000000,'max_x':30000000,'min_y':-128,'max_y':1024,'min_z':-30000000,'max_z':30000000,'max_speed':100.0},'materials':{'density_scale':1.0,'min_density':0.05,'max_density':100.0,'elasticity':0.1},'audio':{'min_speed':4.0,'volume_scale':0.05}}
for group,values in defaults.items():
 for key,value in values.items():
  with (F/'config/defaults.mcfunction').open('a') as out:out.write(f'execute unless data storage vr:config {group}.{key} run data modify storage vr:config {group}.{key} set value {value}\n')
def config(path):return {'type':'minecraft:storage','storage':'vr:config','path':path,'fallback':0.0}
ls=['data modify storage vr:work a set from entity @s data']
# Compare integer origins separately from local fractional position to retain
# boundary precision even at 30 million blocks (float providers are float32).
for x in AX:
 ls += [score('local_whole',op('floor',S('a.p.'+x)),1),f'scoreboard players operation #coordinate vr.tmp = @s vr.o{x}','scoreboard players operation #coordinate vr.tmp += #local_whole vr.tmp']
 for side,sign in [('min',-1),('max',1)]:
  ls += [f'execute store result score #limit vr.tmp run data get storage vr:config limits.{side}_{x} 1','scoreboard players operation #limit vr.tmp -= #coordinate vr.tmp',f'execute if score #limit vr.tmp matches {"1.." if sign<0 else "..-1"} run return run function vr:body/discard',score('fraction',sub(S('a.p.'+x),op('floor',S('a.p.'+x))),10000),f'execute if score #limit vr.tmp matches 0 if score #fraction vr.tmp matches {"..-1" if sign<0 else "1.."} run return run function vr:body/discard']
ls += [score('overspeed',sub(mul(20.,norm(vec('a.v'))),config('limits.max_speed')),10000),'execute if score #overspeed vr.tmp matches 1.. run return run function vr:body/discard','return 1']
fn('body/discard','function vr:api/remove','return 0')
fn('body/check_limits',ls)
amend('body/integrate','tag @s remove vr.frozen','execute unless function vr:body/check_limits run return 0\ntag @s remove vr.frozen')
# All loaded roots, including static/unselected partners, get checked once/tick.
amend('scheduler/count','execute store result score #local_count','execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:body/check_limits\nexecute store result score #local_count')

fn('api/set_elasticity','execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','$execute store result score #elasticity vr.tmp run compute default float $(elasticity) 10000','execute unless score #elasticity vr.tmp matches 0..10000 run return 0','scoreboard players operation @s vr.e = #elasticity vr.tmp','return 1')
# A high restitution body must also bounce against low restitution terrain.
p=F/'contact/impulse.mcfunction';s=p.read_text();write(p,s.replace('"minecraft:min"','"minecraft:max"',1))
# The restitution expression is a named provider, change the provider itself.
for n,e in providers.items():
 if e==mn(S('a.e'),S('b.e')):providers[n]=clamp(mx(S('a.e'),S('b.e')),0.,1.);js(P/(n+'.json'),providers[n])

# Read hardness before creating anything. Store outputs immediately; later
# Bookshelf calls may merge/replace their shared output.
fn('spawn/read_material','execute unless function #bs.block:get_hardness run return 0','execute unless data storage bs:out block.hardness run return 0','execute store result storage vr:work material.hardness float 0.0001 run data get storage bs:out block.hardness 10000',calc('material.density',clamp(mul(S('material.hardness'),config('materials.density_scale')),config('materials.min_density'),config('materials.max_density'))),score('negative_hardness',S('material.hardness'),10000),'data modify storage vr:work conversion.unbreakable set value 0b','execute if score #negative_hardness vr.tmp matches ..-1 run data modify storage vr:work conversion.unbreakable set value 1b','data remove storage vr:work conversion.sounds','execute if function #bs.block:get_sounds run data modify storage vr:work conversion.sounds set from storage bs:out block.sounds','return 1')
amend('spawn/convert_block','execute unless function vr:spawn/read_collision run return 0','execute unless function vr:spawn/read_material run return 0\nexecute unless function vr:spawn/read_collision run return 0')
fn('spawn/apply_material',cp('requested_mass','material.density'),'function vr:api/apply_mass','execute if data storage vr:work conversion{unbreakable:1b} run function vr:spawn/unbreakable','execute if data storage vr:work conversion.sounds run data modify entity @s data.sounds set from storage vr:work conversion.sounds','data modify entity @s data.unbreakable set from storage vr:work conversion.unbreakable')
# Negative hardness is effectively infinite at 1e-4 inverse-mass resolution.
# Preserve its exact material density separately, without overflowing vr.mass.
fn('spawn/unbreakable','data modify entity @s data.material_density set value 2147483647','execute store result entity @s data.material_mass double 2147483647 run scoreboard players get @s vr.count','scoreboard players set @s vr.mass 2147483647','scoreboard players set @s vr.den 2147483647','scoreboard players set @s vr.im 0',[f'scoreboard players set @s vr.j{i}{j} 0' for i in range(3) for j in range(3)])
amend('spawn/converted_root','function vr:shape/cube/init','function vr:shape/cube/init\nfunction vr:spawn/apply_material')
# Built-in shapes use virtual block lookup: their display material need not
# exist at the spawn position. Conversion still uses the positional getters.
for name,shape in shapes.items():
 fn(f'spawn/material_{name}',f'function #bs.block:lookup_type {{type:"{shape["block"]}"}}','execute unless data storage bs:out block.hardness run return 0','execute store result storage vr:work material.hardness float 0.0001 run data get storage bs:out block.hardness 10000',calc('requested_mass',mul(float(len(shape['voxels'])),clamp(mul(S('material.hardness'),config('materials.density_scale')),config('materials.min_density'),config('materials.max_density')))),'function vr:api/apply_mass','execute if data storage bs:out block.sounds run data modify entity @s data.sounds set from storage bs:out block.sounds',score('negative_hardness',S('material.hardness'),10000),'execute if score #negative_hardness vr.tmp matches ..-1 run function vr:spawn/unbreakable')
 amend(f'spawn/new_{name}',f'return run function vr:shape/{name}/init',f'function vr:shape/{name}/init\nfunction vr:spawn/material_{name}\nreturn 1')
for name in shapes:
 amend(f'shape/{name}/init','return 1',score('elasticity',clamp(config('materials.elasticity'),0.,1.),10000)+'\nscoreboard players operation @s vr.e = #elasticity vr.tmp\nreturn 1')

# Wet tag survives substeps; splash only on the dry-to-wet transition.
fn('audio/water',score('wet_now',S('wet'),10000),'execute if score #wet_now vr.tmp matches 1.. unless entity @s[tag=vr.wet] run playsound minecraft:entity.generic.splash block @a[distance=..32] ~ ~ ~ 1 1','execute if score #wet_now vr.tmp matches 1.. run tag @s add vr.wet','execute if score #wet_now vr.tmp matches 0 run tag @s remove vr.wet')
amend('state/dynamic','function vr:dispatch/fluid with storage vr:work a','function vr:dispatch/fluid with storage vr:work a\nfunction vr:audio/water')

# Capture audio at contact generation, before solver iterations, so it plays
# once per body/substep rather than once per contact per solver iteration.
fn('audio/play','$playsound $(sound) block @a[distance=..32] ~ ~ ~ $(volume) 1')
fn('audio/world', 'execute if entity @s[tag=vr.impact_sound] run return 0','function vr:contact/velocity',score('impact_speed',mul(-20.,dot(vec('rel'),vec('c.n'))),10000),score('audio_threshold',config('audio.min_speed'),10000),'execute unless score #impact_speed vr.tmp > #audio_threshold vr.tmp run return 0',calc('sound_frame.volume',mul(config('audio.volume_scale'),mul(-20.,dot(vec('rel'),vec('c.n'))))),'data remove storage vr:work sound_frame.sound','execute if function #bs.block:get_sounds run data modify storage vr:work sound_frame.sound set from storage bs:out block.sounds.hit','execute if data storage vr:work sound_frame.sound run function vr:audio/play with storage vr:work sound_frame','data remove storage vr:work sound_frame.sound','data modify storage vr:work sound_frame.sound set from storage vr:work a.sounds.hit','execute if data storage vr:work sound_frame.sound run function vr:audio/play with storage vr:work sound_frame','tag @s add vr.impact_sound')
amend('body/integrate','tag @s remove vr.frozen','tag @s remove vr.impact_sound\ntag @s remove vr.frozen')
amend('world/contact','data modify storage vr:work contacts append','function vr:audio/world\ndata modify storage vr:work contacts append')

# Catch positions and impulses produced during the current substep too.
amend('body/teleport', (F/'body/teleport.mcfunction').read_text().splitlines()[0], 'execute unless function vr:body/check_limits run return 0\n'+(F/'body/teleport.mcfunction').read_text().splitlines()[0])
# Match function command success rather than its numeric return (hardness zero
# and valid functions without an explicit return are both legitimate).
amend('spawn/read_material','execute unless function #bs.block:get_hardness run return 0','execute store success score #material_read vr.tmp run function #bs.block:get_hardness\nexecute unless score #material_read vr.tmp matches 1 run return 0')
amend('spawn/read_material','execute if function #bs.block:get_sounds run data modify storage vr:work conversion.sounds set from storage bs:out block.sounds','execute store success score #material_read vr.tmp run function #bs.block:get_sounds\nexecute unless score #material_read vr.tmp matches 1 run return 0\nexecute unless data storage bs:out block.sounds.hit run return 0\ndata modify storage vr:work conversion.sounds set from storage bs:out block.sounds')
# The same impulse-speed audio rule applies to structure pairs, using both
# cached materials rather than querying the terrain below the pair executor.
pair_audio=(F/'audio/world.mcfunction').read_text().replace('data remove storage vr:work sound_frame.sound\nexecute if function #bs.block:get_sounds run data modify storage vr:work sound_frame.sound set from storage bs:out block.sounds.hit','data remove storage vr:work sound_frame.sound\ndata modify storage vr:work sound_frame.sound set from storage vr:work b.sounds.hit')
write(F/'audio/pair.mcfunction',pair_audio)
amend('contact/append','data modify storage vr:work contacts append','function vr:audio/pair\ndata modify storage vr:work contacts append')
amend('scheduler/count','execute as @e[type=minecraft:marker,tag=vr.root] at @s','tag @e[type=minecraft:marker,tag=vr.root] remove vr.impact_sound\nexecute as @e[type=minecraft:marker,tag=vr.root] at @s')

# Installed Bookshelf getters have no explicit return. Their output contract,
# not `execute if function`, determines whether usable data was produced.
amend('spawn/read_material','execute store success score #material_read vr.tmp run function #bs.block:get_hardness\nexecute unless score #material_read vr.tmp matches 1 run return 0','function #bs.block:get_hardness')
amend('spawn/read_material','execute store success score #material_read vr.tmp run function #bs.block:get_sounds\nexecute unless score #material_read vr.tmp matches 1 run return 0','function #bs.block:get_sounds')
amend('audio/world','execute if function #bs.block:get_sounds run data modify storage vr:work sound_frame.sound set from storage bs:out block.sounds.hit','function #bs.block:get_sounds\nexecute if data storage bs:out block.sounds.hit run data modify storage vr:work sound_frame.sound set from storage bs:out block.sounds.hit')
# The finite-mass API cannot reconstruct a tensor after inverse inertia was
# quantized to zero. Reject this exceptional material, as for static bodies.
amend('api/apply_mass','data modify storage vr:work a set from entity @s data','execute if data entity @s data.material_density run return 0\ndata modify storage vr:work a set from entity @s data')

# Forces can create overspeed inside integration. Test that work velocity before
# the discrete-motion clamp, and stop the caller after removing its executor.
fn('body/check_work_speed',score('overspeed',sub(mul(20.,norm(vec('a.v'))),config('limits.max_speed')),10000),'execute if score #overspeed vr.tmp matches 1.. run return run function vr:body/discard','return 1')
amend('body/discard','function vr:api/remove','scoreboard players set #discarded vr.tmp 1\nfunction vr:api/remove')
amend('body/integrate','execute unless function vr:body/check_limits run return 0','scoreboard players set #discarded vr.tmp 0\nexecute unless function vr:body/check_limits run return 0')
amend('body/integrate','function vr:dispatch/state with storage vr:work a','function vr:dispatch/state with storage vr:work a\nexecute if score #discarded vr.tmp matches 1 run return 0')
amend('state/dynamic','data modify storage vr:work speed set compute','execute unless function vr:body/check_work_speed run return 0\ndata modify storage vr:work speed set compute')

