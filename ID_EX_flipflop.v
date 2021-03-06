module ID_EX_FF(
	// Output
	p0_EX, p1_EX, shamt_EX, func_EX, imm8_EX, we_mem_EX, re_mem_EX,
	wb_sel_EX, dst_addr_EX, src1sel_EX, we_rf_EX, instr_EX, pc_EX,
	// Input
	p0_ID, p1_ID, shamt_ID, func_ID, imm8_ID, we_mem_ID, re_mem_ID, 
	wb_sel_ID, dst_addr_ID, src1sel_ID, we_rf_ID, instr_ID, pc_ID,
	clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] p0_ID, p1_ID, instr_ID, pc_ID;
	input wire [7:0] imm8_ID;
	input wire [3:0] shamt_ID, dst_addr_ID;
	input wire [2:0] func_ID;
	input wire we_mem_ID, re_mem_ID, wb_sel_ID, src1sel_ID, clk, rst_n, stall,
		we_rf_ID;
	
	// Outputs
	output reg [15:0] p0_EX, p1_EX, instr_EX, pc_EX;
	output reg [7:0] imm8_EX;
	output reg [3:0] shamt_EX, dst_addr_EX;
	output reg [2:0] func_EX;
	output reg we_mem_EX, re_mem_EX, wb_sel_EX, src1sel_EX, we_rf_EX;
	
	// Local Wires
	wire [15:0] next_p0, next_p1, next_instr, next_pc;
	wire [7:0] next_imm8;
	wire [3:0] next_shamt, next_dst_addr;
	wire [2:0] next_func;
	wire next_we_mem, next_re_mem, next_wb_sel, next_src1sel, next_we_rf_EX;
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			p0_EX <= 16'h0000;
			p1_EX <= 16'h0000;
			imm8_EX <= 8'h00;
			shamt_EX <= 4'h0;
			func_EX <= 3'b000;
			we_rf_EX <= 1'b0;
			we_mem_EX <= 1'b0;
			re_mem_EX <= 1'b0;
			wb_sel_EX <= 1'b0;
			dst_addr_EX <= 4'h0;
			src1sel_EX <= 1'b0;
			instr_EX <= 16'h0000;
			pc_EX <= 16'h0000;
		end
		else begin
			p0_EX <= next_p0;
			p1_EX <= next_p1;
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
		end
	end
	
	assign next_p0 = (stall) ? p0_EX : p0_ID;
	assign next_p1 = (stall) ? p1_EX : p1_ID;
	assign next_imm8 = (stall) ? imm8_EX : imm8_ID;
	assign next_shamt = (stall) ? shamt_EX : shamt_ID;
	assign next_func = (stall) ? func_EX : func_ID;
	assign next_we_rf = (stall) ? we_rf_EX : we_rf_ID;
	assign next_we_mem = (stall) ? we_mem_EX : we_mem_ID;
	assign next_re_mem = (stall) ? re_mem_EX : re_mem_ID;
	assign next_wb_sel = (stall) ? wb_sel_EX : wb_sel_ID;
	assign next_dst_addr = (stall) ? dst_addr_EX : dst_addr_ID;
	assign next_src1sel = (stall) ? src1sel_EX : src1sel_ID;
	assign next_instr = (stall) ? instr_EX : instr_ID;
	assign next_pc = (stall) ? pc_EX : pc_ID;
	
endmodule