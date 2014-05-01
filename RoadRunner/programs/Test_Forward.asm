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

//// MEM destination == EX src0 Test
//add R1, R2, R3 		// R1 should get 0x0055
//add R4, R1, R2 		// R4 should get 0x0077

//// MEM destination == EX src1 Test
//add R1, R2, R5 		// R1 should get 0x0077
//add R4, R2, R1 		// R4 should get 0x0099

//// WB destination == EX src0 Test
//add R1, R2, R3 		// R1 should get 0x0055
//add R0, R0, R0 		// NOP
//add R4, R1, R2 		// R4 should get 0x0077

//// WB destination == EX src1 Test
//add R1, R2, R5 		// R1 should get 0x0077
//add R0, R0, R0    	// NOP
//add R4, R1, R2 		// R4 should get 0x0099

//// Dependency Cluster Fuck Test
//add R1, R1, R1 		// R1 should get 0x0022
//add R1, R1, R1 		// R1 should get 0x0044
//add R1, R1, R1 		// R1 should get 0x0088


//// GOD DAMN BRANCHING BUG Where the instruction after a Non Taken branch
//// becomes a 0000
sub R0, R1, R1 			// Set the zero flag
b neq, FAIL 				

PASS:  	llb R1, 0xAA     	// R1 should get 0x00AA
		lhb R1, 0xAA 		// R1 should get 0xAAAA
		hlt

FAIL:	llb R1, 0xFF 		// R1 should get 0xFFFF
		hlt

