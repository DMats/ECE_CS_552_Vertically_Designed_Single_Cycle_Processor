// program_counter
// Authors:  David Mateo, R. Scott Carson
module program_counter(pc_ID_EX, pc_EX_DM, pc);

output reg [15:0] pc_ID_EX, pc_EX_DM, pc;
input [15:0] dst_ID_EX;
input clk, rst_n, stall, flow_change_ID_EX;

reg [15:0] pc_IM_ID;
wire [15:0] last_pc_plus_1, next_pc, mux1;


// Sequential Logic
//////////////////////////////////////////////
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		pc <= next_pc;
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		pc_IM_ID <= last_pc_plus_1;
	end
end

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		pc_ID_EX <= pc_IM_ID;
	end
end

always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		pc_EX_DM <= pc_ID_EX;
	end
end
//////////////////////////////////////////////


// Combinational Logic
//////////////////////////////////////////////
assign last_pc_plus_1 = (stall) ? pc + 1'b1 : pc_IM_ID;
assign mux1 = (flow_change_ID_EX) ? dst_ID_EX : pc + 1'b1;
assign next_pc = (stall) ? pc : mux1;
//////////////////////////////////////////////

endmodule