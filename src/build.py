#!/usr/bin/env python3
"""Voxel Rigid 0.6: deterministic vanilla 26.3 pack compiler, Python 3.10+."""
import json, math, pathlib, shutil, itertools, re
ROOT=pathlib.Path(__file__).resolve().parents[1]
PACK=ROOT
# Validate both exact targets before deleting anything. Refuse redirected
# outputs (symlinks/junctions) rather than cleaning outside the project.
for target in (ROOT/'data', ROOT/'pack.mcmeta'):
 if target.resolve()!=target:
  raise RuntimeError(f'Refusing to clean redirected output: {target}')
if (ROOT/'data').exists(): shutil.rmtree(ROOT/'data')
if (ROOT/'pack.mcmeta').exists(): (ROOT/'pack.mcmeta').unlink()
F=PACK/'data/vr/function'; P=PACK/'data/vr/context_float_provider'
AX='xyz'
def write(p,s):
 p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf-8')
def js(p,o):write(p,json.dumps(o,ensure_ascii=False,indent=2)+'\n')
def fn(n,*ls):write(F/(n+'.mcfunction'),'\n'.join(x for a in ls for x in (a if isinstance(a,list) else [a]))+'\n')
def raw(o):return json.dumps(o,separators=(',',':'))
def S(p):return {'type':'minecraft:storage','storage':'vr:work','path':p,'fallback':0.0}
def add(*a):return {'type':'minecraft:add','inputs':list(a)}
def mul(*a):return {'type':'minecraft:mul','inputs':list(a)}
def sub(a,b):return {'type':'minecraft:sub','left':a,'right':b}
def div(a,b):return {'type':'minecraft:div','left':a,'right':b}
def op(t,x):return {'type':'minecraft:'+t,'input':x}
def mn(*a):return {'type':'minecraft:min','inputs':list(a)}
def mx(*a):return {'type':'minecraft:max','inputs':list(a)}
def clamp(x,a,b):return mn(b,mx(a,x))
def dot(a,b):return add(*(mul(x,y) for x,y in zip(a,b)))
def cross(a,b):return [sub(mul(a[(i+1)%3],b[(i+2)%3]),mul(a[(i+2)%3],b[(i+1)%3])) for i in range(3)]
def vec(p):return [S(p+'.'+x) for x in AX]
def norm(a):return {'type':'minecraft:length','inputs':a}
def mat(p):return [[S(f'{p}.r{i}{j}') for j in range(3)] for i in range(3)]
def mv(m,v):return [dot(row,v) for row in m]
def tr(m):return list(map(list,zip(*m)))
def setv(p,v):return f'data modify storage vr:work {p} set value {v}'
def cp(p,q):return f'data modify storage vr:work {p} set from storage vr:work {q}'
providers={}
def calc(p,e):
 n='e'+str(len(providers));providers[n]=e;js(P/(n+'.json'),e)
 return f'data modify storage vr:work {p} set compute default float vr:{n}'
def cv(p,v):return [calc(p+'.'+x,e) for x,e in zip(AX,v)]
def score(n,e,scale=1000000):
 k='e'+str(len(providers));providers[k]=e;js(P/(k+'.json'),e)
 return f'execute store result score #{n} vr.tmp run compute default float vr:{k} {scale}'
def literal(v):
 if isinstance(v,float):return f'{v:.9f}f'
 if isinstance(v,int):return str(v)
 if isinstance(v,str):return json.dumps(v)
 if isinstance(v,list):return '['+','.join(map(literal,v))+']'
 return '{'+','.join(k+':'+literal(x) for k,x in v.items())+'}'
identity={f'r{i}{j}':float(i==j) for i in range(3) for j in range(3)}
zero=dict.fromkeys(AX,0.0)
shapes=json.loads((ROOT/'src/shapes.json').read_text())
meta={}
for name,sh in shapes.items():
 assert re.fullmatch(r'[a-z0-9_]+',name), 'shape name must be lowercase letters/digits/underscore'
 cells=sh['voxels'];assert len(cells) in range(1,65)
 assert len(set(map(tuple,cells)))==len(cells)
 assert all(len(v)==3 and all(isinstance(t,int) for t in v) for v in cells)
 com=[sum(v[i]+.5 for v in cells)/len(cells) for i in range(3)]
 pts=[[v[i]+.5-com[i] for i in range(3)] for v in cells]
 assert max(math.dist(p,[0,0,0]) for p in pts)<7
 density=sh.get('density',.7); assert math.isfinite(density) and .05<=density<=100, 'density out of supported range'; mass=len(cells)*density
 inertia=[[sum(density*((sum(t*t for t in p)+1/6 if i==j else 0)-p[i]*p[j]) for p in pts) for j in range(3)] for i in range(3)]
 a,b,c=inertia[0];d,e,f=inertia[1];g,h,i=inertia[2];det=a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g)
 inv=[[ (e*i-f*h)/det,(c*h-b*i)/det,(b*f-c*e)/det],[(f*g-d*i)/det,(a*i-c*g)/det,(c*d-a*f)/det],[(d*h-e*g)/det,(b*g-a*h)/det,(a*e-b*d)/det]]
 body={'shape':name,'state':'dynamic','o':dict.fromkeys(AX,0),'p':zero.copy(),'v':zero.copy(),'w':zero.copy(),'q':{'x':0.0,'y':0.0,'z':0.0,'w':1.0},'R':identity,'J':{f'r{i}{j}':inv[i][j] for i in range(3) for j in range(3)},'Ibody':{f'r{i}{j}':inertia[i][j] for i in range(3) for j in range(3)},'mass':mass,'inv_mass':1/mass,'density':density,'radius':max(math.dist(p,[0,0,0]) for p in pts)+math.sqrt(3)/2,'count':len(cells),'e':.1,'mu':.55}
 meta[name]={'centers':pts,'inertia':inertia,'inverse_inertia':inv,'body':body}
 # spawn uses anchored integer origin, fractional offset relative to spawn
 init=[f'data modify entity @s data set value {literal(body)}','scoreboard players add #next vr.id 1','scoreboard players operation @s vr.id = #next vr.id','data modify storage vr:work a set from entity @s data']
 for j,x in enumerate(AX):
  init += [f'execute store result storage vr:work a.o.{x} int 1 run data get entity @s Pos[{j}] 1', setv('a.p.'+x,'0.5f')]
 init += ['data modify entity @s data set from storage vr:work a','execute store result storage vr:work owner.id int 1 run scoreboard players get @s vr.id']
 for j,p in enumerate(pts):
  init += [f'execute summon minecraft:block_display run function vr:shape/{name}/display_{j}']
 init += ['function vr:render/body','return 1']
 fn('shape/'+name+'/init',init)
 fn('spawn/'+name,'return run function vr:spawn/check_'+name)
 # spawning at arbitrary command source, check coordinates via execute positioned bbox selector not possible; macro validate using marker scores before init
 fn('spawn/check_'+name,f'return run execute align xyz positioned ~0.5 ~0.5 ~0.5 summon minecraft:marker run function vr:spawn/new_{name}')
 fn('spawn/new_'+name,'tag @s add vr.root',f'return run function vr:shape/{name}/init')
 for j,p in enumerate(pts):fn(f'shape/{name}/display_{j}',f'data merge entity @s {{Tags:["vr.display","vr.entity"],block_state:{{id:"{sh.get("block","minecraft:oak_planks")}"}},teleport_duration:1,interpolation_duration:1,view_range:1.0f,shadow_radius:0.0f}}','function vr:render/assign with storage vr:work owner',f'scoreboard players set @s vr.voxel {j}')
 # world and fluid loop unrolled at build time; centered OBB voxels
 fn(f'shape/{name}/world',*[ [setv('local',literal(dict(zip(AX,p)))),'function vr:world/voxel'] for p in pts])
 fn(f'shape/{name}/fluid',*[ [setv('local',literal(dict(zip(AX,p)))),'function vr:fluid/voxel'] for p in pts])
 fn(f'shape/{name}/pairs',*[ [setv('local',literal(dict(zip(AX,p)))),'function vr:pair/voxel'] for p in pts])
 # pre-generated balanced BVH of B local centers; bounding spheres include voxel radius
 nodes=[]
 def tree(items):
  index=len(nodes); nodes.append(None)
  center=[(min(p[k] for p in items)+max(p[k] for p in items))/2 for k in range(3)]
  rad=max(math.dist(center,p) for p in items)+math.sqrt(3)/2
  lines=[setv('node',literal(dict(zip(AX,center))))]
  lines+=cv('nc',[add(x,y) for x,y in zip(mv(mat('b.R'),vec('node')),vec('bp'))])
  lines += [score('bound',sub(dot([sub(x,y) for x,y in zip(vec('nc'),vec('ac'))],[sub(x,y) for x,y in zip(vec('nc'),vec('ac'))]),(rad+math.sqrt(3)/2)**2)), 'scoreboard players add #bvh vr.stat 1','execute if score #bound vr.tmp matches 1.. run return 0']
  if len(items)==1:
   lines += [cp('bc','nc'),'function vr:collision/sat','execute if score #hit vr.tmp matches 1 run function vr:contact/append','return 1']
  else:
   axis=max(range(3),key=lambda k:max(p[k] for p in items)-min(p[k] for p in items));items=sorted(items,key=lambda p:p[axis]);m=len(items)//2
   l=tree(items[:m]);r=tree(items[m:]);lines += [f'function vr:shape/{name}/bvh/{l}',f'function vr:shape/{name}/bvh/{r}']
  nodes[index]=lines;return index
 tree(pts)
 for j,lines in enumerate(nodes):fn(f'shape/{name}/bvh/{j}',lines)
 # Rendering updates all same-owner entities with constant-index entry points
 lines=[]
 for j,p in enumerate(pts):
  off=[v-.5 for v in p]
  lines+=cv('draw.t',mv(mat('a.R'),off))
  lines += [f'function vr:render/voxel_{j} with storage vr:work draw']
 fn(f'shape/{name}/render',lines)
js(PACK/'pack.mcmeta',{'pack':{'min_format':[121,0],'max_format':[121,0],'description':'Voxel Rigid 0.6 | 26.3 | experimental OBB rigid bodies'}})
for n in ['load','tick']:js(PACK/f'data/minecraft/tags/function/{n}.json',{'values':['vr:'+n]})
js(PACK/'data/vr/tags/block/passable.json',{'replace':False,'values':['minecraft:air','minecraft:cave_air','minecraft:void_air','minecraft:water','minecraft:lava','minecraft:short_grass','minecraft:tall_grass','minecraft:fern','minecraft:large_fern','minecraft:seagrass','minecraft:tall_seagrass','minecraft:kelp','minecraft:kelp_plant','minecraft:vine','minecraft:fire','minecraft:soul_fire','minecraft:torch','minecraft:wall_torch','minecraft:redstone_wire','minecraft:light']})
fn('load',[f'scoreboard objectives add vr.{n} dummy' for n in ['id','voxel','tmp','stat']], 'execute unless score #next vr.id matches 0.. run scoreboard players set #next vr.id 0','execute unless data storage vr:config settings run data modify storage vr:config settings set value {enabled:1b}','data modify storage vr:work blank set value {}')
fn('tick','execute unless data storage vr:config settings{enabled:1b} run return 0',[f'scoreboard players set #{x} vr.stat 0' for x in ['sat','bvh','world','contacts','overflow','pairs']],*[f'execute in minecraft:{d} run function vr:tick/dimension' for d in ['overworld','the_nether','the_end']])
fn('tick/dimension','execute unless entity @e[type=minecraft:marker,tag=vr.root] run return 0','function vr:tick/substep','function vr:tick/substep','execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:render/body')
fn('tick/substep','execute as @e[type=minecraft:marker,tag=vr.root] at @s run function vr:body/integrate','execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen] at @s run function vr:body/world','execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen] at @s run function vr:pair/outer')
fn('dispatch/state','$return run function vr:state/$(state)')
fn('dispatch/world','$function vr:shape/$(shape)/world')
fn('dispatch/fluid','$function vr:shape/$(shape)/fluid')
fn('dispatch/pairs','$function vr:shape/$(shape)/pairs')
fn('dispatch/bvh','$function vr:shape/$(shape)/bvh/0')
fn('dispatch/render','$function vr:shape/$(shape)/render')
fn('body/integrate','tag @s remove vr.frozen','data modify storage vr:work a set from entity @s data',cp('a.previous.o','a.o'),cp('a.previous.p','a.p'),cp('a.previous.q','a.q'),'function vr:dispatch/state with storage vr:work a','data modify entity @s data set from storage vr:work a','function vr:body/teleport with storage vr:work a')
fn('state/static','return 0')
# Quaternion qdot = .5 * omega(world) * q ; dt=.5 tick. inertia recomputed on use.
q=[S('a.q.'+x) for x in 'xyzw'];w=vec('a.w');v=vec('a.v')
qd=[add(mul(w[i],q[3]),cross(w,q[:3])[i]) for i in range(3)]+[mul(-1.0,dot(w,q[:3]))]
lines=['function vr:math/matrix',setv('force',literal(zero)),setv('torque',literal(zero)),setv('wet','0.0f'),setv('flow',literal(zero)),'execute if data storage vr:config water_velocity run data modify storage vr:work flow set from storage vr:config water_velocity','function vr:dispatch/fluid with storage vr:work a','function vr:math/inertia']
lines+=cv('a.v',[mul(.998,add(v[i],mul(.5,add(mul(S('force.'+x),S('a.inv_mass')),-.04 if i==1 else 0.0)))) for i,x in enumerate(AX)])
lines+=cv('a.w',[mul(.995,add(w[i],mul(.5,mv(mat('a.K'),vec('torque'))[i]))) for i in range(3)])
# clamp velocities, cap rotational edge movement for discrete collision
lines += [calc('speed',norm(vec('a.v'))),calc('spin',norm(vec('a.w'))),calc('vs',div(.45,mx(.45,S('speed')))),calc('ws',div(.18,mx(.18,mul(S('spin'),S('a.radius')))))]
lines+=cv('a.v',[mul(x,S('vs')) for x in vec('a.v')]);lines+=cv('a.w',[mul(x,S('ws')) for x in vec('a.w')])
lines+=cv('a.p',[add(x,mul(.5,y)) for x,y in zip(vec('a.p'),vec('a.v'))])
lines += [calc('qn.'+x,add(q[i],mul(.25,qd[i]))) for i,x in enumerate('xyzw')]
lines += [calc('qlen',mx(1e-9,norm([S('qn.'+x) for x in 'xyzw'])))]
lines += [calc('a.q.'+x,div(S('qn.'+x),S('qlen'))) for x in 'xyzw']
lines += ['function vr:math/matrix','function vr:body/rebase']
fn('state/dynamic',lines)
fn('body/teleport','$execute positioned $(o.x) $(o.y) $(o.z) run tp @s ~$(p.x) ~$(p.y) ~$(p.z)')
# Macros do NOT support dotted variable keys. Flatten explicitly before call.
fn('body/teleport',*[f'data modify storage vr:work tp.{x} set from storage vr:work a.p.{x}' for x in AX],*[f'data modify storage vr:work tp.o{x} set from storage vr:work a.o.{x}' for x in AX],'function vr:body/tp_macro with storage vr:work tp')
fn('body/tp_macro','$execute positioned $(ox).0 $(oy).0 $(oz).0 run tp @s ~$(x) ~$(y) ~$(z)')
rebase=[]
for x in AX:
 rebase += [score('shift',op('floor',S('a.p.'+x)),1),f'execute store result storage vr:work shift int 1 run scoreboard players get #shift vr.tmp',calc('a.p.'+x,sub(S('a.p.'+x),{'type':'minecraft:from_int','input':{'type':'minecraft:storage','storage':'vr:work','path':'shift'}})),f'data modify storage vr:work a.o.{x} set compute default integer '+raw({'type':'minecraft:add','inputs':[{'type':'minecraft:storage','storage':'vr:work','path':'a.o.'+x},{'type':'minecraft:storage','storage':'vr:work','path':'shift'}]})]
fn('body/rebase',rebase)
# quaternion -> rotation matrix (row-major, column vectors)
x,y,z,t=q
R=[[sub(1.0,mul(2.0,add(mul(y,y),mul(z,z)))),mul(2.0,sub(mul(x,y),mul(z,t))),mul(2.0,add(mul(x,z),mul(y,t)))],[mul(2.0,add(mul(x,y),mul(z,t))),sub(1.0,mul(2.0,add(mul(x,x),mul(z,z)))),mul(2.0,sub(mul(y,z),mul(x,t)))],[mul(2.0,sub(mul(x,z),mul(y,t))),mul(2.0,add(mul(y,z),mul(x,t))),sub(1.0,mul(2.0,add(mul(x,x),mul(y,y))))]]
fn('math/matrix',[calc(f'a.R.r{i}{j}',R[i][j]) for i in range(3) for j in range(3)])
lines=[]
for k in ['a','b']:
 r=mat(k+'.R');j=mat(k+'.J')
 lines += [calc(f'{k}.K.r{u}{v}',add(*(mul(r[u][i],j[i][l],r[v][l]) for i in range(3) for l in range(3)))) for u in range(3) for v in range(3)]
fn('math/inertia',lines)
# Static environment proxy is an axis-aligned unit cube. Unknown solid shapes are full cubes.
static={'p':zero.copy(),'v':zero.copy(),'w':zero.copy(),'R':identity,'J':dict.fromkeys(identity,0.0),'inv_mass':0.0,'e':.1,'mu':.65}
fn('body/world','data modify storage vr:work a set from entity @s data','execute if data storage vr:work a{state:"static"} run return 0',setv('b',literal(static)),setv('bp',literal(zero)),setv('contacts','[]'),'scoreboard players set #contact_count vr.tmp 0','scoreboard players set #unloaded vr.tmp 0','function vr:dispatch/world with storage vr:work a','execute if score #unloaded vr.tmp matches 1 run return run function vr:body/freeze','function vr:contact/solve_all','data modify entity @s data set from storage vr:work a','function vr:body/teleport')
fn('body/freeze','tag @s add vr.frozen',cp('a.o','a.previous.o'),cp('a.p','a.previous.p'),cp('a.q','a.previous.q'),setv('a.v',literal(zero)),setv('a.w',literal(zero)),'data modify entity @s data set from storage vr:work a','function vr:body/teleport','return 0')
lines=cv('ac',[add(a,b) for a,b in zip(vec('a.p'),mv(mat('a.R'),vec('local')))])
for x in AX:lines+=[calc('base.'+x,op('floor',S('ac.'+x)))]
# Pre-generated fixed neighborhood. Binary selection on BVH below, not a false binary search through terrain.
for ox,oy,oz in itertools.product([-1,0,1],repeat=3):
 lines+=cv('bc',[add(S('base.'+x),float(o)+.5) for x,o in zip(AX,[ox,oy,oz])])
 lines += [score('cheap',mx(*(sub(op('abs',sub(S('bc.'+x),S('ac.'+x))),1.366026) for x in AX))),'execute unless score #cheap vr.tmp matches 1.. run function vr:world/candidate']
fn('world/voxel',lines)
lines=[]
for x in AX:lines += [calc('query.'+x,sub(S('bc.'+x),.5)),cp('query.o'+x,'a.o.'+x)]
lines+=['function vr:world/block with storage vr:work query']
fn('world/candidate',lines)
fn('world/block','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) unless loaded ~ ~ ~ run scoreboard players set #unloaded vr.tmp 1','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) if loaded ~ ~ ~ unless block ~ ~ ~ #vr:passable run function vr:world/solid')
fn('world/solid','scoreboard players add #world vr.stat 1','function vr:collision/sat','execute if score #hit vr.tmp matches 1 run function vr:contact/append')
# Pair enumeration: each unordered pair once, dimension-local, radius bound <= 8.
fn('pair/outer','tag @s add vr.a','scoreboard players operation #aid vr.tmp = @s vr.id','execute as @e[type=minecraft:marker,tag=vr.root,tag=!vr.frozen,distance=..17] if score @s vr.id > #aid vr.tmp run function vr:pair/body','tag @s remove vr.a')
lines=['data modify storage vr:work a set from entity @e[type=minecraft:marker,tag=vr.a,limit=1] data','data modify storage vr:work b set from entity @s data','execute if data storage vr:work a{state:"static"} if data storage vr:work b{state:"static"} run return 0']
for x in AX:
 lines += [f'data modify storage vr:work od.{x} set compute default integer '+raw({'type':'minecraft:sub','left':{'type':'minecraft:storage','storage':'vr:work','path':'b.o.'+x},'right':{'type':'minecraft:storage','storage':'vr:work','path':'a.o.'+x}}),calc('bp.'+x,add(S('b.p.'+x),{'type':'minecraft:from_int','input':{'type':'minecraft:storage','storage':'vr:work','path':'od.'+x}}))]
lines += [score('bound',sub(norm([sub(x,y) for x,y in zip(vec('a.p'),vec('bp'))]),add(S('a.radius'),S('b.radius')))),'execute if score #bound vr.tmp matches 1.. run return 0','scoreboard players add #pairs vr.stat 1',setv('contacts','[]'),'scoreboard players set #contact_count vr.tmp 0','function vr:dispatch/pairs with storage vr:work a','function vr:contact/solve_all','data modify entity @e[type=minecraft:marker,tag=vr.a,limit=1] data set from storage vr:work a','data modify entity @s data set from storage vr:work b','data modify storage vr:work save_a set from storage vr:work a',cp('a','b'),'function vr:body/teleport',cp('a','save_a'),'execute as @e[type=minecraft:marker,tag=vr.a,limit=1] run function vr:body/teleport']
fn('pair/body',lines)
fn('pair/voxel',cv('ac',[add(a,b) for a,b in zip(vec('a.p'),mv(mat('a.R'),vec('local')))]),'function vr:dispatch/bvh with storage vr:work b')
# SAT: 3 A axes, 3 B axes, 9 cross axes; min normalized penetration, n points B -> A.
a_axes=tr(mat('a.R')); b_axes=tr(mat('b.R'))
lines=['scoreboard players add #sat vr.stat 1','scoreboard players set #hit vr.tmp 0',setv('best.depth','1000.0f')]
axes=a_axes+b_axes+[cross(a,b) for a in a_axes for b in b_axes]
for i,axis in enumerate(axes):
 lines += cv('axis',axis)+['execute unless function vr:collision/axis run return 0']
lines += ['scoreboard players set #hit vr.tmp 1','return 1']
fn('collision/sat',lines)
v=vec('axis'); length=norm(v)
lines=[calc('length',length),score('deg',S('length')),'execute if score #deg vr.tmp matches ..100 run return 1']
lines += cv('n',[div(a,S('length')) for a in v])
lines += [calc('signed',dot([sub(a,b) for a,b in zip(vec('ac'),vec('bc'))],vec('n'))),calc('depth',sub(mul(.5,add(*(op('abs',dot(vec('n'),a)) for a in a_axes+b_axes))),op('abs',S('signed')))),score('sep',S('depth')),'execute if score #sep vr.tmp matches ..0 run return 0',score('better',sub(S('depth'),S('best.depth'))),'execute if score #better vr.tmp matches ..-1 run function vr:collision/best','return 1']
fn('collision/axis',lines)
fn('collision/best',cp('best.depth','depth'),cp('best.n','n'),score('sign',S('signed')),*[f'execute if score #sign vr.tmp matches ..-1 run '+calc('best.n.'+x,mul(-1.0,S('n.'+x))) for x in AX])
# Contact approximation: midpoint between feature support centers. Face-face coplanar projections corrected by overlap center for axis-aligned contact. No clipped manifold.
lines=['execute if score #contact_count vr.tmp matches 32.. run return run function vr:contact/overflow',cp('c.n','best.n'),cp('c.depth','best.depth')]
# support-feature center uses sign of projection, ignores near-zero axes
for k,axes0,sign in [('a',a_axes,-1),('b',b_axes,1)]:
 lines += cv('support',vec('ac' if k=='a' else 'bc'))
 for i,axis in enumerate(axes0):
  lines += [score('sign',dot(axis,vec('c.n'))),'scoreboard players set #sgn vr.tmp 0','execute if score #sign vr.tmp matches 100.. run scoreboard players set #sgn vr.tmp 1','execute if score #sign vr.tmp matches ..-100 run scoreboard players set #sgn vr.tmp -1','execute store result storage vr:work sgn float 1 run scoreboard players get #sgn vr.tmp']
  lines += cv('support',[add(S('support.'+x),mul(sign*.5,S('sgn'),axis[j])) for j,x in enumerate(AX)])
 lines += [cp('support_'+k,'support')]
lines += cv('c.point',[mul(.5,add(a,b)) for a,b in zip(vec('support_a'),vec('support_b'))])
lines += ['data modify storage vr:work contacts append from storage vr:work c','scoreboard players add #contact_count vr.tmp 1','scoreboard players add #contacts vr.stat 1']
fn('contact/append',lines)
fn('contact/overflow','scoreboard players add #overflow vr.stat 1','return 0')
# iterative normal and Coulomb friction impulses, full world inertia tensor, no gyro term
fn('contact/solve_all','execute unless data storage vr:work contacts[0] run return 0','function vr:math/inertia','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/loop','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/loop','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/loop','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/loop','execute store result storage vr:work count float 1 run scoreboard players get #contact_count vr.tmp','data modify storage vr:work queue set from storage vr:work contacts','function vr:contact/correct_loop')
fn('contact/loop','execute unless data storage vr:work queue[0] run return 0',cp('c','queue[0]'),'data remove storage vr:work queue[0]','function vr:contact/impulse','return run function vr:contact/loop')
ra=[sub(a,b) for a,b in zip(vec('c.point'),vec('a.p'))];rb=[sub(a,b) for a,b in zip(vec('c.point'),vec('bp'))]
fn('contact/velocity',cv('ra',ra),cv('rb',rb),cv('rel',[sub(add(v,rot),add(vb,rotb)) for v,rot,vb,rotb in zip(vec('a.v'),cross(vec('a.w'),vec('ra')),vec('b.v'),cross(vec('b.w'),vec('rb')))]))
def denom(direction):
 return add(S('a.inv_mass'),S('b.inv_mass'),dot(cross(mv(mat('a.K'),cross(vec('ra'),direction)),vec('ra')),direction),dot(cross(mv(mat('b.K'),cross(vec('rb'),direction)),vec('rb')),direction))
lines=['function vr:contact/velocity',calc('vn',dot(vec('rel'),vec('c.n'))),score('vn',S('vn')),'execute if score #vn vr.tmp matches 0.. run return 0',calc('bounce',mn(S('a.e'),S('b.e'))),'execute if score #vn vr.tmp matches -80000.. run '+setv('bounce','0.0f'),calc('den',mx(.000001,denom(vec('c.n')))),calc('jn',div(mul(-1.0,add(1.0,S('bounce')),S('vn')),S('den')))]
lines += cv('imp',[mul(x,S('jn')) for x in vec('c.n')])+['function vr:contact/apply','function vr:contact/velocity']
lines += [calc('vn',dot(vec('rel'),vec('c.n')))]+cv('tan',[sub(a,mul(S('vn'),b)) for a,b in zip(vec('rel'),vec('c.n'))])
lines += [calc('tl',norm(vec('tan'))),score('tl',S('tl')),'execute if score #tl vr.tmp matches ..1 run return 0']+cv('tan',[div(a,S('tl')) for a in vec('tan')])
lines += [calc('den',mx(.000001,denom(vec('tan')))),calc('jt',mn(div(S('tl'),S('den')),mul(S('jn'),op('sqrt',mul(S('a.mu'),S('b.mu'))))))]
lines+=cv('imp',[mul(-1.0,x,S('jt')) for x in vec('tan')])+['function vr:contact/apply']
fn('contact/impulse',lines)
lines=[]
for k,sign in [('a',1.),('b',-1.)]:
 lines+=cv(k+'.v',[add(a,mul(sign,S(k+'.inv_mass'),b)) for a,b in zip(vec(k+'.v'),vec('imp'))])
 lines+=cv(k+'.w',[add(a,mul(sign,b)) for a,b in zip(vec(k+'.w'),mv(mat(k+'.K'),cross(vec('r'+k),vec('imp'))))])
fn('contact/apply',lines)
fn('contact/correct_loop','execute unless data storage vr:work queue[0] run return 0',cp('c','queue[0]'),'data remove storage vr:work queue[0]','function vr:contact/correct','return run function vr:contact/correct_loop')
lines=[calc('correction',div(mul(.3,mn(.2,mx(0.0,sub(S('c.depth'),.001)))),mx(.000001,mul(S('count'),add(S('a.inv_mass'),S('b.inv_mass'))))))]
for k,sign in [('a',1.),('b',-1.)]:lines+=cv(k+'.p',[add(a,mul(sign,S('correction'),S(k+'.inv_mass'),b)) for a,b in zip(vec(k+'.p'),vec('c.n'))])
fn('contact/correct',lines)
# Fluid volume sampled at 8 local subvoxel centers; displaced-volume force and point drag.
lines=[]
for o in itertools.product([-.25,.25],repeat=3):
 lines+=cv('r',mv(mat('a.R'),[add(v,float(off)) for v,off in zip(vec('local'),o)]))
 lines+=cv('sample',[add(a,b) for a,b in zip(vec('a.p'),vec('r'))])
 for x in AX:lines += [cp('sample.o'+x,'a.o.'+x)]
 lines+=['function vr:fluid/sample with storage vr:work sample']
fn('fluid/voxel',lines)
# Exact source-water surface 8/9, falling/flowing water treated as full cell (documented).
fn('fluid/sample','$execute positioned $(ox).0 $(oy).0 $(oz).0 positioned ~$(x) ~$(y) ~$(z) if block ~ ~ ~ minecraft:water run function vr:fluid/wet')
lines=[calc('frac_y',sub(S('sample.y'),op('floor',S('sample.y')))),score('surface',S('frac_y')),'execute if block ~ ~ ~ minecraft:water[level=0] unless block ~ ~1 ~ minecraft:water if score #surface vr.tmp matches 888889.. run return 0']
pointv=[add(a,b) for a,b in zip(vec('a.v'),cross(vec('a.w'),vec('r')))]
lines+=cv('df',[add(mul(-.02*.125,sub(a,S('flow.'+AX[i]))),.04*.125 if i==1 else 0.0) for i,a in enumerate(pointv)])
lines+=cv('force',[add(a,b) for a,b in zip(vec('force'),vec('df'))])
lines+=cv('torque',[add(a,b) for a,b in zip(vec('torque'),cross(vec('r'),vec('df')))])
lines += [calc('wet',add(S('wet'),.125))]
fn('fluid/wet',lines)
# Display transform refresh once per tick. Each display entity stays at the common COM.
fn('render/assign','$scoreboard players set @s vr.id $(id)')
lines=['data modify storage vr:work a set from entity @s data','function vr:math/matrix','execute store result storage vr:work draw.id int 1 run scoreboard players get @s vr.id']
for x in AX:lines += [cp('draw.o'+x,'a.o.'+x),cp('draw.p'+x,'a.p.'+x)]
for x in 'xyzw':lines += [cp('draw.q'+x,'a.q.'+x)]
lines += ['function vr:dispatch/render with storage vr:work a']
fn('render/body',lines)
for j in range(max(len(s['voxels']) for s in shapes.values())):
 fn('render/voxel_'+str(j),cp('draw.tx','draw.t.x'),cp('draw.ty','draw.t.y'),cp('draw.tz','draw.t.z'),f'function vr:render/update_{j} with storage vr:work draw')
 fn('render/update_'+str(j),f'$execute positioned $(ox).0 $(oy).0 $(oz).0 run tp @e[type=minecraft:block_display,tag=vr.display,scores={{vr.id=$(id),vr.voxel={j}}}] ~$(px) ~$(py) ~$(pz)',f'$execute as @e[type=minecraft:block_display,tag=vr.display,scores={{vr.id=$(id),vr.voxel={j}}}] run data merge entity @s {{start_interpolation:0,transformation:{{translation:[$(tx)f,$(ty)f,$(tz)f],left_rotation:[$(qx)f,$(qy)f,$(qz)f,$(qw)f],scale:[1.0f,1.0f,1.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f]}}}}')
fn('api/pause','data modify storage vr:config settings.enabled set value 0b')
fn('api/resume','data modify storage vr:config settings.enabled set value 1b')
fn('api/clear',*[f'execute in minecraft:{d} run kill @e[type=minecraft:marker,tag=vr.root]' for d in ['overworld','the_nether','the_end']],*[f'execute in minecraft:{d} run kill @e[type=minecraft:block_display,tag=vr.display]' for d in ['overworld','the_nether','the_end']])
fn('api/remove','execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','execute store result storage vr:work owner.id int 1 run scoreboard players get @s vr.id','function vr:api/remove_displays with storage vr:work owner','kill @s')
fn('api/remove_displays','$kill @e[type=minecraft:block_display,tag=vr.display,scores={vr.id=$(id)}]')
fn('api/static','execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','data modify entity @s data.state set value "static"','data modify entity @s data.inv_mass set value 0.0f',f'data modify entity @s data.J set value {literal(dict.fromkeys(identity,0.0))}',f'data modify entity @s data.v set value {literal(zero)}',f'data modify entity @s data.w set value {literal(zero)}')
fn('api/stats','tellraw @s [{text:"VR SAT="},{score:{name:"#sat",objective:"vr.stat"}},{text:" BVH="},{score:{name:"#bvh",objective:"vr.stat"}},{text:" world="},{score:{name:"#world",objective:"vr.stat"}},{text:" contacts="},{score:{name:"#contacts",objective:"vr.stat"}},{text:" overflow="},{score:{name:"#overflow",objective:"vr.stat"}}]')
# Three non-destructive spawns; demo does not modify terrain.
fn('demo','execute positioned ~ ~3 ~ run function vr:spawn/cube','execute positioned ~2 ~5 ~ run function vr:spawn/bar','execute positioned ~-2 ~4 ~ run function vr:spawn/ell')
# Continuous, translation-only OBB sweep. interval intersection is the authoritative
# predicate; binary search refines the monotone "some hit in [0,t]" predicate.
lines=[setv('sweep.enter','0.0f'),cp('sweep.exit','sweep.limit'),'scoreboard players set #sweep_hit vr.tmp 0']
for axis in axes:
 lines += cv('axis',axis)+['execute unless function vr:query/sweep_axis run return 0']
lines += ['scoreboard players set #sweep_hit vr.tmp 1','return 1']
fn('query/sweep_test',lines)
lines=[calc('length',norm(vec('axis'))),score('deg',S('length')),'execute if score #deg vr.tmp matches ..100 run return 1']
lines+=cv('n',[div(a,S('length')) for a in vec('axis')])
lines += [calc('sweep.d',dot([sub(a,b) for a,b in zip(vec('ac'),vec('bc'))],vec('n'))),calc('sweep.speed',dot(vec('sweep.delta'),vec('n'))),calc('sweep.radius',mul(.5,add(*(op('abs',dot(vec('n'),a)) for a in a_axes+b_axes)))),score('speed',op('abs',S('sweep.speed'))),'execute if score #speed vr.tmp matches ..1 run return run function vr:query/sweep_parallel',calc('sweep.t0',div(sub(mul(-1.,S('sweep.radius')),S('sweep.d')),S('sweep.speed'))),calc('sweep.t1',div(sub(S('sweep.radius'),S('sweep.d')),S('sweep.speed'))),calc('sweep.enter',mx(S('sweep.enter'),mn(S('sweep.t0'),S('sweep.t1')))),calc('sweep.exit',mn(S('sweep.exit'),mx(S('sweep.t0'),S('sweep.t1')))),score('interval',sub(S('sweep.enter'),S('sweep.exit'))),'execute if score #interval vr.tmp matches 1.. run return 0','return 1']
fn('query/sweep_axis',lines)
fn('query/sweep_parallel',score('outside',sub(op('abs',S('sweep.d')),S('sweep.radius'))),'execute if score #outside vr.tmp matches 1.. run return 0','return 1')
fn('query/sweep',setv('sweep.limit','1.0f'),'execute unless function vr:query/sweep_test run return 0',cp('sweep.exact','sweep.enter'),setv('sweep.lo','0.0f'),setv('sweep.hi','1.0f'),['function vr:query/bisect' for _ in range(10)],cp('sweep.toi','sweep.hi'),'return 1')
fn('query/bisect',calc('sweep.limit',mul(.5,add(S('sweep.lo'),S('sweep.hi')))),'function vr:query/sweep_test','execute if score #sweep_hit vr.tmp matches 1 run '+cp('sweep.hi','sweep.limit'),'execute if score #sweep_hit vr.tmp matches 0 run '+cp('sweep.lo','sweep.limit'))
exec((ROOT/'src/add_tests.py').read_text(), globals())
js(ROOT/'src/generated_metadata.json',meta)
exec((ROOT/'src/configuration.py').read_text(), globals())
exec((ROOT/'src/profiling.py').read_text(), globals())
exec((ROOT/'src/scheduler.py').read_text(), globals())
exec((ROOT/'src/attack_input.py').read_text(), globals())
exec((ROOT/'src/bookshelf_world.py').read_text(), globals())
exec((ROOT/'src/convert_block.py').read_text(), globals())
exec((ROOT/'src/dynamic_shapes.py').read_text(), globals())
exec((ROOT/'src/entity_collision.py').read_text(), globals())
exec((ROOT/'src/material_management.py').read_text(), globals())
exec((ROOT/'src/score_backend.py').read_text(), globals())
with (F/'load.mcfunction').open('a') as out:
 out.write('scoreboard objectives add vr.updates dummy\nscoreboard objectives add vr.prof dummy\nexecute unless score #query_mode vr.cfg matches 0..1 run scoreboard players set #query_mode vr.cfg 1\n')
print(f'Generated {len(list(F.rglob("*.mcfunction")))} functions, {len(providers)} providers, {len(shapes)} shapes')
