module ID_EX_FF(
	// Output
	p0_EX, p1_EX, shamt_EX, func_EX, imm8_EX, we_mem_EX, re_mem_EX,
	wb_sel_EX, dst_addr_EX, src1sel_EX, we_rf_EX, instr_EX, pc_EX, hlt_EX,
	j_ctrl_EX, p0_addr_EX, p1_addr_EX,
	// Input
	p0_ID, p1_ID, shamt_ID, func_ID, imm8_ID, we_mem_ID, re_mem_ID, 
	wb_sel_ID, dst_addr_ID, src1sel_ID, we_rf_ID, instr_ID, pc_ID, hlt_ID,
	j_ctrl_ID, p0_addr_ID, p1_addr_ID, clk, rst_n, stall, flush);
	
	// Inputs
	input wire [15:0] p0_ID, p1_ID, instr_ID, pc_ID;
	input wire [7:0] imm8_ID;
	input wire [3:0] shamt_ID, dst_addr_ID, p0_addr_ID, p1_addr_ID;
	input wire [2:0] func_ID;
	input wire we_mem_ID, re_mem_ID, wb_sel_ID, src1sel_ID, clk, rst_n, stall,
		we_rf_ID, hlt_ID, j_ctrl_ID, flush;
	
	// Outputs
	output reg [15:0] p0_EX, p1_EX, instr_EX, pc_EX;
	output reg [7:0] imm8_EX;
	output reg [3:0] shamt_EX, dst_addr_EX, p0_addr_EX, p1_addr_EX;
	output reg [2:0] func_EX;
	output reg we_mem_EX, re_mem_EX, wb_sel_EX, src1sel_EX, we_rf_EX, hlt_EX,
		j_ctrl_EX;
	
	// Local Wires
	wire [15:0] next_p0, next_p1, next_instr, next_pc;
	wire [7:0] next_imm8;
	wire [3:0] next_shamt, next_dst_addr, next_p0_addr, next_p1_addr;
	wire [2:0] next_func;
	wire next_we_mem, next_re_mem, next_wb_sel, next_src1sel, next_we_rf, next_hlt,
		next_j_ctrl;
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			p0_EX <= 16'h0000;
			p1_EX <= 16'h0000;
			p0_addr_EX <= 4'h0;
			p1_addr_EX <= 4'h0;
			imm8_EX <= 8'h00;
			shamt_EX <= 4'h0;
			func_EX <= 3'b000;
			we_rf_EX <= 1'b0;
			we_mem_EX <= 1'b0;
			re_mem_EX <= 1'b0;
			wb_sel_EX <= 1'b0;
			dst_addr_EX <= 4'h0;
			src1sel_EX <= 1'b0;
			instr_EX <= 16'hB000;
			pc_EX <= 16'h0000;
			hlt_EX <= 1'b0;
			j_ctrl_EX <= 1'b0;
		end
		else begin
			p0_EX <= next_p0;
			p1_EX <= next_p1;
			p0_addr_EX <= next_p0_addr;
			p1_addr_EX <= next_p1_addr;
			imm8_EX <= next_imm8;
			shamt_EX <= next_shamt;
			func_EX <= next_func;
			we_rf_EX <= next_we_rf;
			we_mem_EX <= next_we_mem;
			re_mem_EX <= next_re_mem;
			wb_sel_EX <= next_wb_sel;
			dst_addr_EX <= next_dst_addr;
			src1sel_EX <= next_src1sel;
			instr_EX <= next_instr;
			pc_EX <= next_pc;
			hlt_EX <= next_hlt;
			j_ctrl_EX <= next_j_ctrl;
		end
	end
	
	assign next_p0 = 		(flush) ? 	16'h0000 	:
							(stall) ? 	p0_EX 		: 
										p0_ID 		;

	assign next_p1 = 		(flush) ? 	16'h0000	:
							(stall) ? 	p1_EX 		: 
										p1_ID 		;

	assign next_p0_addr = 	(flush) ? 	4'h0 		:
							(stall) ? 	p0_addr_EX 	: 
										p0_addr_ID 	;

	assign next_p1_addr = 	(flush) ? 	4'h0 	 	:
							(stall) ? 	p1_addr_EX 	:
										p1_addr_ID	;

	assign next_imm8 = 		(flush) ? 	8'h00 		:
							(stall) ? 	imm8_EX 	: 
										imm8_ID		;

	assign next_shamt = 	(flush) ? 	4'h0 		:
							(stall) ? 	shamt_EX 	: 
										shamt_ID	;

	assign next_func = 		(flush) ? 	4'h0 		:
							(stall) ? 	func_EX 	: 
										func_ID		;

	assign next_we_rf = 	(flush) ? 	1'b0 		:
							(stall) ? 	we_rf_EX 	: 
										we_rf_ID	;

	assign next_we_mem = 	(flush) ? 	1'b0 		:
							(stall) ? 	we_mem_EX 	: 
										we_mem_ID	;

	assign next_re_mem = 	(flush) ? 	1'b0 		:
							(stall) ? 	re_mem_EX 	: 
										re_mem_ID	;

	assign next_wb_sel = 	(flush) ?	1'b0 		:
							(stall) ? 	wb_sel_EX 	: 
										wb_sel_ID	;

	assign next_dst_addr = 	(flush) ? 	4'b0 		:
							(stall) ? 	dst_addr_EX : 
										dst_addr_ID ;

	assign next_src1sel = 	(flush) ? 	1'b0 		:
							(stall) ? 	src1sel_EX 	: 
										src1sel_ID	;

	assign next_instr = 	(flush) ? 	16'hB000 	:
							(stall) ? 	instr_EX 	: 
										instr_ID	;

	assign next_pc = 		(flush) ? 	16'h0000 	:
							(stall) ? 	pc_EX 		: 
										pc_ID		;

	assign next_hlt = 		(flush) ? 	1'b0 		:
							(stall) ? 	hlt_EX 		: 
										hlt_ID		;

	assign next_j_ctrl = 	(flush) ? 	1'b0 		:
							(stall) ? 	j_ctrl_EX 	: 
										j_ctrl_ID	;
	
endmodule
