"""Immutable multi-OBB geometry for converted blocks; numeric scratch is scores."""
half=dict.fromkeys(AX,.5)
# Compile-time unit-voxel paths explicitly establish extents; custom paths load
# per-box extents. Prevent stale extents crossing SAT/macro dispatch boundaries.
for name in shapes:
 for suffix,field in [('world','ah'),('pairs','ah'),('bvh/0','bh'),('linear','bh'),('ray','ray.h')]:
  p=F/f'shape/{name}/{suffix}.mcfunction';write(p,setv(field,literal(half))+'\n'+p.read_text())
# Generic SAT projection and support-feature centers, still 15 axes.
def emit_axis(name,hb):
 ls=[calc('length',norm(vec('axis'))),score('deg',S('length')),'execute if score #deg vr.tmp matches ..100 run return 1']+cv('n',[div(v,S('length')) for v in vec('axis')])
 radius=add(*(mul(S(h+'.'+AX[i]),op('abs',dot(vec('n'),ax))) for axes0,h in [(a_axes,'ah'),(b_axes,hb)] for i,ax in enumerate(axes0)))
 ls += [calc('signed',dot([sub(a,b) for a,b in zip(vec('ac'),vec('bc'))],vec('n'))),calc('depth',sub(radius,op('abs',S('signed')))),score('sep',S('depth')),'execute if score #sep vr.tmp matches ..0 run return 0',score('better',sub(S('depth'),S('best.depth'))),'execute if score #better vr.tmp matches ..-1 run function vr:collision/best','return 1']
 fn(name,ls)
def emit_contact(name,hb):
 ls=['execute if score #contact_count vr.tmp matches 32.. run return run function vr:contact/overflow',cp('c.n','best.n'),cp('c.depth','best.depth')]
 for k,axes0,sign,h in [('a',a_axes,-1,'ah'),('b',b_axes,1,hb)]:
  ls+=cv('support',vec('ac' if k=='a' else 'bc'))
  for i,axis in enumerate(axes0):
   ls += [score('sign',dot(axis,vec('c.n'))),'scoreboard players set #sgn vr.tmp 0','execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1','execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1','execute store result storage vr:work sgn float 1 run scoreboard players get #sgn vr.tmp']
   ls+=cv('support',[add(S('support.'+x),mul(float(sign),S(h+'.'+AX[i]),S('sgn'),axis[j])) for j,x in enumerate(AX)])
  ls += [cp('support_'+k,'support')]
 ls+=cv('c.point',[mul(.5,add(a,b)) for a,b in zip(vec('support_a'),vec('support_b'))])
 fn(name,ls,'data modify storage vr:work contacts append from storage vr:work c','scoreboard players add #contact_count vr.tmp 1','scoreboard players add #contacts vr.stat 1')
emit_axis('collision/axis','bh');emit_axis('world/axis','box.h')
emit_contact('contact/append','bh');emit_contact('world/contact','box.h')
# Unit-only numerical tests get explicit default extents.
for p in (F/'test').glob('*.mcfunction'):
 s=p.read_text();write(p,setv('ah',literal(half))+'\n'+setv('bh',literal(half))+'\n'+s)
# Prepare normalized geometry once, before removal of the source block.
fn('spawn/read_collision','data modify storage bs:out hitbox set value {shape:[],offset:{x:0.0d,z:0.0d}}','function #bs.hitbox:get_block_collision','data modify storage vr:work conversion.collision set from storage bs:out hitbox','execute unless data storage vr:work conversion.collision.shape[0] run return 0','data modify storage vr:work conversion.boxes set value []','scoreboard players set #geometry_count vr.tmp 0',setv('geometry.radius','0.0f'),'function vr:spawn/collision_loop','execute if data storage vr:work conversion.collision.shape[0] run return 0','execute if score #geometry_count vr.tmp matches 1..64 run return 1','return 0')
ls=['execute unless data storage vr:work conversion.collision.shape[0] run return 0','execute if score #geometry_count vr.tmp matches 64.. run return 0']
for i,key in enumerate(['minx','miny','minz','maxx','maxy','maxz']):ls += [f'execute store result storage vr:work geometry.{key} float 0.0001 run data get storage vr:work conversion.collision.shape[0][{i}] 10000']
for x in ['x','z']:
 ls += [setv('geometry.offset'+x,'0.0f'),f'execute if data storage vr:work conversion.collision.offset.{x} run execute store result storage vr:work geometry.offset{x} float 0.0001 run data get storage vr:work conversion.collision.offset.{x} 10000']
for x in AX:
 ls += [calc('geometry.c.'+x,add(-.5,mul(1/32,add(S('geometry.min'+x),S('geometry.max'+x))),S('geometry.offset'+x) if x!='y' else 0.)),calc('geometry.h.'+x,mul(1/32,sub(S('geometry.max'+x),S('geometry.min'+x))))]
ls += [calc('geometry.radius',mx(S('geometry.radius'),add(norm(vec('geometry.c')),norm(vec('geometry.h'))))),cp('geometry.entry.c','geometry.c'),cp('geometry.entry.h','geometry.h'),'data modify storage vr:work conversion.boxes append from storage vr:work geometry.entry','scoreboard players add #geometry_count vr.tmp 1','data remove storage vr:work conversion.collision.shape[0]','return run function vr:spawn/collision_loop']
fn('spawn/collision_loop',ls)
p=F/'spawn/convert_block.mcfunction';s=p.read_text().replace('scoreboard players set #converted vr.tmp 0','execute unless function vr:spawn/read_collision run return 0\nscoreboard players set #converted vr.tmp 0');write(p,s)
p=F/'spawn/converted_root.mcfunction';s=p.read_text().replace('scoreboard players operation #converted_id', 'data modify entity @s data.shape set value "custom"\ndata modify entity @s data.boxes set from storage vr:work conversion.boxes\nexecute store result score @s vr.rad run scoreboard players get #geometry.radius vr.num\nscoreboard players operation #converted_id');write(p,s)
# Geometry is immutable metadata. Lists are copied as iteration cursors, not
# numerically rewritten to the root every tick.
for mode in ['world','pairs','fluid']:
 fn('shape/custom/'+mode,'data modify storage vr:work custom_a set from storage vr:work a.boxes','function vr:shape/custom/'+mode+'_loop')
 ls=['execute unless data storage vr:work custom_a[0] run return 0',cp('local','custom_a[0].c'),cp('ah','custom_a[0].h')]
 ls += ['function vr:'+{'world':'world/voxel','pairs':'pair/voxel','fluid':'fluid/custom_voxel'}[mode],'data remove storage vr:work custom_a[0]','return run function vr:shape/custom/'+mode+'_loop']
 fn('shape/custom/'+mode+'_loop',ls)
fn('shape/custom/render','function vr:shape/cube/render')
fn('shape/custom/bvh/0','function vr:shape/custom/linear')
fn('shape/custom/linear','data modify storage vr:work custom_b set from storage vr:work b.boxes','function vr:shape/custom/b_loop')
fn('shape/custom/b_loop','execute unless data storage vr:work custom_b[0] run return 0',cp('b_local','custom_b[0].c'),cp('bh','custom_b[0].h'),cv('bc',[add(a,b) for a,b in zip(vec('bp'),mv(mat('b.R'),vec('b_local')))]),'function vr:collision/sat','execute if score #hit vr.tmp matches 1 run function vr:contact/append','data remove storage vr:work custom_b[0]','return run function vr:shape/custom/b_loop')
fn('shape/custom/ray','data modify storage vr:work custom_ray set from storage vr:work a.boxes','function vr:shape/custom/ray_loop')
fn('shape/custom/ray_loop','execute unless data storage vr:work custom_ray[0] run return 0',cp('ray.center','custom_ray[0].c'),cp('ray.h','custom_ray[0].h'),'function vr:input/voxel','data remove storage vr:work custom_ray[0]','return run function vr:shape/custom/ray_loop')
# Ray slab half-size must be sourced per axis, not hardcoded to .5.
p=F/'input/voxel.mcfunction';s=p.read_text()
for x in AX:s=s.replace(cp('ray.c','ray.center.'+x),cp('ray.c','ray.center.'+x)+'\n'+cp('ray.half','ray.h.'+x))
write(p,s)
fn('input/slab',score('ray_parallel',op('abs',S('ray.d'))),'execute if score #ray_parallel vr.tmp matches ..100 run return run function vr:input/parallel',calc('ray.t0',div(sub(sub(S('ray.c'),S('ray.half')),S('ray.u')),S('ray.d'))),calc('ray.t1',div(sub(add(S('ray.c'),S('ray.half')),S('ray.u')),S('ray.d'))),calc('ray.enter',mx(S('ray.enter'),mn(S('ray.t0'),S('ray.t1')))),calc('ray.exit',mn(S('ray.exit'),mx(S('ray.t0'),S('ray.t1')))),score('ray_interval',sub(S('ray.enter'),S('ray.exit'))),'execute if score #ray_interval vr.tmp matches 1.. run return 0','return 1')
fn('input/parallel',score('ray_outside',sub(op('abs',sub(S('ray.u'),S('ray.c'))),S('ray.half'))),'execute if score #ray_outside vr.tmp matches 1.. run return 0','return 1')
p=F/'test/input.mcfunction';write(p,setv('ray.half','0.5f')+'\n'+p.read_text())
# Custom buoyancy samples are scaled by actual box volume; compiled unit voxels
# retain the previous eight samples. Overlapping boxes would double count fluid.
ls=[]
for o in itertools.product([-.5,.5],repeat=3):
 ls+=cv('r',mv(mat('a.R'),[add(v,mul(off,h)) for v,h,off in zip(vec('local'),vec('ah'),o)]))+cv('sample',[add(a,b) for a,b in zip(vec('a.p'),vec('r'))])
 for x in AX:ls += [cp('sample.o'+x,'a.o.'+x)]
 ls += ['function vr:fluid/custom_sample with storage vr:work sample']
fn('fluid/custom_voxel',ls)
fn('fluid/custom_sample','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) if block ~ ~ ~ minecraft:water run function vr:fluid/custom_wet')
ls=[calc('frac_y',sub(S('sample.y'),op('floor',S('sample.y')))),score('surface',S('frac_y')),'execute if block ~ ~ ~ minecraft:water[level=0] unless block ~ ~1 ~ minecraft:water if score #surface vr.tmp matches 888889.. run return 0']
volume=mul(*vec('ah'))
pointv=[add(a,b) for a,b in zip(vec('a.v'),cross(vec('a.w'),vec('r')))]
ls+=cv('df',[add(mul(-.02,volume,sub(a,S('flow.'+AX[i]))),mul(.04,volume) if i==1 else 0.) for i,a in enumerate(pointv)])+cv('force',[add(a,b) for a,b in zip(vec('force'),vec('df'))])+cv('torque',[add(a,b) for a,b in zip(vec('torque'),cross(vec('r'),vec('df')))])+[calc('wet',add(S('wet'),volume))]
fn('fluid/custom_wet',ls)
# Bound fixed-neighborhood traversal for custom boxes (vanilla extents <=1.5).
# Existing world/voxel covers two lower block layers and all unit neighborhood.

# Compiled B trees were bounded for a unit A. Use flat leaves for custom A and
# bypass only their unit-specific sphere rejection; SAT remains exact.
p=F/'dispatch/bvh.mcfunction';write(p,'execute if data storage vr:work a{shape:"custom"} run return run function vr:dispatch/linear with storage vr:work b\n'+p.read_text())
for name in shapes:
 for p in (F/f'shape/{name}/linear_leaf').glob('*.mcfunction'):
  s=p.read_text().replace('execute if score #bound vr.tmp matches 1.. run return 0','execute unless data storage vr:work a{shape:"custom"} if score #bound vr.tmp matches 1.. run return 0')
  write(p,s)
fn('test/custom_boxes',setv('a.R',literal(identity)),setv('b.R',literal(identity)),setv('ah','{x:0.5f,y:0.25f,z:0.5f}'),setv('bh',literal(half)),setv('ac','{x:0.0f,y:-0.25f,z:0.0f}'),setv('bc','{x:0.0f,y:0.6f,z:0.0f}'),'execute if function vr:collision/sat run return 1',setv('bc','{x:0.0f,y:0.4f,z:0.0f}'),'execute unless function vr:collision/sat run return 2',score('custom_depth',S('best.depth'),10000),'execute unless score #custom_depth vr.tmp matches 999..1001 run return 3','return 0')
