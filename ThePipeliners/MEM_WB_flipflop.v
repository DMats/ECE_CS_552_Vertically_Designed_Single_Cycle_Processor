module MEM_WB_FF(
	ldata_WB, alu_result_WB, wb_sel_WB, we_rf_WB, dst_addr_WB, hlt_WB,
	ldata_MEM, alu_result_MEM, wb_sel_MEM, we_rf_MEM, dst_addr_MEM, hlt_MEM,
	clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] ldata_MEM, alu_result_MEM;
	input wire [3:0] dst_addr_MEM;
	input wire wb_sel_MEM, we_rf_MEM, clk, rst_n, stall, hlt_MEM;
	
	// Outputs
	output reg [15:0] ldata_WB, alu_result_WB;
	output reg [3:0] dst_addr_WB;
	output reg wb_sel_WB, we_rf_WB, hlt_WB;
	
	// Local wires
	wire [15:0] next_ldata, next_alu_result;
	wire [3:0] next_dst_addr;
	wire next_wb_sel, next_we_rf, next_hlt;
	
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			ldata_WB <= 16'h0000;
			alu_result_WB <= 16'h0000;
			we_rf_WB <= 1'b0;
			wb_sel_WB <= 1'b0;
			dst_addr_WB <= 4'b0000;
			hlt_WB <= 1'b0;
		end
		else begin
			ldata_WB <= next_ldata;
			alu_result_WB <= next_alu_result;
			we_rf_WB <= next_we_rf;
			wb_sel_WB <= next_wb_sel;
			dst_addr_WB <= next_dst_addr;
			hlt_WB <= next_hlt;
		end
	end 
	
	assign next_ldata = (stall) ? ldata_WB : ldata_MEM;
	assign next_alu_result = (stall) ? alu_result_WB : alu_result_MEM;
	assign next_we_rf = (stall) ? we_rf_WB : we_rf_MEM;
	assign next_wb_sel = (stall) ? wb_sel_WB : wb_sel_MEM;
	assign next_dst_addr = (stall) ? dst_addr_WB : dst_addr_MEM;
	assign next_hlt = (stall) ? hlt_WB : hlt_MEM;
	
endmodule
