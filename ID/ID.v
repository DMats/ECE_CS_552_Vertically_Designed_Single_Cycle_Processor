// Author:  David Mateo, R. Scott Carson
// Instruction Decode Stage
// This module is the top level module representing the ID stage.
module ID(
	// Output //
	p0, p1, shamt, func, src1sel, hlt, imm8, alt_pc_ctrl, alt_pc, we_mem, re_mem, wb_sel,
	// Input
	instr, pc, clk, rst_n, N, Z, V, dst);
	
	// Inputs //
	input [15:0] instr, dst, pc;
	input clk, rst_n, N, Z, V;
	
	// Outputs //
 	output [15:0] p0, p1, alt_pc;
	output [7:0] imm8;
	output [3:0] shamt;
	output [2:0] func;
	output hlt, src1sel, alt_pc_ctrl;
	output we_mem, re_mem, wb_sel;
	
	// Local Wires //
	wire [15:0] dst_lcl, jump_reg;
	wire [3:0] p0_addr, p1_addr, dst_addr;
	wire re0, re1, we, hlt_lcl;
	
	I_DECODE inst_decoder(	//Inputs
							.instr(instr),
							.N(N),
							.Z(Z),
							.V(V), 
							.PC(pc),
							.jump_reg(jump_reg),
							// Outputs
							.alt_pc(alt_pc),
							.alt_pc_ctrl(alt_pc_ctrl),
							.p0_addr(p0_addr),
							.re0(re0),
							.p1_addr(p1_addr),
							.re1(re1),
							.dst_addr(dst_addr),
							.we(we),
							.hlt(hlt_lcl),
							.src1sel(src1sel),
							.shamt(shamt),
							.func(func),
							.imm8(imm8),
							.re_mem(re_mem),
							.we_mem(we_mem),
							.wb_sel(wb_sel)
						);
						
	rf regF(
				.p0(p0), 
				.p1(p1), 
				.clk(clk), 
				.p0_addr(p0_addr), 
				.p1_addr(p1_addr), 
				.re0(re0), .re1(re1), 
				.dst_addr(dst_addr), 
				.dst(dst_lcl), 
				.we(we), 
				.hlt(hlt_lcl)
			);
	
	assign dst_lcl = (alt_pc_ctrl)	?	(pc+1)	:	dst;
	assign jump_reg = p0; 	
	assign hlt = hlt_lcl;
							
endmodule
