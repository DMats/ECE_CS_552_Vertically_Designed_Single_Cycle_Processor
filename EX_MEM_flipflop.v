module EX_MEM_FF(we_mem_MEM, re_mem_MEM, alu_result_MEM_WB, wb_sel_MEM_WB, 
	we_mem_EX_MEM, re_mem_EX_MEM, alu_result_EX_MEM_WB, wb_sel_EX_MEM_WB, 
	clk, rst_n, stall);
	
	// Inputs
	input wire [15:0] alu_result_EX;
	input wire wb_sel_EX, we_mem_EX, re_mem_EX, clk, stall, rst_n;
	
	// Outputs
	output reg [15:0] alu_result_MEM;
	output reg we_mem_MEM, re_mem_MEM, wb_sel_MEM;
	
	// Local wires
	wire [15:0] next_alu_result;
	wire next_we_mem, next_re_mem, next_wb_sel;
	
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			alu_result_MEM <= 16'h0000;
			we_mem_MEM <= 1'b0;
			re_mem_MEM <= 1'b0;
			wb_sel_MEM <= 1'b0;
		end 
		else begin
			alu_result_MEM <= next_alu_result;
			we_mem_MEM <= next_we_mem;
			re_mem_MEM <= next_re_mem;
			wb_sel_MEM <= next_wb_sel;
		end
	end 
	
	assign next_alu_result = (stall) ? alu_result_MEM : alu_result_EX;
	assign next_we_mem = (stall) ? we_mem_MEM : we_mem_EX;
	assign next_re_mem = (stall) ? re_mem_MEM : re_mem_EX;
	assign next_wb_sel = (stall) ? wb_sel_MEM : wb_sel_EX;
	 
endmodule