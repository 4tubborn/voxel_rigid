#!/usr/bin/env python3
"""Validate score-to-macro numeric exports in the emitted pack (no Minecraft)."""
from pathlib import Path
import json,re
root=Path(__file__).resolve().parents[1]
f=root/'pack/data/vr/function'
# Installed archive has data/ at root; build output has pack/data/.
if not f.exists():f=root/'data/vr/function'
schema=json.loads((root/'src/scoreboard_schema.json').read_text())
registers=set(schema['registers'])
functions={p.relative_to(f).as_posix()[:-11]:p.read_text().splitlines() for p in f.rglob('*.mcfunction')}
fields={n:set(re.findall(r'\$\(([^)]+)\)','\n'.join(lines))) for n,lines in functions.items()}
checked=0
for name,lines in functions.items():
 for i,line in enumerate(lines):
  m=re.search(r'\bfunction vr:([a-z0-9_/]+) with storage vr:work (\S+)',line)
  if not m:continue
  target,frame=m.groups()
  required=sorted(frame+'.'+k for k in fields.get(target,set()) if frame+'.'+k in registers)
  if not required:continue
  immediate=lines[max(0,i-len(required)):i]
  for path in required:
   assert any(('store result storage vr:work '+path+' ') in x and ('scoreboard players get #'+path+' vr.num') in x for x in immediate), (name,target,path)
  checked+=1
assert checked>=9,checked
print(f'PASS: {checked} numeric macro invocations export authoritative scores')
