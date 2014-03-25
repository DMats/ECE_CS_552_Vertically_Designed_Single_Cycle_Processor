`include "IF/IF.v"
`include "ID/ID.v"
`include "EX/EX.v"

module cpu(hlt, clk, rst_n);

input clk, rst_n;
output hlt;


wire [15:0] instr_lcl, dst_lcl, src0_lcl, p1_lcl;
wire [3:0] shamt_lcl;
wire [2:0] func_lcl;
wire hlt_lcl, src1sel_lcl;
wire N_lcl, Z_lcl, V_lcl;

// Instantiate IF
IF instruction_fetch(	
	// Output
	.instr(instr_lcl),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.hlt(hlt_lcl)
	);

// Instantiate ID
ID instruction_decode(	
	// Output
	.p0(src0_lcl),
	.p1(p1_lcl),
	.shamt(shamt_lcl),
	.func(func_lcl),
	.src1sel(src1sel_lcl),
	.hlt(hlt_lcl),
	// Input
	.instr(instr_lcl),
	.clk(clk),
	.rst_n(rst_n),
	.N(N_lcl),
	.Z(Z_lcl),
	.V(V_lcl),
	.dst(dst_lcl)
	);


// Instantiate EX
EX execution(
	// Output
	.dst(dst_lcl),
	.N(N_lcl),
	.Z(Z_lcl),
	.V(V_lcl),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.func(func_lcl),
	.shamt(shamt_lcl),
	.src1sel(src1sel_lcl),
	.src0(src0_lcl),
	.imm8(instr_lcl[7:0]),
	.p1(p1_lcl)
	);

assign hlt = hlt_lcl;

endmodule