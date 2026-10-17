"""Post-pass lowering temporary and persistent numeric fields to scoreboard.
Executed in build.py's namespace after all functions/providers are generated.
Storage remains an explicit bridge for macros and contact queues.
"""
import copy
SCALE=10000
INTPATHS={'shift'}|{f'{b}.o.{x}' for b in ['a','b','save_a'] for x in AX}|{f'{b}.previous.o.{x}' for b in ['a','b','save_a'] for x in AX}|{f'{b}.count' for b in ['a','b','save_a']}
NUM=set()
def collect(v):
 if isinstance(v,dict):
  if v.get('type')=='minecraft:storage' and v.get('storage')=='vr:work':NUM.add(v['path'])
  for x in v.values():collect(x)
 elif isinstance(v,list):
  for x in v:collect(x)
for e in providers.values():collect(e)
texts={p:p.read_text().splitlines() for p in F.rglob('*.mcfunction')}
for lines0 in texts.values():
 for line in lines0:
  m=re.search(r'data modify storage vr:work (\S+) set compute default (float|integer)',line)
  if m:NUM.add(m[1])
  m=re.search(r'execute store result storage vr:work (\S+) (float|int) ',line)
  if m and m[1].startswith(('a.','b.')):NUM.add(m[1])
# Persistent fields use the same schema in A/B. All numeric leaves initialized.
def flatten(v,p=''):
 if isinstance(v,dict):
  for k,x in v.items():yield from flatten(x,p+'.'+k if p else k)
 elif isinstance(v,(int,float)) and not isinstance(v,bool):yield p,v
bodyfields={p for p,v in flatten(meta['cube']['body'])}
bodyfields|={'previous.'+p for p in bodyfields if p.startswith(('o.','p.','q.'))}
bodyfields|={f'K.r{i}{j}' for i in range(3) for j in range(3)}
for b in ['a','b','save_a']:
 NUM.update(b+'.'+p for p in bodyfields)
# Registers referenced via compound copies also need exact matching suffix sets.
def scale(p):return 1 if p in INTPATHS or p.startswith('od.') else SCALE
def holder(p):return '#'+p

def source(p,integer=False):
 q={'type':'minecraft:score','target':{'type':'minecraft:fixed','name':holder(p)},'score':'vr.num','fallback':0}
 if integer:return q
 v={'type':'minecraft:from_int','input':q}
 return v if scale(p)==1 else mul(1/SCALE,v)
def lower(v,integer=False):
 if isinstance(v,dict):
  if v.get('type')=='minecraft:storage' and v.get('storage')=='vr:work':return source(v['path'],integer)
  return {k:lower(x, v.get('type')=='minecraft:from_int' and k=='input' or integer) for k,x in v.items()}
 if isinstance(v,list):return [lower(x,integer) for x in v]
 return v
for p in P.glob('*.json'):js(p,lower(json.loads(p.read_text())))
def descendants(p):return sorted(q for q in NUM if q==p or q.startswith(p+'.'))
def parse_snbt(s):
 s=re.sub(r'(?<=[{,])([A-Za-z_][A-Za-z0-9_]*):',r'"\1":',s)
 s=re.sub(r'(?<=[0-9.])f(?=[,}\]]|$)','',s)
 s=re.sub(r'(?<=\d)b(?=[,}\]])','',s)
 return json.loads(s)
def get(v,p):
 for k in p.split('.'):
  if not isinstance(v,dict) or k not in v:return None
  v=v[k]
 return v
# objective names readable for the user; all shorter than 16 characters.
obj={}
for p in sorted(bodyfields):
 if p.startswith(('p.','v.','w.','q.','o.')):n=p.replace('.','')
 elif p.startswith(('R.','J.','K.','Ibody.')):n=({'R':'r','J':'j','K':'k','Ibody':'i'}[p.split('.')[0]])+p.split('.')[1][1:]
 elif p.startswith('previous.'):n='old'+p[len('previous.'):].replace('.','')
 else:n={'inv_mass':'im','density':'den','radius':'rad'}.get(p,p)
 obj[p]='vr.'+n;assert len(obj[p])<=16

def export(p):return [f'execute store result storage vr:work {q} {"int 1" if scale(q)==1 else "float 0.0001"} run scoreboard players get {holder(q)} vr.num' for q in descendants(p)]
def import_fields(dest,src):
 return [f'execute store result score {holder(q)} vr.num run data get storage vr:work {src+q[len(dest):]} {scale(q)}' for q in descendants(dest)]
def assign(dest,src):
 out=[]
 for q in descendants(dest):
  r=src+q[len(dest):]
  if r in NUM:out.append(f'scoreboard players operation {holder(q)} vr.num = {holder(r)} vr.num')
  else:out.append(f'execute store result score {holder(q)} vr.num run data get storage vr:work {r} {scale(q)}')
 return out

# Macro invocations are an ABI boundary: every numeric argument must be
# exported from its authoritative score immediately before macro expansion.
macro_fields={p.relative_to(F).as_posix()[:-11]:set(re.findall(r'\$\(([^)]+)\)', '\n'.join(lines0))) for p,lines0 in texts.items()}
def bridge(line):
 m=re.search(r'\bfunction vr:([a-z0-9_/]+) with storage vr:work (\S+)',line)
 if m:
  target,frame=m.groups()
  fields=[frame+'.'+k for k in sorted(macro_fields.get(target,set())) if frame+'.'+k in NUM]
  if fields:
   return [f'execute store result storage vr:work {q} {"int 1" if scale(q)==1 else "float 0.0001"} run scoreboard players get {holder(q)} vr.num' for q in fields]+[line]
 # Return a sequence replacing the numeric data command; prefix execute conditions preserved.
 m=re.search(r'data modify storage vr:work (\S+) set compute default (float|integer) (.*)$',line)
 if m:
  d,t,e=m.groups();expr=lower(json.loads(e),t=='integer') if e.startswith('{') else e
  if t=='float':expr={'type':'minecraft:round','input':mul(float(scale(d)),expr)}
  # Named float provider is evaluated through a registry ref inside the round wrapper.
  return [line[:m.start()]+f'execute store result score {holder(d)} vr.num run compute default '+('integer ' if t=='integer' else 'float ')+raw(expr)]
 m=re.search(r'execute store result storage vr:work (\S+) (float|int) ([0-9.]+) run (.*)$',line)
 if m and m[1] in NUM:
  d,t,sc,cmd=m.groups();factor=float(sc)*scale(d)
  if factor==1:return [line[:m.start()]+f'execute store result score {holder(d)} vr.num run '+cmd]
  # data-get/score result import used by wet sample and contact count
  if cmd.startswith('scoreboard players get '):
   q=cmd.split();return [line[:m.start()]+f'scoreboard players operation {holder(d)} vr.num = {q[3]} {q[4]}',line[:m.start()]+f'scoreboard players operation {holder(d)} vr.num *= #scale vr.num']
 m=re.search(r'data modify storage vr:work (\S+) set value (.*)$',line)
 if m and '$(' not in line:
  d,s=m.groups();targets=descendants(d)
  if targets:
   v=parse_snbt(s);out=[line] if isinstance(v,dict) and any(isinstance(x,str) for x in v.values()) else []
   for q in targets:
    x=get(v,q[len(d)+1:]) if q!=d else v
    if isinstance(x,(int,float)):out.append(line[:m.start()]+f'scoreboard players set {holder(q)} vr.num {round(x*scale(q))}')
    elif d in ['a','b']:out.append(line[:m.start()]+f'scoreboard players set {holder(q)} vr.num 0')
   return out
 m=re.search(r'data modify storage vr:work (\S+) set from storage vr:work (\S+)$',line)
 if m:
  d,s=m.groups();pre=line[:m.start()]
  if descendants(d):
   # Object copy retains metadata only for body roots; numeric leaves use registers.
   keep=[line] if d in ['a','b','save_a'] else []
   return keep+[pre+x for x in assign(d,s)]
  if s in NUM:return [pre+f'execute store result storage vr:work {d} {"int 1" if scale(s)==1 else "float 0.0001"} run scoreboard players get {holder(s)} vr.num']
  if descendants(s):return export(s)+[line]
 m=re.search(r'data modify storage vr:work (\S+) set from storage vr:config (\S+)$',line)
 if m and descendants(m[1]):return [line]+[line[:m.start()]+x for x in import_fields(m[1],m[1])]
 if 'contacts append from storage vr:work c' in line:return export('c')+[line]
 return [line]

def io_fields(path,mode):
 name=path.relative_to(F).as_posix()
 motion=lambda f:f.startswith(('o.','p.','v.','w.','q.'))
 if name=='render/body.mcfunction':return {f for f in bodyfields if f.startswith(('o.','p.','q.'))}
 if name.endswith('/init.mcfunction') and name.startswith('shape/'):
  return {f for f in bodyfields if f.startswith(('o.','p.','q.'))} if mode=='read' else {f for f in bodyfields if f.startswith(('o.','p.'))}
 if name=='body/integrate.mcfunction':
  base={f for f in bodyfields if motion(f) or f.startswith('J.') or f in ['inv_mass','radius','count']}
  return base if mode=='read' else base|{f for f in bodyfields if f.startswith(('R.','previous.'))}
 if name in ['body/world.mcfunction','body/freeze.mcfunction']:
  return {f for f in bodyfields if motion(f) or f.startswith(('R.','J.','previous.')) or f in ['inv_mass','e','mu']} if mode=='read' else {f for f in bodyfields if motion(f)}
 if name=='pair/body.mcfunction':
  return {f for f in bodyfields if motion(f) or f.startswith(('R.','J.')) or f in ['inv_mass','e','mu','radius']} if mode=='read' else {f for f in bodyfields if f.startswith(('p.','v.','w.'))}
 if name=='api/apply_mass.mcfunction':
  return {f for f in bodyfields if f.startswith(('J.','Ibody.')) or f in ['mass','count']} if mode=='read' else {f for f in bodyfields if f.startswith(('J.','Ibody.')) or f in ['mass','inv_mass','density']}
 if name=='api/set_density.mcfunction':return {'count'}
 return bodyfields
for p,lines0 in texts.items():
 out=[]
 if p.relative_to(F).as_posix()=='body/integrate.mcfunction':out.append('execute if data entity @s data{state:"static"} run return 0')
 for line in lines0:
  m=re.fullmatch(r'data modify storage vr:work ([ab]) set from entity (.+) data',line)
  if m:
   b,sel=m.groups();out.append(line)
   out += [f'scoreboard players operation #{b}.{field} vr.num = {sel} {objective}' for field,objective in obj.items() if field in io_fields(p,'read')]
   continue
  m=re.fullmatch(r'data modify entity (.+) data set from storage vr:work ([ab])',line)
  if m:
   sel,b=m.groups();out += [f'scoreboard players operation {sel} {objective} = #{b}.{field} vr.num' for field,objective in obj.items() if field in io_fields(p,'write')]
   # Shape and static/dynamic flags are stable metadata and not rewritten each update.
   continue
  m=re.fullmatch(r'data modify entity @s data set value (.*)',line)
  if m and '/shape/' in str(p):
   v=parse_snbt(m[1]);out += [f'data modify entity @s data set value {{shape:"{v["shape"]}",state:"{v["state"]}"}}']
   for field,objective in obj.items():out.append(f'scoreboard players set @s {objective} {round((get(v,field) or 0)*scale("a."+field))}')
   continue
  out+=bridge(line)
 write(p,'\n'.join(out)+'\n')
# Load objectives before any physics function.
p=F/'load.mcfunction';s=p.read_text();s='scoreboard objectives add vr.num dummy\nscoreboard objectives add vr.cfg dummy\n'+''.join(f'scoreboard objectives add {o} dummy\n' for o in obj.values())+f'scoreboard players set #scale vr.num {SCALE}\n'+s
s += 'function vr:config/defaults\n'
write(p,s)
js(ROOT/'src/scoreboard_schema.json',{'scale':SCALE,'fields':obj,'integer_fields':sorted(INTPATHS),'registers':sorted(NUM)})
# Static conversion works exclusively on persistent scores.
fn('api/static','execute unless entity @s[type=minecraft:marker,tag=vr.root] run return 0','data modify entity @s data.state set value "static"',[f'scoreboard players set @s {obj[p]} 0' for p in bodyfields if p=='inv_mass' or p.startswith(('J.','v.','w.'))],'return 1')
