// program_counter
// Authors:  David Mateo, R. Scott Carson
module PC(iaddr, new_pc, br_ctrl, clk, rst_n, hlt);

output reg [15:0] iaddr;

input wire [15:0] new_pc;
input wire clk, rst_n, hlt, br_ctrl;

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
assign next_iaddr = (hlt) 		? 	iaddr : 
					(br_ctrl)	?	new_pc:
									iaddr + 1'b1;
//////////////////////////////////////////////


always @(iaddr) begin
	$display("Insruction address = %h", iaddr);
end

endmodule