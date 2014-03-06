// Author:  David Mateo
// Execution Stage
// CS/ECE 552, Spring 2014
module EX(dst, zr, func, shamt, src1sel, src0, instr, p1);

output wire [15:0] dst;
output wire zr;

input wire [15:0] src0, p1;
input wire [7:0] imm8;

wire [15:0] src1_lcl;

// Instantiate src_mux
src_mux source_mux(
	.p1(p1), 
	.imm8(imm8), 
	.src1(src1_lcl), 
	.src1sel(src1sel));

// Instantiate ALU
ALU arithmetic_logic_unit(
	.ops(func)
	.src1(src1_lcl)
	.src0(src0)
	.dst(dst)
	//.ov(<not hooked up>)
	.zr(zr)
	.shamt(shamt));

endmodule