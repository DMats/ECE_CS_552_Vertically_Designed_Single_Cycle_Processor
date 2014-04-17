// Hazard Detect Unit
// Author:  David Mateo
// This module is meant to contain all modules relating to hazard
// detection.
module HDU(clk, rst_n, instr, stall);
	
	input clk, rst_n;
	input [15:0] instr;

	output stall;

	stall_logic SL(
		// Input
		.clk(clk), 
		.rst_n(rst_n), 
		.instr(instr), 
		// Output
		.stall(stall)
		);
	
endmodule