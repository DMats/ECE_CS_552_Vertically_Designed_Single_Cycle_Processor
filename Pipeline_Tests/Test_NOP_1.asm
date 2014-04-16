// NOP Test 1
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// without introducing any hazards.

// This particular test is modeled off of the RAW_Test_1

		// Reset Success/Failure Register
		llb R10, 0x00 		// R10 has 0x0000

		// Setup inputs
		llb R1, 0x11		// R1 has 0x0011
		llb R2, 0x22		// R2 has 0x0022

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0 		// NOP

		// Perform addition using the registers that were just written to.
		add R3, R1, R2		// R3 has 0x0033

		// Setup output comparison
		llb R4, 0x33 		// R3 has 0x0033

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0 		// NOP

		// Perform output comparison
		sub R5, R4, R3
		b eq, Pass1

		// Failure
Fail1:	llb R10, 0xFF		// R10 has 0xFFFF (failure)
		hlt

		// Success
Pass1:	llb R10, 0xAA 		
		lhb R10, 0xAA 		// R10 has 0xAAAA (success)
		hlt