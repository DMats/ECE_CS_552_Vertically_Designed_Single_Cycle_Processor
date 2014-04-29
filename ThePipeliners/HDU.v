// Hazard Detect Unit
// Author:  David Mateo
// This module is meant to contain all modules relating to hazard
// detection.
module HDU(clk, rst_n, instr, stall_PC, stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB);
	
	input clk, rst_n;
	input [15:0] instr;

	output stall_PC, stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB;
	
	wire stall_lcl;

	stall_logic SL(
		// Input
		.clk(clk), 
		.rst_n(rst_n), 
		.instr(instr), 
		// Output
		.stall(stall_lcl)
		);
		
		assign stall_PC = stall_lcl;
		assign stall_IF_ID = stall_lcl;
		assign stall_ID_EX = 1'b0;
		assign stall_EX_MEM = 1'b0;
		assign stall_MEM_WB = 1'b0;
	
endmodule
