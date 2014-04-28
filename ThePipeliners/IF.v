// Author:  David Mateo
// Instruction Fetch
// This module contains all modules used for Instruction Fetch 
module IF(instr, pc_plus_1, alt_pc, alt_pc_ctrl, clk, rst_n, hlt, stall);

output wire [15:0] instr, pc_plus_1;

input wire[15:0] alt_pc;
input wire clk, rst_n, hlt, alt_pc_ctrl, stall;

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
	.pc_plus_1(pc_plus_1),
	// Input
	.alt_pc(alt_pc),
	.alt_pc_ctrl(alt_pc_ctrl),
	.clk(clk), 
	.rst_n(rst_n), 
	.hlt(hlt),
	.stall(stall)
	);

endmodule
