// Author:  David Mateo
// Execution Stage
// CS/ECE 552, Spring 2014
module EX(dst, N, Z, V, br_pc, br_ctrl, clk, rst_n, func, shamt, src1sel, p0, imm8, p1, instr);

output wire [15:0] dst;
output wire N, Z, V;
output wire [15:0] br_pc;
output wire br_ctrl;

input wire clk, rst_n;
input wire [15:0] p0, p1, instr;
input wire [7:0] imm8;
input wire [3:0] shamt;
input wire [2:0] func;
input wire src1sel;

wire [15:0] src1_lcl;

// Instantiate src_mux
src_mux source_mux(
	// Output
	.p1(p1), 
	// Input
	.imm8(imm8), 
	.src1(src1_lcl), 
	.src1sel(src1sel)
	);

// Instantiate ALU
ALU arithmetic_logic_unit(
	// Output
	.dst(dst),
	.N(N),
	.Z(Z),
	.V(V),
	// Input
	.ops(func),
	.src1(src1_lcl),
	.src0(p0),
	.shamt(shamt),
	.clk(clk),
	.rst_n(rst_n)
	);

br_pc_calc BPC(
	// Input
	.instr(instr), 
	// Output
	.br_pc(br_pc)
	);

br_ctrl BC(
	// Input
	.opcode(instr[15:12]),
	.br_cond(instr[11:9]),
	.N(N),
	.Z(Z),
	.V(V),
	// Output
	.br_ctrl(br_ctrl)
	);

assign sdata = p1;

endmodule