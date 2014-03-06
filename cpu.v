`include "IF/IF.v"
`include "ID/ID.v"
`include "EX/EX.v"
`include "WB/WB.v"

module cpu(clk, rst_n);

input clk, rst_n;

// Instantiate IF
IF instruction_fetch(
	));

// Instantiate ID
ID instruction_decode(
	));

// Instantiate EX
EX execution(
	));

// Instantiate WB
WB write_back(
	));