// Author:  David Mateo, R. Scott Carson
// Instruction Decode Stage
// This module is the top level module representing the ID stage.
module ID(
	// Output //
	p0, p1, shamt, func, src1sel, hlt, imm8, we_rf, we_mem, re_mem, wb_sel, dst_addr_new, j_pc,
	// Input
	instr, pc, clk, rst_n, dst, dst_addr, we_WB);
	
	// Inputs //
	input [15:0] instr, dst, dst_addr, pc;
	input clk, rst_n, N, Z, V;
	
	// Outputs //
 	output [15:0] p0, p1, j_pc;
	output [7:0] imm8;
	output [3:0] shamt;
	output [2:0] func;
	output hlt, src1sel;
	output we_mem, re_mem, wb_sel, j_ctrl;
	
	// Local Wires //
	wire [15:0] dst_lcl, jump_reg;
	wire [3:0] p0_addr, p1_addr, dst_addr;
	wire re0, re1, we, hlt_lcl;
	
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;
	
	I_DECODE inst_decoder(	//Inputs
							.instr(instr),
							.PC(pc),
							// Outputs
							.p0_addr(p0_addr),
							.re0(re0),
							.p1_addr(p1_addr),
							.re1(re1),
							.dst_addr(dst_addr_new),
							.we(we_rf),
							.hlt(hlt_lcl),
							.src1sel(src1sel),
							.shamt(shamt),
							.func(func),
							.imm8(imm8),
							.re_mem(re_mem),
							.we_mem(we_mem),
							.wb_sel(wb_sel),
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
			
	assign j_ctrl = ((instr[15:12] == jalOp)||(instr[15:12] == jrOp));
	assign j_pc = 	(instr[15:12] == jalOp) ? (pc+1+instr[11:0]):
					(instr[15:12] == jrOp) 	? p0:
											  16'hxxxx;	
	
	
	// TODO:  Put this mux in WB
	assign dst_lcl = (alt_pc_ctrl)	?	(pc+1)	:	dst;
	///
	assign jump_reg = p0; 	
	assign hlt = hlt_lcl;
							
endmodule
