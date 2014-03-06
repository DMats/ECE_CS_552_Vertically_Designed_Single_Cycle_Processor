// Author:  David Mateo
// Execution Stage
// CS/ECE 552, Spring 2014
module EX(dst, zr, func, shamt, src1sel, src0, imm8, p1);

output wire [15:0] dst;
output wire zr;

input wire [15:0] src0, p1;
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
	.src1sel(src1sel));

// Instantiate ALU
ALU arithmetic_logic_unit(
	// Output
	.dst(dst),
	.zr(zr),
	// Input
	.ops(func),
	.src1(src1_lcl),
	.src0(src0),
	//.ov(<not hooked up>),
	.shamt(shamt));

endmodule