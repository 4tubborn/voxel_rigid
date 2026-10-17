execute if entity @s[tag=vr.impact_sound] run return 0
function vr:contact/velocity
execute store result score #impact_speed vr.tmp run compute default float vr:e1272 10000
execute store result score #audio_threshold vr.tmp run compute default float vr:e1273 10000
execute unless score #impact_speed vr.tmp > #audio_threshold vr.tmp run return 0
execute store result score #sound_frame.volume vr.num run compute default float {"type":"minecraft:round","input":{"type":"minecraft:mul","inputs":[10000.0,"vr:e1274"]}}
data remove storage vr:work sound_frame.sound
function #bs.block:get_sounds
execute if data storage bs:out block.sounds.hit run data modify storage vr:work sound_frame.sound set from storage bs:out block.sounds.hit
execute store result storage vr:work sound_frame.volume float 0.0001 run scoreboard players get #sound_frame.volume vr.num
execute if data storage vr:work sound_frame.sound run function vr:audio/play with storage vr:work sound_frame
data remove storage vr:work sound_frame.sound
data modify storage vr:work sound_frame.sound set from storage vr:work a.sounds.hit
execute store result storage vr:work sound_frame.volume float 0.0001 run scoreboard players get #sound_frame.volume vr.num
execute if data storage vr:work sound_frame.sound run function vr:audio/play with storage vr:work sound_frame
tag @s add vr.impact_sound
