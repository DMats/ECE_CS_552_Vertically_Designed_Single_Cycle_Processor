# WISC.S14 Test Bench
# Author: David Mateo

# ASSUMES THAT LLB, SUB, BEQ, HLT, and LHB works
ADDTest:		LLB R1, 0x22		# Setup ADD variable 1
				LLB R2, 0x33		# Setup ADD variable 2
				ADD R3, R2, R1		# Calculate ADD result
				LLB R4, 0x55		# Setup desired ADD result
				SUB R0, R3, R4		# Compare ADD result to desired ADD result
				B eq, Pass			# Test Pass if two results equal


# ASSUMES THAT LLB, SUB, BEQ, HLT, and SSL works
LHBTest:		LLB R1, 0x77		
				SLL R1, R1, 16		# Shift 0x77 up to the high byte
				LHB R2, 0x77		# Directly load 0x77 into high byte
				SUB R0, R2, R1		# Compare
				B eq, Pass 			# Test pass if two results equal

# ASSUMES THAT LLB, SUB, BEQ, HLT, and SRA works
ANDTest:	
ANDZeroTest:	LLB R1, 0x0D		# Setup AND variable 1  4'b1101
				LLB R2, 0x0E		# Setup AND variable 2  4'b1110
				AND R3, R2, R1		# Calculate AND result
				LLB R4, 0x0C		# Setup desired AND result  4'b1100
				SUB R0, R3, R4		# Compare AND result to desired AND result
				B eq, Pass 			# Test Pass if two results equal

Fail:			LLB R1, 0xFF		# Load R1 with 0xFFFF if test failure
				HLT					# Halt program

Pass:			LLB R1, 0xAA		# Load R1 with 0xAAAA if test passed
				LHB R1, 0xAA
				HLT 				# Halt Program