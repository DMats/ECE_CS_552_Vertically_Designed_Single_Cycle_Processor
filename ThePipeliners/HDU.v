// Hazard Detect Unit
// Author:  David Mateo
// This module is meant to contain all modules relating to hazard
// detection.
module HDU(clk, rst_n, instr, stall_PC, stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB, i_rdy, d_rdy);
	
	input clk, rst_n, i_rdy, d_rdy;
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
		
		assign stall_PC = stall_lcl | (~i_rdy) | (~d_rdy);
		assign stall_IF_ID = stall_lcl|(~i_rdy) | (~d_rdy);
		assign stall_ID_EX = (~i_rdy) | (~d_rdy);
		assign stall_EX_MEM = (~i_rdy) | (~d_rdy);
		assign stall_MEM_WB = (~i_rdy) | (~d_rdy);
	
endmodule
