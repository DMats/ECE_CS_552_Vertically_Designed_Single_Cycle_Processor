# Self-Checking Assembly
# Testing: SLL, SRL, SRA
# Author: R. Scott Carson
# Partner: David Mateo


TEST_BEGIN:		LLB R15, 0xFF		#r15 <= 0xFFFF - Used to check pass/fail for SLL
				LLB R14, 0xFF		#r14 <= 0xFFFF - Used to check pass/fail for SRL
				LLB R13, 0xFF		#r13 <= 0xFFFF - Used to check pass/fail for SRA
				LLB R12, 0xFF		#r12 <= 0xFFFF - Used to check pass/fail for ADDZ

				# Testing SLL
SLL_TEST:		LLB R1, 0x12		#r1 <= 0x0012
				LLB R2, 0x00		#r2 <= 0x0000
				LHB R2, 0x12		#r2 <= 0x1200
				SLL R1, R1, 0x8		#r1 <= r1 << 0x8
				SUB R3, R2, R1		#r3 <= r2 - r1
				B neq, SLL_FAIL
				B uncond, SRL_TEST	

SLL_FAIL:		LLB R15, 0x00		#r15 <= 0x0000

				# Testing SRL
SRL_TEST:		LLB R1, 0x00
				LHB R1, 0x12
				LHB R2, 0x00
				LLB R2, 0x12
				SRL R1, R1, 0x8
				SUB R3, R2, R1
				B neq, SRL_FAIL
				B uncond, SRA_TEST
				
SRL_FAIL:		LLB R14, 0x00
			
				# Testing SRA
SRA_TEST:		LLB R1, 0x00
				LHB R1, 0x80
				LLB R2, 0x80
				LHB R2, 0xFF
				SRA R1, R1, 0x8
				SUB R3, R2, R1
				B neq, SRA_FAIL
				B uncond, ADDZ_TEST
				
SRA_FAIL:		LLB R13, 0x00

				# Testing ADDZ instruction
ADDZ_TEST:		LLB R1, 0x0E
				LLB R2, 0x00
				ADDZ R3, R2, R1
				SUB R1, R1, R3
				B neq, ADDZ_FAIL
				B uncond, END_TEST

ADDZ_FAIL:		LLB R12, 0x00
				
END_TEST:		HLT