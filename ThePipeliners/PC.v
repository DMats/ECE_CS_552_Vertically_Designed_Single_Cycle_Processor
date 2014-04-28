// program_counter
// Authors:  David Mateo, R. Scott Carson
module PC(iaddr, pc_plus_1, alt_pc, alt_pc_ctrl, clk, rst_n, hlt, stall);

output reg [15:0] iaddr;

output wire [15:0] pc_plus_1;

input wire [15:0] alt_pc;
input wire clk, rst_n, hlt, alt_pc_ctrl, stall;

wire [15:0] next_iaddr;

// Sequential Logic
///////////////////////////////////////////////
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		iaddr <= 16'h0000;
	end
	else begin
		iaddr <= next_iaddr;
	end
end
///////////////////////////////////////////////

// Combinational Logic
///////////////////////////////////////////////
assign next_iaddr = (hlt || stall)	? 	iaddr : 
					(alt_pc_ctrl)	?	alt_pc:
									pc_plus_1;
assign pc_plus_1 = iaddr + 16'h0001;
//////////////////////////////////////////////

/*
always @(iaddr) begin
	$display("Insruction address = %h", iaddr);
end*/

endmodule
