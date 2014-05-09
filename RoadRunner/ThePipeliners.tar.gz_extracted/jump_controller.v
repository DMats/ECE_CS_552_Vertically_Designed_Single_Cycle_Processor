// Author R. Scott Carson

module jump_controller(
	// Inputs
	MEM_dst, EX_dst, WB_dst, JR, MEM_we, EX_we, MEM_mem_re, WB_rf_we,
	// Outputs
	JR_MEM_LDATA_FORWARD, JR_MEM_FORWARD, JR_EX_FORWARD, JR_ID, JR_WB_FORWARD);
	
	// inputs
	input wire [3:0] MEM_dst, EX_dst, WB_dst, JR;
	input wire MEM_we, EX_we, MEM_mem_re, WB_rf_we;
	
	//outputs	
	output wire JR_MEM_LDATA_FORWARD, JR_MEM_FORWARD, JR_EX_FORWARD, JR_WB_FORWARD, JR_ID;
	
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

	assign JR_WB_FORWARD = 	((JR == WB_dst) 	&&
							((JR != EX_dst) 	&&
							(JR != MEM_dst))	&&
							(WB_rf_we))			?	1'b1:
													1'b0;
													
	assign JR_ID = 	((~JR_MEM_FORWARD) 		&& 
					(~JR_EX_FORWARD) 		&&
					(~JR_MEM_LDATA_FORWARD)	&&
					(~JR_WB_FORWARD))		? 1'b1 : 1'b0;
																
	
endmodule