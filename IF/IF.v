// Author:  David Mateo
// Instruction Fetch
// This module contains all modules used for Instruction Fetch 
module IF(instr, pc, new_pc, br_ctrl, clk, rst_n, hlt);

output wire [15:0] instr, pc;

input wire[15:0] new_pc;
input wire clk, rst_n, hlt, br_ctrl;

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
	.new_pc(new_pc),
	.br_ctrl(br_ctrl),
	.clk(clk), 
	.rst_n(rst_n), 
	.hlt(hlt)
	);
	
assign pc = iaddr;

endmodule