llb R1, 6				#R1 <= 0x0006
add R4, R1, R1 			#R4 <= 0x000C 					//Forwarding R1 from llb in EX_MEM
sub R1, R1, R1 			#R1 <= 0x0000 					//Forwarding R1 from llb in MEM_WB
add R2, R1, R4 			#R2 <= 0x000C 					//Forwarding R1 from sub in EX_MEM and R4 from addz in MEM_WB
addz R10, R0, R1  		#Nop but sets the Z flag		//Forwarding R1 from sub in MEM_WB
sw R1, R0, 1 			#mem[1] <= 0x0000 				//No forwarding needed
lw R2, R0, 1 			#R2 <= mem[1] == 0x0000 		//No forwarding needed
addz R14, R2, R0 		#Nop but load-use 1 cycle stall //Forwarding R2 from lw in MEM_WB; checks whether flag registers are disabled on ID_EX stall
sw R2, R1, 7 			#mem[7] <= 0x0000				//No forwarding needed
lw R3, R1, 7			#R3 <= mem[7] == 0x0000			//No forwarding needed
llb R5, 1				#R5 <= 0x0001
hlt