		llb R1, 0 		
		lhb R1, 0x80 	# R1 <= 0x8000
		llb R9, 0
		lhb R9, 0x90	# R9 <= 0x9000
		llb R2, 0xEF	
		lhb R2, 0xBE	# R2 <= 0xBEEF
		llb R10, 0xAD	
		lhb R10, 0xDE	# R10 <= 0xDEAD
		
		sw R2, R1, 0 	# mem[8000] <= 0xBEEF
		sw R2, R1, 1 	# mem[8001] <= 0xBEEF
		lw R4, R1, 1 	# R4 <= mem[8001] <= 0xBEEF

		sw R10, R9, 0	#mem[9000] <= 0xDEAD
		sw R10, R9, 1	#mem[9001] <= 0xDEAD
		lw R6, R9, 1	# R6 <= mem[9001] <= 0xDEAD
		//sw R2, R1, 2	
		//sw R2, R1, 3
		//sw R2, R1, 4
		//sw R2, R1, 5
		lw R3, R1, 0 	# R3 <= mem[8000] <= 0xBEEF
		//lw R4, R1, 1 	# R4 <= mem[8001] <= 0xBEEF

		//lw R5, R9, 0	# R5 <= mem[9000] <= 0xDEAD
		//lw R6, R9, 1	# R6 <= mem[9001] <= 0xDEAD
		//lw R7, R1, 4
		//lw R8, R1, 5
		llb R0, 0
		llb R0, 0
		llb R14, 2
		llb R13, 3
		hlt