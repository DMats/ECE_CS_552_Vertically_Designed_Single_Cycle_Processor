module MEM_WB_FF(ldata_WB, alu_result_WB, wb_sel_WB, ldata_MEM, alu_result_MEM, 
	wb_sel_MEM, clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] ldata_MEM, alu_result_MEM;
	input wire wb_sel_MEM, clk, rst_n, stall;
	
	// Outputs
	output reg [15:0] ldata_WB, alu_result_WB;
	output reg wb_sel_WB;
	
	// Local wires
	wire [15:0] next_ldata, next_alu_result;
	wire next_wb_sel;
	
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			ldata_WB <= 16'h0000;
			alu_result_WB <= 16'h0000;
			wb_sel_WB <= 1'b0;
		end
		else begin
			ldata_WB <= next_ldata;
			alu_result_WB <= next_alu_result;
			wb_sel_WB <= next_wb_sel;
		end
	end 
	
	assign next_ldata = (stall) ? ldata_WB : ldata_MEM;
	assign next_alu_result = (stall) ? alu_result_WB : alu_result_MEM;
	assign next_wb_sel = (stall) ? wb_sel_WB : wb_sel_MEM;
	
endmodule