// Basic Test 1
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// without introducing any hazards.

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

// uncomment this line if doing the SRA Sign Extend Test.
//lhb R3, 0xff 		// Setup R3 with 0xff33

llb R9, 0x99
llb R10, 0xAA
llb R11, 0xBB
llb R12, 0xCC
llb R13, 0xDD
llb R14, 0xEE
llb R15, 0xFF

// Only one of the following tests should ever be uncommented at a time.

//add R1, R1, R1 		// ADD Test: R1 should get 0x0022

//sub R1, R4, R2 		// SUB Test: R1 should get 0x0022

//and R1, R6, R10 		// AND Test: R1 should get 0x0022	

//nor R2, R6, R10		// NOR Test: R2 should get 0x0011

//add R0, R0, R0        // Set 0 flag
//addz R1, R1, R1       // ADDZ Taken Test: R1 should get 0x0022

//add R0, R0, R1  		// UnSet 0 flag
//addz R2, R2, R2 		// ADDZ Not Taken Test: R2 should get 0x0022 and NOT 0x0044

//sll R1, R1, 4			// SLL Test: R1 should get 0x0110

//srl R1, R1, 4			// SRL Test: R1 should get 0x0001

//sra R1, R1, 4			// SRA Simple Test: R1 should get 0x0001

//lhb R1, 0x11 			// LBH Test:  R1 should get 0x1111

//sra R3, R3, 4			// SRA Sign Extend Test: R3 should get 0xfff3

//sw R1, R2, 0 			// Setup memory
//lw R10, R2, 0 		// SW/LW Test:  R10 should get 0x0011

  hlt

