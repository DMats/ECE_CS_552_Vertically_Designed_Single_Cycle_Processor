module EX_MEM_FF(
	// Output
	we_mem_MEM, re_mem_MEM, alu_result_MEM, wb_sel_MEM, dst_addr_MEM,
	we_rf_MEM, sdata_MEM, b_ctrl_MEM, pc_MEM, j_ctrl_MEM, hlt_MEM,
	// Input
	we_mem_EX, re_mem_EX, alu_result_EX, wb_sel_EX, dst_addr_EX,
	we_rf_EX, sdata_EX, b_ctrl_EX, pc_EX, j_ctrl_EX, hlt_EX,
	clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] alu_result_EX, sdata_EX, pc_EX;
	input wire [3:0] dst_addr_EX;
	input wire wb_sel_EX, we_mem_EX, re_mem_EX, clk, stall, 
		rst_n, we_rf_EX, b_ctrl_EX, j_ctrl_EX, hlt_EX;
	
	// Outputs
	output reg [15:0] alu_result_MEM, sdata_MEM, pc_MEM;
	output reg [3:0] dst_addr_MEM;
	output reg we_rf_MEM, we_mem_MEM, re_mem_MEM, wb_sel_MEM, 
		b_ctrl_MEM, j_ctrl_MEM, hlt_MEM;
	
	// Local wires
	wire [15:0] next_alu_result, next_sdata, next_pc;
	wire [3:0] next_dst_addr;
	wire next_we_rf, next_we_mem, next_re_mem, next_wb_sel, next_b_ctrl, next_j_ctrl,
		next_hlt;
	
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			alu_result_MEM <= 16'h0000;
			we_rf_MEM <= 1'b0;
			we_mem_MEM <= 1'b0;
			re_mem_MEM <= 1'b0;
			wb_sel_MEM <= 1'b0;
			dst_addr_MEM <= 4'b0000;
			sdata_MEM <= 16'h0000;
			b_ctrl_MEM <= 1'b0;
			pc_MEM <= 16'h0000;
			j_ctrl_MEM <= 1'b0;
			hlt_MEM <= 1'b0;
		end 
		else begin
			alu_result_MEM <= next_alu_result;
			we_rf_MEM <= next_we_rf;
			we_mem_MEM <= next_we_mem;
			re_mem_MEM <= next_re_mem;
			wb_sel_MEM <= next_wb_sel;
			dst_addr_MEM <= next_dst_addr;
			sdata_MEM <= next_sdata;
			b_ctrl_MEM <= next_b_ctrl;
			pc_MEM <= next_pc;
			j_ctrl_MEM <= next_j_ctrl;
			hlt_MEM <= next_hlt;
		end
	end 
	
	assign next_alu_result = (stall) ? alu_result_MEM : alu_result_EX;
	assign next_we_rf = (stall) ? we_rf_MEM : we_rf_EX;
	assign next_we_mem = (stall) ? we_mem_MEM : we_mem_EX;
	assign next_re_mem = (stall) ? re_mem_MEM : re_mem_EX;
	assign next_wb_sel = (stall) ? wb_sel_MEM : wb_sel_EX;
	assign next_dst_addr = (stall) ? dst_addr_MEM : dst_addr_EX;
	assign next_sdata = (stall) ? sdata_MEM : sdata_EX;
	assign next_b_ctrl = (stall) ? b_ctrl_MEM : b_ctrl_EX;
	assign next_pc = (stall) ? pc_MEM : pc_EX;
	assign next_j_ctrl = (stall) ? j_ctrl_MEM : j_ctrl_EX;
	assign next_hlt = (stall) ? hlt_MEM : hlt_EX;
	 
endmodule
