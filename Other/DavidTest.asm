# WISC.S14 Test Bench
# Author: David Mateo

# ASSUMES THAT LLB, SUB, BEQ, HLT works
ADDTest:		LLB R1, 0x22		# Setup ADD variable 1
				LLB R2, 0x33		# Setup ADD variable 2
				ADD R3, R2, R1		# Calculate ADD result
				LLB R4, 0x55		# Setup desired ADD result
				SUB R0, R3, R4		# Compare ADD result to desired ADD result
				B eq, ADDPass		# Test Pass if two results equal
ADDFail:		LLB R5, 0xFF 		# Load R5 (ADD Test Result) with fail code
				B LHBTest			# Branch to next test
ADDPass:		LLB R5, 0xAA   		# Load R5 (ADD Test Result) with pass code
				LHB R5, 0xAA

# ASSUMES THAT LLB, SUB, BEQ, HLT, and SLL works
LHBTest:		LLB R1, 0x77		
				SLL R1, R1, 16		# Shift 0x77 up to the high byte
				LHB R2, 0x77		# Directly load 0x77 into high byte
				SUB R0, R2, R1		# Compare
				B eq, LHBPass		# Test pass if two results equal
LHBFail:		LLB R6, 0xFF 		# Load R6 (LHB Test Result) with fail code
				B ANDTest			# Branch to next test
LHBPass:		LLB R6, 0xAA 		# Load R6 (LHB Test Result) with pass code
				LHB R6, 0xAA 		

# ASSUMES THAT LLB, SUB, BEQ, HLT works
ANDTest:		LLB R1, 0x05		# Setup AND variable 1  4'b0101
				LLB R2, 0x06		# Setup AND variable 2  4'b0110
				AND R3, R2, R1		# Calculate AND result
				LLB R4, 0x04		# Setup desired AND result  4'b0100
				SUB R0, R3, R4		# Compare AND result to desired AND result
				B eq, ANDPass 			# Test Pass if two results equal
ANDFail: 		LLB R7, 0xFF 		# Load R7 (AND Test Result) with fail code
				B NORTest			# Branch to next test
ANDPass:		LLB R7, 0xAA 		# Load R7 (AND Test Result) with pass code
				LHB R7, 0xAA

# ASSUMES THAT LLB, SUB, BEQ, HLT work
NORTest: 		LLB R1, 0x05		# Setup NOR variable 1 4'b0101
				LLB R2, 0x06		# Setup NOR variable 2 4'b0110
				NOR R3, R2, R1		# Calculate NOR result
				LLB R4, 0x08		# Setup desired NOR result 4'b1000
				SUB R0, R3, R4		# Compare NOR result to desired NOR result
				B eq, NORPass		# Test Pass if two results equal
NORFail:		LLB R8, 0xFF		# Load R8 (NOR Test Result) with fail code
				HLT					# Halt program
NORPass:		LLB R8, 0xAA		# Load R8 (NOR Test Result) with pass code
				LHB R8, 0xAA
				HLT 				# Halt Program