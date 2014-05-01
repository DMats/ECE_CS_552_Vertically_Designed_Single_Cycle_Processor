module WB(
	// Input
	wb_sel, 
	rd_data, 
	alu_result,
	pc,
	j_ctrl,
	// Output
	wb_data
        );

input wire wb_sel, j_ctrl;
input wire [15:0] rd_data, alu_result, pc;

output wire [15:0] wb_data;

assign wb_data = 	(j_ctrl)	?	pc		:
					(wb_sel) 	? 	alu_result 	: 
									rd_data;

endmodule
