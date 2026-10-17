"""Tool-only interaction input; analytic ray/voxel slabs and point impulses."""
js(PACK/'data/vr/advancement/input/attack.json',{'criteria':{'attack':{'trigger':'minecraft:player_hurt_entity','conditions':{'player':{'minecraft:equipment':{'mainhand':{'predicates':{'minecraft:custom_data':'{vr:{impulse_tool:1b}}'}}}},'entity':{'minecraft:entity_type':'minecraft:interaction','minecraft:nbt':'{Tags:["vr.attack_input"]}'}}}},'rewards':{'function':'vr:input/attack'}})
adv_path=PACK/'data/vr/advancement/input/attack.json'
adv=json.loads(adv_path.read_text())
conditions=adv['criteria']['attack']['conditions']
for key in ['player','entity']:
 conditions[key]={'type':'minecraft:entity_properties','entity':'this','predicate':conditions[key]}
js(adv_path,adv)
js(PACK/'data/minecraft/tags/function/tick.json',{'values':['vr:input/tick','vr:tick']})
with (F/'load.mcfunction').open('a') as out:
 out.write('scoreboard objectives add vr.input dummy\nexecute unless score #input_next vr.input matches 0.. run scoreboard players set #input_next vr.input 0\nexecute unless score #strength vr.input matches 1..10000 run scoreboard players set #strength vr.input 2000\n')
fn('input/give_tool','give @s minecraft:stick[minecraft:custom_data={vr:{impulse_tool:1b}},minecraft:custom_name={text:"Impulse Tool",italic:false}]')
fn('input/tick','execute in minecraft:overworld run function vr:input/dimension','execute in minecraft:the_nether run function vr:input/dimension','execute in minecraft:the_end run function vr:input/dimension')
fn('input/dimension','tag @e[type=minecraft:interaction,tag=vr.attack_input] remove vr.input_live','execute as @a[gamemode=!spectator] at @s if items entity @s weapon.mainhand *[minecraft:custom_data~{vr:{impulse_tool:1b}}] run function vr:input/player','kill @e[type=minecraft:interaction,tag=vr.attack_input,tag=!vr.input_live]')
fn('input/player','execute unless score @s vr.input matches 1.. run function vr:input/assign','scoreboard players operation #owner vr.input = @s vr.input','scoreboard players set #boxes vr.tmp 0','execute as @e[type=minecraft:interaction,tag=vr.attack_input] if score @s vr.input = #owner vr.input run scoreboard players set #boxes vr.tmp 1','execute if score #boxes vr.tmp matches 0 run execute summon minecraft:interaction run function vr:input/new_box','execute as @e[type=minecraft:interaction,tag=vr.attack_input] if score @s vr.input = #owner vr.input run function vr:input/follow')
fn('input/assign','scoreboard players add #input_next vr.input 1','scoreboard players operation @s vr.input = #input_next vr.input')
fn('input/new_box','data merge entity @s {Tags:["vr.attack_input","vr.entity"],width:4.0f,height:4.0f,response:0b}','scoreboard players operation @s vr.input = #owner vr.input')
fn('input/follow','tp @s ~ ~-1 ~','tag @s add vr.input_live')
fn('input/attack','advancement revoke @s only vr:input/attack','execute unless items entity @s weapon.mainhand *[minecraft:custom_data~{vr:{impulse_tool:1b}}] run return 0','execute if entity @s[gamemode=spectator] run return 0','execute store result score #reach vr.input run attribute @s minecraft:block_interaction_range get 10000','execute unless score #reach vr.input matches 1.. run return 0','scoreboard players operation #block_limit vr.input = #reach vr.input','execute if score #bookshelf vr.input matches 1 run function vr:input/bookshelf_view','execute at @s anchored eyes positioned ^ ^ ^ run function vr:input/cast')
# The eye command position/rotation survives execute as root. A scratch probe is
# translated by integer origin before extracting fixed point coordinates.
fn('input/cast','kill @e[type=minecraft:marker,tag=vr.input_probe]','tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit','summon minecraft:marker ~ ~ ~ {Tags:["vr.input_probe","vr.entity"]}',calc('ray.best',mul(.0001,{'type':'minecraft:from_int','input':{'type':'minecraft:score','target':{'type':'minecraft:fixed','name':'#block_limit'},'score':'vr.input','fallback':45000}})),'scoreboard players set #ray_found vr.tmp 0',calc('ray.search_radius',add(8.0,mul(.0001,{'type':'minecraft:from_int','input':{'type':'minecraft:score','target':{'type':'minecraft:fixed','name':'#reach'},'score':'vr.input','fallback':45000}}))),'function vr:input/candidates with storage vr:work ray','kill @e[type=minecraft:marker,tag=vr.input_probe]','execute if score #ray_found vr.tmp matches 0 run return 0','scoreboard players set #ray_steps vr.tmp 0','execute unless score #bookshelf vr.input matches 1 if function vr:input/occlusion run return run function vr:input/blocked','execute as @e[type=minecraft:marker,tag=vr.input_hit,limit=1] run function vr:input/apply','tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit')
fn('input/translate','$execute as @e[type=minecraft:marker,tag=vr.input_probe,limit=1] at @s run tp @s ~$(x) ~$(y) ~$(z)')
ls=['data modify storage vr:work a set from entity @s data','function vr:math/matrix']
for x in AX:
 ls += [f'scoreboard players operation #neg vr.tmp = @s vr.o{x}','scoreboard players operation #neg vr.tmp *= #minus_one vr.input',f'execute store result storage vr:work ray_offset.{x} int 1 run scoreboard players get #neg vr.tmp']
for dest,where in [('eye','~ ~ ~'),('ahead','^ ^ ^1')]:
 ls += [f'tp @e[type=minecraft:marker,tag=vr.input_probe,limit=1] {where}','function vr:input/translate with storage vr:work ray_offset']
 for i,x in enumerate(AX):ls += [f'execute store result storage vr:work ray.{dest}.{x} float 0.0001 run data get entity @e[type=minecraft:marker,tag=vr.input_probe,limit=1] Pos[{i}] 10000']
ls += cv('ray.origin',mv(tr(mat('a.R')),[sub(v,p) for v,p in zip(vec('ray.eye'),vec('a.p'))]))
ls += cv('ray.direction',mv(tr(mat('a.R')),[sub(b,a) for a,b in zip(vec('ray.eye'),vec('ray.ahead'))]))
ls += ['function vr:input/dispatch with storage vr:work a']
fn('input/candidate',ls)
fn('input/dispatch','$function vr:shape/$(shape)/ray')
with (F/'load.mcfunction').open('a') as out:out.write('scoreboard players set #minus_one vr.input -1\n')
for name,md in meta.items():
 ls=[]
 for p in md['centers']:
  ls += [setv('ray.center',literal(dict(zip(AX,p)))),'function vr:input/voxel']
 fn('shape/'+name+'/ray',ls)
ls=[setv('ray.enter','0.0f'),cp('ray.exit','ray.best')]
for x in AX:ls += [cp('ray.u','ray.origin.'+x),cp('ray.d','ray.direction.'+x),cp('ray.c','ray.center.'+x),'execute unless function vr:input/slab run return 0']
ls += [score('ray_closer',sub(S('ray.best'),S('ray.enter'))),'execute if score #ray_found vr.tmp matches 1 if score #ray_closer vr.tmp matches ..0 run return 0',cp('ray.best','ray.enter'),*cv('ray.lever',mv(mat('a.R'),[add(o,mul(d,S('ray.enter'))) for o,d in zip(vec('ray.origin'),vec('ray.direction'))])),*cv('ray.world_direction',mv(mat('a.R'),vec('ray.direction'))),'tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit','tag @s add vr.input_hit','scoreboard players set #ray_found vr.tmp 1','return 1']
fn('input/voxel',ls)
fn('input/slab',score('ray_parallel',op('abs',S('ray.d'))),'execute if score #ray_parallel vr.tmp matches ..100 run return run function vr:input/parallel',calc('ray.t0',div(sub(sub(S('ray.c'),.5),S('ray.u')),S('ray.d'))),calc('ray.t1',div(sub(add(S('ray.c'),.5),S('ray.u')),S('ray.d'))),calc('ray.enter',mx(S('ray.enter'),mn(S('ray.t0'),S('ray.t1')))),calc('ray.exit',mn(S('ray.exit'),mx(S('ray.t0'),S('ray.t1')))),score('ray_interval',sub(S('ray.enter'),S('ray.exit'))),'execute if score #ray_interval vr.tmp matches 1.. run return 0','return 1')
fn('input/parallel',score('ray_outside',sub(op('abs',sub(S('ray.u'),S('ray.c'))),.5)),'execute if score #ray_outside vr.tmp matches 1.. run return 0','return 1')
# Full-block approximation, matching existing terrain collision. 0.05 block
# sampling may miss a grazing corner; not a voxel DDA.
fn('input/occlusion',score('ray_remaining',sub(S('ray.best'),mul(.05,{'type':'minecraft:from_int','input':{'type':'minecraft:score','target':{'type':'minecraft:fixed','name':'#ray_steps'},'score':'vr.tmp','fallback':0}}))),'execute if score #ray_remaining vr.tmp matches ..0 run return 0','execute unless loaded ~ ~ ~ run return 1','execute unless block ~ ~ ~ #vr:passable run return 1','scoreboard players add #ray_steps vr.tmp 1','return run execute positioned ^ ^ ^0.05 run function vr:input/occlusion')
strength=mul(.0001,{'type':'minecraft:from_int','input':{'type':'minecraft:score','target':{'type':'minecraft:fixed','name':'#strength'},'score':'vr.input','fallback':2000}})
ls=['data modify storage vr:work a set from entity @s data','execute if data storage vr:work a{state:"static"} run return 0','function vr:math/matrix','function vr:math/inertia']
ls += cv('ray.impulse',[mul(strength,v) for v in vec('ray.world_direction')])
ls += cv('a.v',[add(v,mul(S('a.inv_mass'),j)) for v,j in zip(vec('a.v'),vec('ray.impulse'))])
ls += cv('a.w',[add(w,dw) for w,dw in zip(vec('a.w'),mv(mat('a.K'),cross(vec('ray.lever'),vec('ray.impulse'))))])
ls += ['data modify entity @s data set from storage vr:work a','tag @s add vr.render_dirty','return 1']
fn('input/apply',ls)
# Focused numerical test: slab and off-center point impulse; independent of client.
fn('test/input',setv('ray.u','0.0f'),setv('ray.d','1.0f'),setv('ray.c','2.0f'),setv('ray.enter','0.0f'),setv('ray.exit','3.0f'),'execute unless function vr:input/slab run return 1',score('ray_test',S('ray.enter'),10000),'execute unless score #ray_test vr.tmp matches 15000 run return 2',setv('ray.u','0.6f'),setv('ray.c','0.0f'),setv('ray.d','0.0f'),'execute if function vr:input/slab run return 3','return 0')

fn('input/blocked','tag @e[type=minecraft:marker,tag=vr.input_hit] remove vr.input_hit','return 0')
fn('input/bookshelf_view','execute store result storage vr:work input_config.reach float 0.0001 run scoreboard players get #reach vr.input','function vr:input/bookshelf_view_macro with storage vr:work input_config')
fn('input/bookshelf_view_macro','$function #bs.view:at_aimed_point {run:"function vr:input/bookshelf_block",with:{entities:false,blocks:"function #bs.hitbox:callback/get_block_collision",max_distance:$(reach)}}')
fn('input/bookshelf_block','scoreboard players operation #block_limit vr.input = $raycast.entry_distance bs.lambda','scoreboard players operation #block_limit vr.input *= #ten vr.input','scoreboard players remove #block_limit vr.input 1')
with (F/'load.mcfunction').open('a') as out:out.write('execute unless score #bookshelf vr.input matches 0..1 run scoreboard players set #bookshelf vr.input 0\n')

with (F/'load.mcfunction').open('a') as out:out.write('scoreboard players set #ten vr.input 10\n')

fn('input/candidates','$execute as @e[type=minecraft:marker,tag=vr.root,distance=..$(search_radius),tag=!vr.frozen] run function vr:input/candidate')
