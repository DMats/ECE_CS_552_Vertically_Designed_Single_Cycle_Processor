// Forward Test
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// and introduce forwarding hazards.

// Initialize the Registers
//llb R0, 0xFF 		// R0 has 0x0000
llb R1, 0x11		// R1 has 0x0011
llb R2, 0x22
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

// Only one of the following tests should ever be uncommented at a time.

// EX_MEM_Rd == ID_EX_Rs Test
add R1, R2, R3 		// R1 should get 0x0055
add R4, R1, R2 		// R4 should get 0x0077
////

