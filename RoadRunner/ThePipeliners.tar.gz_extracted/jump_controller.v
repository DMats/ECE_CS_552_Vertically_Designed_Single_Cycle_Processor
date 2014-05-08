// Author R. Scott Carson

module jump_controller(
	// Inputs
	MEM_dst, EX_dst, JR, MEM_we, EX_we, MEM_mem_re,
	// Outputs
	JR_MEM_LDATA_FORWARD, JR_MEM_FORWARD, JR_EX_FORWARD, JR_ID
	);
	
	// inputs
	input wire [3:0] MEM_dst, EX_dst, JR;
	input wire MEM_we, EX_we, MEM_mem_re;
	
	//outputs	
	output wire JR_MEM_LDATA_FORWARD, JR_MEM_FORWARD, JR_EX_FORWARD, JR_ID;
	
	assign JR_EX_FORWARD = 	((JR == EX_dst)		&&
							(EX_dst != 4'b0000)	&&
							(EX_we)) 			? 	1'b1: 
												 	1'b0;
												
	assign JR_MEM_FORWARD = ((JR == MEM_dst)	&&
							(JR != EX_dst)		&&
							(MEM_we)			&&
							(~MEM_mem_re))		? 	1'b1: 
													1'b0;

	assign JR_MEM_LDATA_FORWARD = 	((JR == MEM_dst) 	&&
									(JR != EX_dst)		&&
									(MEM_we)			&&
									(MEM_mem_re))		?	1'b1:
															1'b0;
													
	assign JR_ID = 	((~JR_MEM_FORWARD) && (~JR_EX_FORWARD)) ? 1'b1 : 1'b0;
																
	
endmodule