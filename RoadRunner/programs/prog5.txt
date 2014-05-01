llb R1, 0x7F
llb R2, 0x01
Repeat: sub R1, R1, R2
b neq, Repeat
hlt
add R3, R0, R0