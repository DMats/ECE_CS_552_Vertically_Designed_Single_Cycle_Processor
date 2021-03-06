// Author:  David Mateo, R. Scott Carson
// Instruction Decode Stage
// This module is the top level module representing the ID stage.
module ID(
	// Output //
	p0, 
	p1, 
	p0_addr,
	p1_addr,
	shamt, 
	func, 
	src1sel, 
	hlt, 
	imm8, 
	we_rf, 
	we_mem, 
	re_mem, 
	wb_sel, 
	dst_addr_new, 
	j_pc,
	j_ctrl,
	// Input
	instr, 
	pc, 
	clk, 
	rst_n, 
	dst_data_WB, 
	dst_addr_WB, 
	we_WB,
	hlt_WB,
	MEM_data,
	MEM_ldata,
	MEM_we,
	MEM_mem_re,
	MEM_dst,
	EX_data,
	EX_we,
	EX_dst
	);
	
	// Inputs //
	input [15:0] instr, pc, dst_data_WB, MEM_data, EX_data, MEM_ldata;
	input [3:0] dst_addr_WB, MEM_dst, EX_dst;
	input clk, rst_n, we_WB, hlt_WB, MEM_we, EX_we, MEM_mem_re;
	
	// Outputs //
 	output [15:0] p0, p1, j_pc;
	output [7:0] imm8;
	output [3:0] shamt, dst_addr_new, p0_addr, p1_addr;
	output [2:0] func;
	output hlt, src1sel;
	output re_mem, we_mem, wb_sel, j_ctrl, we_rf;

	
	// Local Wires //
	wire [15:0] JR_REG;
	wire re0, re1, JR_MEM_LDATA_FORWARD, JR_EX_FORWARD, JR_MEM_FORWARD, JR_ID;
	
	// Relevant Opcodes
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;
	
	I_DECODE inst_decoder(	//Inputs
							.instr(instr),
							// Outputs
							.p0_addr(p0_addr),
							.re0(re0),
							.p1_addr(p1_addr),
							.re1(re1),
							.dst_addr(dst_addr_new),
							.we_rf(we_rf),
							.hlt(hlt),
							.src1sel(src1sel),
							.shamt(shamt),
							.func(func),
							.imm8(imm8),
							.re_mem(re_mem),
							.we_mem(we_mem),
							.wb_sel(wb_sel)
						);

						
	rf regF(
				// Output
				.p0(p0), 
				.p1(p1), 
				// Input
				.clk(clk), 
				.p0_addr(p0_addr), 
				.p1_addr(p1_addr), 
				.re0(re0), 
				.re1(re1), 
				.dst_addr(dst_addr_WB), 
				.dst(dst_data_WB), 
				.we(we_WB), 
				.hlt(hlt_WB)
			);
			
	jump_controller j_controller(
		//inputs
		.MEM_dst(MEM_dst),
		.MEM_we(MEM_we),
		.EX_dst(EX_dst),
		.EX_we(EX_we),
		.JR(p0_addr),
		.MEM_mem_re(MEM_mem_re),
		.WB_rf_we(we_WB),
		.WB_dst(dst_addr_WB),
		//outputs
		.JR_WB_FORWARD(JR_WB_FORWARD),
		.JR_MEM_LDATA_FORWARD(JR_MEM_LDATA_FORWARD),
		.JR_MEM_FORWARD(JR_MEM_FORWARD),
		.JR_EX_FORWARD(JR_EX_FORWARD),
		.JR_ID(JR_ID)
		);
		
	// Jumps definitely cause flushing.	
	assign JR_REG = (JR_MEM_LDATA_FORWARD)		?	MEM_ldata:
					(JR_MEM_FORWARD)			?	MEM_data:
					(JR_EX_FORWARD)				?	EX_data:
					(JR_WB_FORWARD)				?	dst_data_WB:
					(JR_ID)						?	p0:
													16'hxxxx;
	
	assign j_ctrl = ((instr[15:12] == jalOp)||(instr[15:12] == jrOp));
	assign j_pc = 	(instr[15:12] == jalOp) ? (pc+{{4{instr[11]}}, instr[11:0]}):
					(instr[15:12] == jrOp) 	? JR_REG:
											  16'hxxxx;	

endmodule
