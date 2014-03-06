`include "IF/IF.v"
`include "ID/ID.v"
`include "EX/EX.v"
`include "WB/WB.v"

module cpu(hlt, clk, rst_n);

input clk, rst_n;
output hlt;

wire [15:0] instr_lcl;
wire hlt_lcl;

// Instantiate IF
IF instruction_fetch(	.instr(instr_lcl),
						.clk(clk),
						.rst_n(rst_n),
						.hlt(hlt_lcl)
	);

// Instantiate ID
ID instruction_decode(
	));

// Instantiate EX
EX execution(
	));

// Instantiate WB
WB write_back(
	));