execute in minecraft:overworld run tag @e[type=minecraft:marker,tag=vr.root] remove vr.round_done
execute in minecraft:the_nether run tag @e[type=minecraft:marker,tag=vr.root] remove vr.round_done
execute in minecraft:the_end run tag @e[type=minecraft:marker,tag=vr.root] remove vr.round_done
scoreboard players add #round vr.cfg 1
