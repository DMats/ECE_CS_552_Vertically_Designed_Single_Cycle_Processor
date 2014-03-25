// This should have NO combinational logic in it!
module flags(N, Z, V, clk, rst_n, n, zr, ov);

output reg N, Z, V;
input wire clk, rst_n, ov, zr, n;

// Sequential Logic for Flags //
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		N <= 1'b0;
		Z <= 1'b0;
		V <= 1'b0;
	end
	else begin
		//TODO: n is unimplemented so far.	
		N <= n;
		// Check if result is 0
		Z <= zr;
		// Determine if overflow has occured
		V <= ov;
	end
end

endmodule