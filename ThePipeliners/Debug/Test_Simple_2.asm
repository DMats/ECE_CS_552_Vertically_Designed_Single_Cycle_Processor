// Simple Test 2
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// without introducing any hazards.

//llb R0, 0xFF 		// R0 has 0x0000
llb R1, 0x06
llb R2, 0x22
sub R2, R2, R2
b eq, PASS

CONTINUE:
llb R3, 0x33
llb R4, 0x44
llb R5, 0x55

llb R6, 0x66
llb R7, 0x77
llb R8, 0x88
llb R9, 0x99
llb R10, 0xAA
llb R11, 0xBB
llb R12, 0xCC
llb R13, 0xDD
llb R14, 0xEE
llb R15, 0xFF
hlt

PASS:
llb R15, 0x00
add R2, R1, R1 			/// OHHHH SHITTTT.
llb R2, 0x04
jr R2

hlt
