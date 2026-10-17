# Optional adapter. Install compatible initialized math3.2 + math3.2_lalib first.
# Input vr:work a.q floats -> output a.R, row-major.
# This is not installed into the standalone pack automatically.
execute store result score quat_x int run data get storage vr:work a.q.x 10000
execute store result score quat_y int run data get storage vr:work a.q.y 10000
execute store result score quat_z int run data get storage vr:work a.q.z 10000
execute store result score quat_w int run data get storage vr:work a.q.w 10000
function math:quat/_touvw
execute store result storage vr:work a.R.r00 float 0.0001 run scoreboard players get ivec_x int
execute store result storage vr:work a.R.r10 float 0.0001 run scoreboard players get ivec_y int
execute store result storage vr:work a.R.r20 float 0.0001 run scoreboard players get ivec_z int
execute store result storage vr:work a.R.r01 float 0.0001 run scoreboard players get jvec_x int
execute store result storage vr:work a.R.r11 float 0.0001 run scoreboard players get jvec_y int
execute store result storage vr:work a.R.r21 float 0.0001 run scoreboard players get jvec_z int
execute store result storage vr:work a.R.r02 float 0.0001 run scoreboard players get kvec_x int
execute store result storage vr:work a.R.r12 float 0.0001 run scoreboard players get kvec_y int
execute store result storage vr:work a.R.r22 float 0.0001 run scoreboard players get kvec_z int
