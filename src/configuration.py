"""Configuration and per-body mass API, generated before score lowering."""
# Runtime frequency is in game-time seconds (20 server ticks). Lower rate slows
# simulation by default; step_ticks explicitly controls simulated time per update.
fn('config/defaults',[f'execute unless score #{k} vr.cfg matches {lo}..{hi} run scoreboard players set #{k} vr.cfg {default}' for k,lo,hi,default in [('ups',1,20,20),('substeps',1,8,2),('solver',1,16,4),('step_ticks',1,20,1),('enabled',0,1,1)]],'execute unless score #phase vr.cfg matches 0..19 run scoreboard players set #phase vr.cfg 0')
fn('api/configure',*[f'$scoreboard players set #new_{name} vr.cfg $({arg})' for name,arg in [('ups','updates_per_second'),('substeps','substeps'),('solver','solver_iterations'),('step_ticks','step_ticks')]],*[f'execute unless score #new_{name} vr.cfg matches {lo}..{hi} run return 0' for name,lo,hi in [('ups',1,20),('substeps',1,8),('solver',1,16),('step_ticks',1,20)]],*[f'scoreboard players operation #{name} vr.cfg = #new_{name} vr.cfg' for name in ['ups','substeps','solver','step_ticks']],'scoreboard players set #phase vr.cfg 0','return 1')
fn('api/config_status','tellraw @s [{text:"VR updates/s="},{score:{name:"#ups",objective:"vr.cfg"}},{text:" substeps="},{score:{name:"#substeps",objective:"vr.cfg"}},{text:" solver iterations="},{score:{name:"#solver",objective:"vr.cfg"}},{text:" simulated ticks/update="},{score:{name:"#step_ticks",objective:"vr.cfg"}}]')
def cfg(k):return {'type':'minecraft:from_int','input':{'type':'minecraft:score','score':'vr.cfg','target':{'type':'minecraft:fixed','name':'#'+k},'fallback':1}}
fn('config/prepare',calc('dt',div(cfg('step_ticks'),cfg('substeps'))),calc('air_damp',{'type':'minecraft:pow','base':.998,'exponent':mul(2.,S('dt'))}),calc('angular_damp',{'type':'minecraft:pow','base':.995,'exponent':mul(2.,S('dt'))}))
fn('tick','execute unless score #enabled vr.cfg matches 1 run return 0','scoreboard players operation #phase vr.cfg += #ups vr.cfg','execute unless score #phase vr.cfg matches 20.. run return 0','scoreboard players remove #phase vr.cfg 20','scoreboard players add #total_updates vr.cfg 1',[f'scoreboard players set #{x} vr.stat 0' for x in ['sat','bvh','linear','world','contacts','overflow','pairs']],*[f'execute in minecraft:{d} run function vr:tick/dimension' for d in ['overworld','the_nether','the_end']])
fn('tick/dimension','execute unless entity @e[type=minecraft:marker,tag=vr.root] run return 0','function vr:config/prepare','scoreboard players operation #subleft vr.tmp = #substeps vr.cfg','function vr:tick/substep_loop','execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:render/body')
fn('tick/substep_loop','execute if score #subleft vr.tmp matches ..0 run return 0','function vr:tick/substep','scoreboard players remove #subleft vr.tmp 1','return run function vr:tick/substep_loop')
fn('contact/solve_all','execute unless data storage vr:work contacts[0] run return 0','function vr:math/inertia','scoreboard players operation #solverleft vr.tmp = #solver vr.cfg','function vr:contact/solver_loop','execute store result storage vr:work count float 1 run scoreboard players get #contact_count vr.tmp','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/correct_loop')
fn('contact/solver_loop','execute if score #solverleft vr.tmp matches ..0 run return 0','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/loop','scoreboard players remove #solverleft vr.tmp 1','return run function vr:contact/solver_loop')
fn('api/pause','scoreboard players set #enabled vr.cfg 0')
fn('api/resume','scoreboard players set #enabled vr.cfg 1')
# Dynamic mass affects both translational and rotational inertia, preserving v/w.
ls=['execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','data modify storage vr:work a set from entity @s data','execute if data storage vr:work a{state:"static"} run return 0',score('mass_check',S('requested_mass'),10000),'execute unless score #mass_check vr.tmp matches 500..10000000 run return 0',calc('mass_ratio',div(S('a.mass'),S('requested_mass')))]
ls += [calc(f'a.J.r{i}{j}',mul(S(f'a.J.r{i}{j}'),S('mass_ratio'))) for i in range(3) for j in range(3)]
ls += [calc(f'a.Ibody.r{i}{j}',div(S(f'a.Ibody.r{i}{j}'),S('mass_ratio'))) for i in range(3) for j in range(3)]
ls += [cp('a.mass','requested_mass'),calc('a.inv_mass',div(1.,S('a.mass'))),calc('a.density',div(S('a.mass'),S('a.count'))),'data modify entity @s data set from storage vr:work a','return 1']
fn('api/apply_mass',ls)
fn('api/set_mass','$execute store result score #requested_mass vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(mass)]}}','return run function vr:api/apply_mass')
fn('api/set_density','$execute store result score #requested_density vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(density)]}}','execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','data modify storage vr:work a set from entity @s data',calc('requested_mass',mul(S('requested_density'),S('a.count'))),'return run function vr:api/apply_mass')
# Replace fixed dt and fixed per-substep damping in expressions.
def replace_expr(v):
 if isinstance(v,dict):
  v={k:replace_expr(x) for k,x in v.items()}
  if v.get('type')=='minecraft:mul':
   inputs=v['inputs']
   if len(inputs)==2 and inputs[0]==.5:inputs[0]=S('dt')
   if len(inputs)==2 and inputs[0]==.25:inputs[0]=mul(.5,S('dt'))
   if len(inputs)==2 and inputs[0]==.998:inputs[0]=S('air_damp')
   if len(inputs)==2 and inputs[0]==.995:inputs[0]=S('angular_damp')
  return v
 if isinstance(v,list):return [replace_expr(x) for x in v]
 return v
# Only expressions emitted for state/dynamic; avoid changing SAT half extents.
for ref in re.findall(r'float vr:(e\d+)',(F/'state/dynamic.mcfunction').read_text()):
 providers[ref]=replace_expr(providers[ref]);js(P/(ref+'.json'),providers[ref])
# Precision-aware guards/tests (1e-4 fixed point).
p=F/'test/run.mcfunction';s=p.read_text();s=s.replace('scoreboard players set #fail vr.test 0','scoreboard players set #fail vr.test 0\nfunction vr:config/defaults\nscoreboard players operation #test_substeps vr.cfg = #substeps vr.cfg\nscoreboard players operation #test_step_ticks vr.cfg = #step_ticks vr.cfg\nscoreboard players set #substeps vr.cfg 2\nscoreboard players set #step_ticks vr.cfg 1\nfunction vr:config/prepare')
s=s.replace('999998..1000001','999700..1000300').replace('-19961..-19959','-20050..-19900');write(p,s)
# Avoid denominator being rounded down to zero in a 1e-4 backend.
def guards(v):
 if isinstance(v,dict):return {k:guards(x) for k,x in v.items()}
 if isinstance(v,list):return [guards(x) for x in v]
 return .0001 if isinstance(v,float) and v in [.000001,1e-9] else v
for n,e in providers.items():providers[n]=guards(e);js(P/(n+'.json'),providers[n])

ls=['scoreboard objectives add vr.test dummy','scoreboard players set #rate_fail vr.test 0']
for k in ['ups','substeps','solver','step_ticks','enabled','phase']:
 ls += [f'scoreboard players operation #save_{k} vr.cfg = #{k} vr.cfg']
ls += ['function vr:api/configure {updates_per_second:1,substeps:1,solver_iterations:2,step_ticks:1}','scoreboard players set #enabled vr.cfg 1','scoreboard players set #total_updates vr.cfg 0']+['function vr:tick' for _ in range(20)]+['execute unless score #total_updates vr.cfg matches 1 run scoreboard players add #rate_fail vr.test 1','execute store result score #invalid vr.test run function vr:api/configure {updates_per_second:0,substeps:1,solver_iterations:2,step_ticks:1}','execute unless score #invalid vr.test matches 0 run scoreboard players add #rate_fail vr.test 1','execute unless score #ups vr.cfg matches 1 run scoreboard players add #rate_fail vr.test 1']
for k in ['ups','substeps','solver','step_ticks','enabled','phase']:
 ls += [f'scoreboard players operation #{k} vr.cfg = #save_{k} vr.cfg']
ls += ['return run scoreboard players get #rate_fail vr.test']
fn('test/configuration',ls)
