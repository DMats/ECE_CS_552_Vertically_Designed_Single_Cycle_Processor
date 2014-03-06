# Author R. Scott Carson
# Single Cycle, Non-Branching Processor Test Assembly


LLB R1, 0x00		# <= Expect 0x0000
LHB R2, 0x11		# <= Expect 0x0011
ADD R3, R3, R3		# <= Expect 0x6666
SUB R4, R4, R4		# <= Expect 0x0000
ADDZ R5, R5, R5		# <= Expect 0xAAAA
AND R6, R5, R3		# <= Expect 0x2222
NOR R7, R2, R3		# <= Expect 0x9988
SLL R8, R2, 0x8		# <= Expect 0x1100
SRL R9, R8, 0x6		# <= Expect 0x0044
SRA R10, R7, 0x4	# <= Expect 0xF998
LLB R11, 0xFE		# <= Expect 0xFFFE

HLT