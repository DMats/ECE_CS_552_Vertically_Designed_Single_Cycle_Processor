# Control Hazard Test 1
# Author: R Scott Carson
# This test ensures the processor can correctly handle a branch that 
# is predicted as not taken but is actually taken.

		# Reset Success/Failure Register
		llb R10, 0x00 		# R10 has 0x0000

		# Setup inputs
		llb R1, 0x11		# R1 has 0x0011
		llb R2, 0x11		# R2 has 0x0011

		# Perform subtraction using the registers that were just written to.
		sub R3, R1, R2		# R3 has 0x0000

		# Perform branch
		b eq, Pass1			

		# Failure
Fail1:	llb R10, 0xFF		# R10 has 0xFFFF (failure)
		hlt

		# Success
Pass1:	llb R10, 0xAA 		
		lhb R10, 0xAA 		# R10 has 0xAAAA (success)
		hlt