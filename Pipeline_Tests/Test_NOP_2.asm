// NOP Test 2
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// without introducing any hazards.

// This particular test is modeled off of the RAW_Test_2

		// Reset Success/Failure Register
		llb R10, 0x00 		// R10 has 0x0000

		// Setup inputs
		llb R1, 0x11		// R1 has 0x0011
		llb R2, 0x22		// R2 has 0x0022

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0  	// NOP

		sw  R1, R1, 0		// Store 0x0011 to address 0x0011
		sw  R2, R2, 0  		// Store 0x0022 to address 0x0022

		ADD R0, R0, R0   	// NOP
		ADD R0, R0, R0 		// NOP

		// Perform load and then add
		lw  R3, R1, 0		// load 0x0011 to R3
		lw  R4, R2, 0		// load 0x0022 to R4

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0 		// NOP

		add R5, R4, R3		// Result should be 0x0033 

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0 		// NOP

		// Setup output comparison
		llb R6, 0x33 		// R6 has 0x0033

		// Perform output comparison
		sub R7, R6, R5
		b eq, Pass

		// Failure
Fail:	llb R10, 0xFF		// R10 has 0xFFFF (failure)
		hlt

		// Success
Pass:	llb R10, 0xAA 		
		lhb R10, 0xAA 		// R10 has 0xAAAA (success)
		hlt