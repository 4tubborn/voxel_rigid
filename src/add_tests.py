# Executed by build.py in its namespace, creates real in-game numerical tests.
checks=[]
def check(label,command):
 checks.append(label)
 return [command+' run scoreboard players add #fail vr.test 1']
fixture=[setv('a',literal(meta['cube']['body'])),setv('b',literal(static)),setv('ac',literal(zero)),setv('bc','{x:2.0f,y:0.0f,z:0.0f}')]
ls=['scoreboard objectives add vr.test dummy','scoreboard players set #fail vr.test 0']+fixture
ls+=['function vr:collision/sat']+check('separated cubes','execute unless score #hit vr.tmp matches 0')
ls+=[setv('bc.x','0.75f'),'function vr:collision/sat']+check('overlapping cubes','execute unless score #hit vr.tmp matches 1')
ls+=[score('test',S('best.depth'),1000)]+check('penetration 0.25','execute unless score #test vr.tmp matches 250')
ls+=[setv('a.q','{x:0.0f,y:0.382683432f,z:0.0f,w:0.923879533f}'),'function vr:math/matrix',setv('bc.x','1.1f'),'function vr:collision/sat']+check('rotated overlap','execute unless score #hit vr.tmp matches 1')
ls+=[setv('bc.x','1.3f'),'function vr:collision/sat']+check('rotated separation','execute unless score #hit vr.tmp matches 0')
ls+=fixture+[setv('bc.x','3.0f'),setv('sweep','{delta:{x:6.0f,y:0.0f,z:0.0f}}'),'execute store result score #test vr.tmp run function vr:query/sweep']+check('swept hit despite clear endpoint','execute unless score #test vr.tmp matches 1')
ls+=[score('test',S('sweep.toi'),10000)]+check('binary TOI near one third','execute unless score #test vr.tmp matches 3333..3344')
# Head-on elastic collision of equal unit masses, centered contact.
a=meta['cube']['body'].copy();a.update({'inv_mass':1.0,'e':1.0,'p':zero,'v':{'x':1.,'y':0.,'z':0.},'w':zero})
b=a.copy();b.update({'v':{'x':-1.,'y':0.,'z':0.},'p':{'x':1.,'y':0.,'z':0.}})
ls += [setv('a',literal(a)),setv('b',literal(b)),setv('bp',literal(b['p'])),'function vr:math/inertia',setv('c','{point:{x:0.5f,y:0.0f,z:0.0f},n:{x:-1.0f,y:0.0f,z:0.0f},depth:0.0f}'),'function vr:contact/impulse',score('test',S('a.v.x'),1000)]+check('elastic A reverses','execute unless score #test vr.tmp matches -1001..-999')
ls += [score('test',S('b.v.x'),1000)]+check('elastic B reverses','execute unless score #test vr.tmp matches 999..1001')
ls += [score('test',norm(vec('a.w')),1000)]+check('centered contact has no spin','execute unless score #test vr.tmp matches 0')
ls += [setv('a',literal(meta['cube']['body'])),setv('a.o','{x:0,y:100,z:0}'),setv('a.w','{x:0.01f,y:0.02f,z:0.03f}'),'function vr:state/dynamic',score('test',norm([S('a.q.'+x) for x in 'xyzw']),1000000)]+check('quaternion normalization','execute unless score #test vr.tmp matches 999998..1000001')
ls += [score('test',S('a.v.y'),1000000)]+check('gravity','execute unless score #test vr.tmp matches -19961..-19959')
ls+=['tellraw @a [{text:"[Voxel Rigid] self-test failures: "},{score:{name:"#fail",objective:"vr.test"}}]','return run scoreboard players get #fail vr.test']
fn('test/run',ls)
js(ROOT/'src/test_cases.json',checks)

# Regression for score -> macro ABI: stale/missing NBT must never be used.
fn('test/stale_parameters','$data modify storage vr:work query set value {x:$(stale)f,y:$(stale)f,z:$(stale)f}','$data modify storage vr:work sample set value {x:$(stale)f,y:$(stale)f,z:$(stale)f}')
fn('test/probe_parameter','$execute store result score #probe vr.test run compute default float {type:"minecraft:constant",value:$(x)} 10000')
fn('test/macro_bridge','scoreboard objectives add vr.test dummy','scoreboard players set #bridge_fail vr.test 0','data remove storage vr:work query','data remove storage vr:work sample',setv('query.x','0.25f'),'function vr:test/probe_parameter with storage vr:work query','execute unless score #probe vr.test matches 2500 run scoreboard players add #bridge_fail vr.test 1','function vr:test/stale_parameters {stale:123.0}',setv('sample.x','-0.5f'),'function vr:test/probe_parameter with storage vr:work sample','execute unless score #probe vr.test matches -5000 run scoreboard players add #bridge_fail vr.test 1','return run scoreboard players get #bridge_fail vr.test')
