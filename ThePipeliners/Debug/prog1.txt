llb R1, 6				#R1 <= 0x0006
sub R2, R1, R1 			#R2 <= 0x0000				//Forwarding R1 from llb in EX_MEM stage
sw R2, R1, 5			#mem[11] <= 0x0000			//Forwarding R1 from llb in MEM_WB stage
lw R3, R1, 5			#R3 <= mem[11] == 0x0000	//No forwarding needed
addz R15, R1, R3		#R15 <= 0x0006				//load-use 1 cycle stall - Forwarding R3 from lw in MEM_WB stage
hlt						#While addz is stalled in EX stage for ld to finish MEM, if hlt in ID stage, cannot insert bubble into ID_EX! Depends on the implementation - I insert a bubble into ID_EX on hlt in ID and watch it come out of WB to signal done while IF_ID is stalled with the hlt instruction.