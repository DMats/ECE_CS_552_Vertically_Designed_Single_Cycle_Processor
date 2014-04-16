// Test NOP AND
// Author: David Mateo
// This test performs a set of commands meant to exersize the pipeline
// without introducing any hazards.
// This particular test does the AND instruction.
// It does not use the memory at all.

		// Reset Success/Failure Register
		LLB R10, 0x00 		// R10 has 0x0000

		// Setup inputs
		LLB R1, 0x0A		// R1 has 0x000A (1010)
		LLB R2, 0x06		// R2 has 0x0006 (0110)

		// Setup output comparison
		LLB R3, 0x02 		// R3 has 0x0002 (0010)

		ADD R0, R0, R0 		// NOP
		ADD R0, R0, R0  	// NOP

		// Perform AND
		AND R4, R1, R2		// R4 Should have 0x0002 (0010)

		ADD R0, R0, R0   	// NOP
		ADD R0, R0, R0 		// NOP

		// Perform output comparison
		SUB R5, R4, R3
		HLT					// Comment this line out when branching is working.
		B eq, Pass

		// Failure
Fail:	LLB R10, 0xFF		// R10 has 0xFFFF (failure)
		HLT

		// Success
Pass:	LLB R10, 0xAA 		
		LHB R10, 0xAA 		// R10 has 0xAAAA (success)
		HLT