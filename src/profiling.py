"""Opt-in stopwatch instrumentation and flat-leaf reference query.
Generated before score lowering. Does not replace native entity broadphase.
"""
# Root candidate enumeration remains the native distance selector unchanged.
fn('dispatch/linear','$function vr:shape/$(shape)/linear')
fn('dispatch/bvh','execute if score #query_mode vr.cfg matches 1 run return run function vr:dispatch/linear with storage vr:work b','$function vr:shape/$(shape)/bvh/0')
fn('api/query_mode','$scoreboard players set #new_query_mode vr.cfg $(mode)','execute unless score #new_query_mode vr.cfg matches 0..1 run return 0','scoreboard players operation #query_mode vr.cfg = #new_query_mode vr.cfg','return 1')
for name,info in meta.items():
 lines=[]
 for j,p in enumerate(info['centers']):
  leaf=[setv('node',literal(dict(zip(AX,p))))]
  leaf+=cv('nc',[add(x,y) for x,y in zip(mv(mat('b.R'),vec('node')),vec('bp'))])
  d=[sub(x,y) for x,y in zip(vec('nc'),vec('ac'))]
  leaf += [score('bound',sub(dot(d,d),3.0)),'scoreboard players add #linear vr.stat 1','execute if score #bound vr.tmp matches 1.. run return 0',cp('bc','nc'),'function vr:collision/sat','execute if score #hit vr.tmp matches 1 run function vr:contact/append']
  fn(f'shape/{name}/linear_leaf/{j}',leaf);lines += [f'function vr:shape/{name}/linear_leaf/{j}']
 fn(f'shape/{name}/linear',lines)
 fixture=[setv('a',literal(info['body'])),setv('b',literal(info['body'])),setv('bp',literal(zero)),calc('bp.x',S('bench_sep')),setv('contacts','[]'),'scoreboard players set #contact_count vr.tmp 0']
 fn(f'shape/{name}/profile_fixture',fixture)
# Generic one-command/function timer. Scalar result is scaled seconds -> us.
fn('profile/run','$data modify storage vr:work bench.entry set value "$(entry)"','$scoreboard players set #bench_repeats vr.tmp $(repeats)','execute unless score #bench_repeats vr.tmp matches 1..16 run return 0','scoreboard players set #elapsed_us vr.prof -1','stopwatch remove vr:profile','stopwatch create vr:profile','function vr:profile/repeat','execute store result score #elapsed_us vr.prof run stopwatch query vr:profile 1000000','stopwatch remove vr:profile','return run scoreboard players get #elapsed_us vr.prof')
fn('profile/repeat','execute if score #bench_repeats vr.tmp matches ..0 run return 0','function vr:profile/dispatch with storage vr:work bench','scoreboard players remove #bench_repeats vr.tmp 1','return run function vr:profile/repeat')
fn('profile/dispatch','$function $(entry)')
fn('profile/empty','return 1')
fn('profile/geometry','$data modify storage vr:work bench.shape set value "$(shape)"','$scoreboard players set #bench_count vr.tmp $(repeats)','$execute store result score #bench_sep vr.num run compute default float {type:"minecraft:round",input:{type:"minecraft:mul",inputs:[10000.0,$(separation)]}}','execute unless score #bench_count vr.tmp matches 1..16 run return 0','function vr:profile/fixture with storage vr:work bench','scoreboard players set #bvh_us vr.prof -1','scoreboard players set #linear_us vr.prof -1','function vr:profile/bvh_batch','function vr:profile/linear_batch','return 1')
fn('profile/fixture','$function vr:shape/$(shape)/profile_fixture')
for mode in ['bvh','linear']:
 fn('profile/'+mode+'_batch',setv('bench.mode',literal(mode)),'scoreboard players operation #bench_repeats vr.tmp = #bench_count vr.tmp',*[f'scoreboard players set #{x} vr.stat 0' for x in ['sat','bvh','linear','contacts','overflow']],'stopwatch remove vr:geometry','stopwatch create vr:geometry','function vr:profile/geometry_repeat',f'execute store result score #{mode}_us vr.prof run stopwatch query vr:geometry 1000000','stopwatch remove vr:geometry',*[f'scoreboard players operation #{mode}_{x} vr.prof = #{x} vr.stat' for x in ['sat','bvh','linear','contacts','overflow']])
fn('profile/geometry_repeat','execute if score #bench_repeats vr.tmp matches ..0 run return 0',setv('contacts','[]'),'scoreboard players set #contact_count vr.tmp 0','function vr:profile/geometry_dispatch with storage vr:work bench','scoreboard players remove #bench_repeats vr.tmp 1','return run function vr:profile/geometry_repeat')
fn('profile/results','tellraw @s [{text:"BVH batch us="},{score:{name:"#bvh_us",objective:"vr.prof"}},{text:" linear batch us="},{score:{name:"#linear_us",objective:"vr.prof"}},{text:" | SAT "},{score:{name:"#bvh_sat",objective:"vr.prof"}},{text:"/"},{score:{name:"#linear_sat",objective:"vr.prof"}},{text:" | contacts "},{score:{name:"#bvh_contacts",objective:"vr.prof"}},{text:"/"},{score:{name:"#linear_contacts",objective:"vr.prof"}}]')
# Defaults are appended after numerical lowering by the caller.

fn('profile/select_roots','execute store result score #native_count vr.prof run execute if entity @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen,distance=..17]')

fn('profile/geometry_dispatch','$function vr:shape/$(shape)/profile_$(mode)')
for name,info in meta.items():
 for mode in ['bvh','linear']:
  lines=[]
  for p in info['centers']:
   lines += [setv('local',literal(dict(zip(AX,p))))]+cv('ac',[add(a,b) for a,b in zip(vec('a.p'),mv(mat('a.R'),vec('local')))])+[f'function vr:shape/{name}/'+('bvh/0' if mode=='bvh' else 'linear')]
  fn(f'shape/{name}/profile_{mode}',lines)

# Reversed order for A/B testing to reduce first-run/JIT/order bias.
lines=(F/'profile/geometry.mcfunction').read_text().splitlines()
lines=[x.replace('profile/bvh_batch','profile/TEMP_batch').replace('profile/linear_batch','profile/bvh_batch').replace('profile/TEMP_batch','profile/linear_batch') for x in lines]
fn('profile/geometry_reverse',lines)
