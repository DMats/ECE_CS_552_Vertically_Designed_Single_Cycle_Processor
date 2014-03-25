// program_counter
// Authors:  David Mateo, R. Scott Carson
module PC(iaddr, clk, rst_n, hlt);

output reg [15:0] iaddr;
input clk, rst_n, hlt;

wire [15:0] next_iaddr;

// Sequential Logic
///////////////////////////////////////////////
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		iaddr <= iaddr;
	end
	else begin
		iaddr <= next_iaddr;
	end
end
///////////////////////////////////////////////

// Combinational Logic
///////////////////////////////////////////////
assign next_iaddr = (hlt) ? iaddr : iaddr + 1'b1;
//////////////////////////////////////////////


always @(iaddr) begin
	$display("Insruction address = %h", iaddr);
end

endmodule