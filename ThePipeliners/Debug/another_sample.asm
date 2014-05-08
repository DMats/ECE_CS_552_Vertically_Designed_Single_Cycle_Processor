		llb R1, 0 		
		lhb R1, 128 	# R1 <= 0x8000
		llb R2, 0xEF	
		lhb R2, 0xBE	# R2 <= 0xBEEF
		sw R2, R1, 0 	# mem[8000] <= 0xBEEF
		llb R0, 0 		# NOP
		llb R0, 0 		# NOP
		sw R2, R1, 1 	# mem[8001] <= 0xBEEF
		llb R0, 0 		# NOP
		llb R0, 0 		# NOP
		//sw R2, R1, 2	
		//sw R2, R1, 3
		//sw R2, R1, 4
		//sw R2, R1, 5
		lw R3, R1, 0 	# R3 <= mem[8000] <= 0xBEEF
		llb R0, 0 		# NOP
		llb R0, 0 		# NOP
		lw R4, R1, 1 	# R4 <= mem[8001] <= 0xBEEF
		//lw R5, R1, 2
		//lw R6, R1, 3
		//lw R7, R1, 4
		//lw R8, R1, 5
		hlt
		