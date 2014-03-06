// program_counter
// Authors:  David Mateo, R. Scott Carson
module program_counter(iaddr, clk, rst_n, hlt);

output reg [15:0] iaddr;
input clk, rst_n, hlt;

wire [15:0] next_iaddr;

// Sequential Logic
///////////////////////////////////////////////
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		iaddr <= next_iaddr;
	end
	else begin
		iaddr <= iaddr;
	end
end
///////////////////////////////////////////////

// Combinational Logic
///////////////////////////////////////////////
assign next_iaddr = (hlt) ? iaddr : iaddr + 1'b1;
//////////////////////////////////////////////

endmodule