module WB(wb_sel, rd_data, alu_result, wb_data, pc_jal);

input wire wb_sel;
input wire [15:0] rd_data, alu_result, pc_jal;

output wire [15:0] wb_data;
output wire [15:0]

assign wb_data = (wb_sel) ? alu_result : rd_data;

endmodule