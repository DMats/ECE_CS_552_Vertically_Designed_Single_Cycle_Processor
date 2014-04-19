module WB(
	// Input
	wb_sel, 
	rd_data, 
	alu_result,
	// Output
	wb_data
        );

input wire wb_sel;
input wire [15:0] rd_data, alu_result;

output wire [15:0] wb_data;

assign wb_data = (wb_sel) ? alu_result : rd_data;

endmodule
