module EX_MEM_FF(we_mem_MEM, re_mem_MEM, alu_result_MEM, wb_sel_MEM, bj_cond_MEM, 
	N_MEM, Z_MEM, V_MEM, pc_MEM, we_rf_MEM, we_mem_EX, re_mem_EX, alu_result_EX, wb_sel_EX, 
	N_EX, Z_EX, V_EX, bj_cond_EX, pc_EX, we_rf_EX, clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] alu_result_EX, sdata_EX, pc_EX;
	input wire [6:0] bj_cond_EX;
	input wire wb_sel_EX, we_mem_EX, re_mem_EX, N_EX, Z_EX, V_EX, clk, stall, 
		rst_n, we_rf_EX;
	
	// Outputs
	output reg [15:0] alu_result_MEM, sdata_MEM, pc_MEM;
	output reg [6:0] bj_cond_MEM;
	output reg we_rf_MEM, we_mem_MEM, re_mem_MEM, wb_sel_MEM, 
		N_MEM, Z_MEM, V_MEM;
	
	// Local wires
	wire [15:0] next_alu_result, next_sdata, next_pc;
	wire [6:0] next_bj_cond;
	wire next_we_rf, next_we_mem, next_re_mem, next_wb_sel, next_N, next_Z, 
		next_V;
	
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			alu_result_MEM <= 16'h0000;
			we_rf_MEM <= 1'b0;
			we_mem_MEM <= 1'b0;
			re_mem_MEM <= 1'b0;
			wb_sel_MEM <= 1'b0;
			sdata_MEM <= 16'h0000;
			bj_cond_MEM <= 7'h00;
			pc_MEM <= 16'h0000;
			N_MEM <= 1'b0;
			Z_MEM <= 1'b0;
			V_MEM <= 1'b0;
		end 
		else begin
			alu_result_MEM <= next_alu_result;
			we_rf_MEM <= next_we_rf;
			we_mem_MEM <= next_we_mem;
			re_mem_MEM <= next_re_mem;
			wb_sel_MEM <= next_wb_sel;
			sdata_MEM <= next_sdata;
			bj_cond_MEM <= next_bj_cond;
			pc_MEM <= next_pc;
			N_MEM <= next_N;
			Z_MEM <= next_Z;
			V_MEM <= next_V;
		end
	end 
	
	assign next_alu_result = (stall) ? alu_result_MEM : alu_result_EX;
	assign next_we_rf = (stall) ? we_rf_MEM : we_rf_EX;
	assign next_we_mem = (stall) ? we_mem_MEM : we_mem_EX;
	assign next_re_mem = (stall) ? re_mem_MEM : re_mem_EX;
	assign next_wb_sel = (stall) ? wb_sel_MEM : wb_sel_EX;
	assign next_sdata = (stall) ? sdata_MEM : sdata_EX;
	assign next_bj_cond = (stall) ? bj_cond_MEM : bj_cond_EX;
	assign next_pc = (stall) ? pc_MEM : pc_EX;
	assign next_N = (stall) ? N_MEM : N_EX;
	assign next_Z = (stall) ? Z_MEM : Z_EX;
	assign next_V = (stall) ? V_MEM : V_EX;
	 
endmodule