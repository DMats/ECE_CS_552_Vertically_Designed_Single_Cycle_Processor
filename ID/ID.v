// Author:  David Mateo, R. Scott Carson
// Instruction Decode Stage
// This module is the top level module representing the ID stage.
module ID(
	// Output
	p0, p1, shamt, func, src1sel, hlt, imm8, br_ctrl, new_pc,
	// Input
	instr, pc, clk, rst_n, N, Z, V, dst);
	
	// Inputs //
	input [15:0] instr, dst, pc;
	input clk, rst_n, N, Z, V;
	
	// Outputs //
 	output [15:0] p0, p1, new_pc;
	output [7:0] imm8;
	output [3:0] shamt;
	output [2:0] func;
	output hlt, src1sel, br_ctrl;
	
	// Local Wires //
	wire [3:0] p0_addr, p1_addr, dst_addr;
	wire re0, re1, we, hlt_lcl;
	
	I_DECODE inst_decoder(	//Inputs
							.instr(instr),
							.N(N),
							.Z(Z),
							.V(V),
							.PC(pc),
							// Outputs
							.new_pc(new_pc),
							.br_ctrl(br_ctrl),
							.p0_addr(p0_addr),
							.re0(re0),
							.p1_addr(p1_addr),
							.re1(re1),
							.dst_addr(dst_addr),
							.we(we),
							.hlt(hlt_lcl),
							.src1sel(src1sel),
							.shamt(shamt),
							.func(func)
						);
						
	rf regF(
				.p0(p0), 
				.p1(p1), 
				.clk(clk), 
				.p0_addr(p0_addr), 
				.p1_addr(p1_addr), 
				.re0(re0), .re1(re1), 
				.dst_addr(dst_addr), 
				.dst(dst), 
				.we(we), 
				.hlt(hlt_lcl)
			);
			
	assign hlt = hlt_lcl;
							
endmodule
