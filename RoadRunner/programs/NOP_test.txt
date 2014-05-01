###########################################################################
# Tests that a LLB R0, 0x00 will not set flags, but a ADD R0, R0, R0 will #
###########################################################################
		LLB R1, 0x22		# R1 = 0x0022
		LLB R2, 0x11		# R2 = 0x0011
		SUB R0, R2, R1		# This should clear the z flag, and set N flag
		B	EQ, FAIL
		B	LT, ARND
		B UNCOND, FAIL
ARND:	LLB R0, 0x00		# This should not set the Z flag
		B 	EQ, FAIL
		B	UNCOND, PASS
		
FAIL:	LLB R1, 0xFF		# R1 will contain 0xFFFF (indicates failure)
		HLT		
		
PASS:	LLB R1, 0xAA		# R1 will contain 0xFFAA
		LHB R1, 0xAA		# R1 will contain 0xAAAA (indicated pass)
		HLT
		
