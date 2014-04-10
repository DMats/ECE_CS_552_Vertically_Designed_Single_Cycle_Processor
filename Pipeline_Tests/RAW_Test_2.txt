// Read After Write (RAW) Test 2
// Author: David Mateo
// This test checks to make sure that the pipelined processor can correctly
// handle a Read After Write hazard.

		// Reset Success/Failure Register
		llb R10, 0x00 		// R10 has 0x0000

		// Setup inputs
		llb R1, 0x11		// R1 has 0x0011
		llb R2, 0x22		// R2 has 0x0022
		sw  R1, R1, 0		// Store 0x0011 to address 0x0011
		sw  R2, R2, 0  		// Store 0x0022 to address 0x0022

		// Perform load and then add
		lw  R3, R1, 0		// load 0x0011 to R3
		lw  R4, R2, 0		// load 0x0022 to R4
		add R5, R4, R3		// Result should be 0x0033 

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


