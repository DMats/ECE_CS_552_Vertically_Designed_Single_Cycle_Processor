// Author:  David Mateo
// Instruction Fetch Test Bench
// This module contains code to functionally test the Instruction Fetch stage.
module IF_tb();

output wire [15:0] instr_mon;
input reg clk, rst_n, hlt;

// Setup initial state of signals
initial begin
	clk = 1'b0;
	rst_n = 1'b1;
	hlt = 1'b0;
end

// Generate Clock
always begin
	#5 clk <= ~clk;
end

endmodule