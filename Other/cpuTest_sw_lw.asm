		LLB R1, 0x55
		LLB R2, 0x33
		ADD R3, R2, R1		#(should be 0x88)
		SW R3, R2, 0x03		#should store 0x88 to location 0x36
		LW R4, R2, 0x03		#should read 0x88 from 0x36
		SUB R0, R4, R3
		B EQ, PASS			#branch to PASS or fall through FAIL

FAIL:	LLB R1, 0xFF		#R1 will contain 0xFFFF (indicates failure)
		HLT

PASS:	LLB R1, 0xAA		#R1 will contain 0xFFAA
		LHB R1, 0xAA 		#R1 will contain 0xAAAA(indicates pass)
		HLT