"""Exercise emitted provider math, including diagonal velocity and restitution."""
import json
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PACK = ROOT / 'pack'
F = PACK / 'data/vr/function'
P = PACK / 'data/vr/context_float_provider'
scores = {}
config = {'limits.max_speed': 100., 'materials.density_scale': 1.,
          'materials.min_density': .05, 'materials.max_density': 100.}

def evaluate(e):
    if isinstance(e, (float, int)):
        return e
    if isinstance(e, str):
        return evaluate(json.loads((P / (e.removeprefix('vr:') + '.json')).read_text()))
    kind = e['type'].removeprefix('minecraft:')
    if kind == 'score':
        return scores.get(e['target']['name'], 0)
    if kind == 'storage':
        return config[e['path']]
    if kind in ('from_int', 'round', 'abs', 'sqrt', 'floor'):
        value = evaluate(e['input'])
        return {'from_int': lambda x: x, 'round': round, 'abs': abs, 'sqrt': math.sqrt, 'floor': math.floor}[kind](value)
    if kind in ('sub', 'div'):
        a, b = evaluate(e['left']), evaluate(e['right'])
        return a - b if kind == 'sub' else a / b
    values = [evaluate(v) for v in e['inputs']]
    return {'add': sum, 'mul': math.prod, 'min': min, 'max': max,
            'length': lambda xs: math.sqrt(sum(x*x for x in xs))}[kind](values)

def expression(function, fragment):
    line = next(x for x in (F / (function + '.mcfunction')).read_text().splitlines() if fragment in x)
    return command_expression(line)

def command_expression(line):
    argument = line.split('compute default float ', 1)[1]
    if argument.startswith('{'):
        return json.loads(argument)
    parts = argument.split()
    return {'type': 'minecraft:mul', 'inputs': [parts[0], float(parts[1]) if len(parts) > 1 else 1.]}

speed = expression('body/check_limits', 'score #overspeed')
for velocity, excess in [((5, 0, 0), 0), ((3, 4, 0), 0), ((4, 4, 0), 1), ((-4, -4, 0), 1), ((0, 0, 5.0001), 1)]:
    scores.update({'#a.v.' + axis: round(v * 10000) for axis, v in zip('xyz', velocity)})
    assert (evaluate(speed) > 0) == bool(excess), velocity
density = expression('spawn/read_material', 'score #material.density')
for hardness, expected in [(0, .05), (.5, .5), (50, 50), (100000, 100)]:
    scores['#material.hardness'] = round(hardness * 10000)
    assert abs(evaluate(density) / 10000 - expected) < 1e-6
bounce = expression('contact/impulse', 'score #bounce')
for a, b, expected in [(1, .1, 1), (.1, .8, .8), (0, 0, 0)]:
    scores.update({'#a.e': round(a * 10000), '#b.e': round(b * 10000)})
    assert abs(evaluate(bounce) / 10000 - expected) < 1e-6
assert 'vr:body/check_limits' in (F / 'scheduler/count.mcfunction').read_text()
assert 'vr:body/check_limits' in (F / 'body/teleport.mcfunction').read_text()
assert 'double 2147483647' in (F / 'spawn/unbreakable.mcfunction').read_text()
for shape in ('cube', 'bar', 'ell', 'raft'):
    initialization = (F / f'shape/{shape}/init.mcfunction').read_text()
    assert 'scoreboard players set @s vr.mass ' in initialization
    assert 'scoreboard players set @s vr.im ' in initialization
    assert 'inv_mass:' not in initialization
dynamic = (F / 'state/dynamic.mcfunction').read_text()
assert dynamic.index('function vr:body/check_work_speed') < dynamic.index('score #speed vr.num')
assert 'tag=vr.display,scores={vr.id=$(id)}' in (F / 'api/remove_displays.mcfunction').read_text()

config.update({'limits.min_x': -30000000, 'limits.max_x': 30000000,
               'limits.min_y': -128, 'limits.max_y': 1024,
               'limits.min_z': -30000000, 'limits.max_z': 30000000})
def within_bounds(position, shift=0):
    entity = {}
    for axis, value in zip('xyz', position):
        origin = math.floor(value) + shift
        entity['vr.o'+axis] = origin
        entity['vr.p'+axis] = round((value-origin)*10000)
        entity['vr.v'+axis] = 0
    registers = {}
    def matches(value, interval):
        if '..' not in interval:
            return value == int(interval)
        low, high = interval.split('..')
        return (not low or value >= int(low)) and (not high or value <= int(high))
    for line in (F/'body/check_limits.mcfunction').read_text().splitlines():
        m = re.fullmatch(r'scoreboard players operation (\S+) vr.num = @s (\S+)', line)
        if m:
            scores[m[1]] = entity[m[2]]
        m = re.fullmatch(r'execute store result score #limit vr.tmp run data get storage vr:config (\S+) 1', line)
        if m:
            registers['#limit'] = config[m[1]]
        m = re.fullmatch(r'scoreboard players operation (\S+) vr.tmp = @s (\S+)', line)
        if m:
            registers[m[1]] = entity[m[2]]
        m = re.fullmatch(r'scoreboard players operation (\S+) vr.tmp ([+-])= (\S+) vr.tmp', line)
        if m:
            registers[m[1]] += registers[m[3]] * (1 if m[2] == '+' else -1)
        m = re.match(r'execute store result score (\S+) vr.tmp run compute default float', line)
        if m:
            registers[m[1]] = round(evaluate(command_expression(line)))
        if 'run return run function vr:body/discard' in line:
            conditions = re.findall(r'if score (\S+) vr.tmp matches (\S+)', line)
            if all(matches(registers[name], interval) for name, interval in conditions):
                return False
    return True

for point, expected in [((-30000000, -128, 30000000), True),
                        ((30000000, 1024, -30000000), True),
                        ((30000000.0001, 0, 0), False),
                        ((-30000000.0001, 0, 0), False),
                        ((29999999.9999, 0, 0), True),
                        ((0, -128.0001, 0), False),
                        ((0, 1024.0001, 0), False),
                        ((0, 0, -30000000.0001), False)]:
    assert within_bounds(point) == expected, point
    assert within_bounds(point, -2) == expected, point
    assert within_bounds(point, 2) == expected, point
print('PASS: emitted boundary commands, velocity norms, density clamps, restitution and lifecycle hooks')
