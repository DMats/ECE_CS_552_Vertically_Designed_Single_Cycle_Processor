// Author:  David Mateo
// Instruction Fetch
// This module contains all modules used for Instruction Fetch 
module IF(instr, clk, rst_n, hlt);

output wire [15:0] instr;
input wire clk, rst_n, hlt;

wire [15:0] iaddr;

// Instantiate Instruction Memory
IM instr_mem(
	// Output
	.instr(instr),
	// Input
	.clk(clk), 
	.addr(iaddr), 
	.rd_en(1'b1));

// Instantiate Program Counter
PC program_counter(
	// Output
	.iaddr(iaddr), 
	// Input
	.clk(clk), 
	.rst_n(rst_n), 
	.hlt(hlt));

endmodule