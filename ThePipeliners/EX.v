// Author:  David Mateo
// Execution Stage
// CS/ECE 552, Spring 2014
module EX(
	// Output
	dst, 
	N, 
	Z, 
	V, 
	br_pc, 
	br_ctrl, 
	sdata,
	// Input
	clk, 
	rst_n,
	pc, 
	func, 
	shamt, 
	src1sel, 
	p0, 
	imm8, 
	p1, 
	instr,
	forwardA,
	forwardB,
	alu_result_MEM_WB,
	wb_data_WB,
	prev_br_ctrl
	);

output wire [15:0] dst, sdata;
output wire N, Z, V;
output wire [15:0] br_pc;
output wire br_ctrl;

input wire clk, rst_n;
input wire [15:0] p0, p1, instr, pc, alu_result_MEM_WB, wb_data_WB;
input wire [7:0] imm8;
input wire [3:0] shamt;
input wire [2:0] func;
input wire src1sel, prev_br_ctrl;
input wire [1:0] forwardA, forwardB;

wire [15:0] src1_lcl;
wire [15:0] muxA, muxB;

// Instantiate src_mux
src_mux source_mux(
	// Output
	.src1(src1_lcl), 
	// Input
	.p1(muxB), 
	.imm8(imm8), 
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
	.src0(muxA),
	.shamt(shamt),
	.prev_br_ctrl(prev_br_ctrl),
	.clk(clk),
	.rst_n(rst_n)
	);

br_pc_calc BPC(
	// Input
	.instr(instr),
	.pc(pc), 
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

// Forwarding Muxes
assign muxA = 	(forwardA == 2'b10) ? 	alu_result_MEM_WB	:
				(forwardA == 2'b01) ? 	wb_data_WB 			:
				/*forwardA == 2'b00*/	p0;

assign muxB = 	(forwardB == 2'b10) ?	alu_result_MEM_WB	:
				(forwardB == 2'b01) ?	wb_data_WB 			:
				/*forwardB == 2'b00*/	p1;

//TODO:  WHAT IF FORWARDA/B == 2'b11  WHAT THEN???  IDK.  
// Figured it out.  2'b01 will only ever be set if 2'b10 is not set.
// They are mutually exclusive.

endmodule