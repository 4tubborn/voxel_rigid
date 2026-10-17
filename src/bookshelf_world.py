"""Real block collision shapes from Bookshelf; no full-cube fallback."""
# Capture each provider output immediately, never retain shared bs:out across calls.
fn('world/solid','scoreboard players add #world vr.stat 1','data modify storage bs:out hitbox set value {shape:[],offset:{x:0.0d,z:0.0d}}','function #bs.hitbox:get_block_collision','data modify storage vr:work terrain set from storage bs:out hitbox','function vr:world/shape_loop')
fn('world/block','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) unless loaded ~ ~ ~ run scoreboard players set #unloaded vr.tmp 1','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) if loaded ~ ~ ~ unless block ~ ~ ~ #vr:terrain_empty run function vr:world/solid')
ls=['execute unless data storage vr:work terrain.shape[0] run return 0']
# Raw arrays remain storage only at provider ABI; numeric leaves enter scores.
for i,key in enumerate(['minx','miny','minz','maxx','maxy','maxz']):ls += [f'execute store result storage vr:work box.{key} float 0.0001 run data get storage vr:work terrain.shape[0][{i}] 10000']
for x in ['x','z']:ls += [setv('box.offset'+x,'0.0f'),f'execute if data storage vr:work terrain.offset.{x} run execute store result storage vr:work box.offset{x} float 0.0001 run data get storage vr:work terrain.offset.{x} 10000']
for x in AX:
 ls += [calc('bc.'+x,add(S('query.'+x),mul(1/32,add(S('box.min'+x),S('box.max'+x))),S('box.offset'+x) if x!='y' else 0.0)),calc('box.h.'+x,mul(1/32,sub(S('box.max'+x),S('box.min'+x))))]
ls += ['function vr:world/sat','execute if score #hit vr.tmp matches 1 run function vr:world/contact','data remove storage vr:work terrain.shape[0]','return run function vr:world/shape_loop']
fn('world/shape_loop',ls)
ls=['scoreboard players add #sat vr.stat 1','scoreboard players set #hit vr.tmp 0',setv('best.depth','1000.0f')]
for axis in a_axes+b_axes+[cross(a,b) for a in a_axes for b in b_axes]:ls+=cv('axis',axis)+['execute unless function vr:world/axis run return 0']
fn('world/sat',ls,'scoreboard players set #hit vr.tmp 1','return 1')
ls=[calc('length',norm(vec('axis'))),score('deg',S('length')),'execute if score #deg vr.tmp matches ..100 run return 1']
ls += cv('n',[div(v,S('length')) for v in vec('axis')])
radius=add(mul(.5,add(*(op('abs',dot(vec('n'),a)) for a in a_axes))),add(*(mul(S('box.h.'+x),op('abs',S('n.'+x))) for x in AX)))
ls += [calc('signed',dot([sub(a,b) for a,b in zip(vec('ac'),vec('bc'))],vec('n'))),calc('depth',sub(radius,op('abs',S('signed')))),score('sep',S('depth')),'execute if score #sep vr.tmp matches ..0 run return 0',score('better',sub(S('depth'),S('best.depth'))),'execute if score #better vr.tmp matches ..-1 run function vr:collision/best','return 1']
fn('world/axis',ls)
ls=['execute if score #contact_count vr.tmp matches 32.. run return run function vr:contact/overflow',cp('c.n','best.n'),cp('c.depth','best.depth')]
for k,axes0,sign in [('a',a_axes,-1),('b',b_axes,1)]:
 ls+=cv('support',vec('ac' if k=='a' else 'bc'))
 for i,axis in enumerate(axes0):
  ls += [score('sign',dot(axis,vec('c.n'))),'scoreboard players set #sgn vr.tmp 0','execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1','execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1','execute store result storage vr:work sgn float 1 run scoreboard players get #sgn vr.tmp']
  half=.5 if k=='a' else S('box.h.'+AX[i])
  ls+=cv('support',[add(S('support.'+x),mul(float(sign),half,S('sgn'),axis[j])) for j,x in enumerate(AX)])
 ls += [cp('support_'+k,'support')]
ls+=cv('c.point',[mul(.5,add(a,b)) for a,b in zip(vec('support_a'),vec('support_b'))])
fn('world/contact',ls,'data modify storage vr:work contacts append from storage vr:work c','scoreboard players add #contact_count vr.tmp 1','scoreboard players add #contacts vr.stat 1')
# Vanilla collision shapes can reach 1.5 blocks upward (fences/walls), so visit
# blocks two layers below the OBB center. Existing unit-cube cheap cull removed.
ls=cv('ac',[add(a,b) for a,b in zip(vec('a.p'),mv(mat('a.R'),vec('local')))])
for x in AX:ls += [calc('base.'+x,op('floor',S('ac.'+x)))]
for ox,oy,oz in itertools.product([-1,0,1],[-2,-1,0,1],[-1,0,1]):
 ls+=cv('bc',[add(S('base.'+x),float(o)+.5) for x,o in zip(AX,[ox,oy,oz])]);ls+=['function vr:world/candidate']
fn('world/voxel',ls)

ls=[setv('a.R',literal(identity)),setv('b',literal(static)),setv('query',literal(zero)),setv('contacts','[]'),'scoreboard players set #contact_count vr.tmp 0',setv('ac','{x:0.5f,y:1.2f,z:0.5f}'),setv('terrain','{shape:[[0,0,0,16,8,16]]}'),'function vr:world/shape_loop','execute unless score #contact_count vr.tmp matches 0 run return 1',setv('ac','{x:0.5f,y:0.9f,z:0.5f}'),setv('terrain','{shape:[[0,0,0,16,8,16]]}'),'function vr:world/shape_loop','execute unless score #contact_count vr.tmp matches 1 run return 2',score('terrain_depth',S('best.depth'),10000),'execute unless score #terrain_depth vr.tmp matches 999..1001 run return 3','return 0']
fn('test/terrain_boxes',ls)

js(PACK/'data/vr/tags/block/terrain_empty.json',{'values':['minecraft:air','minecraft:cave_air','minecraft:void_air','minecraft:water','minecraft:lava','minecraft:bubble_column']})
