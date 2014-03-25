// R Scott Carson
// David Mateo
// Single Cycle Non-Branching CPU testbench
// CS 552

//`include "cpu.v"

module cpu_tb();

reg clk, rst_n;
wire hlt;  	// We think this should be a wire, but 
				// There is a cyclic dependency on the hlt signal
				// PC doesn't run because hlt floats
				// ID never updates hlt signal because PC doesn't run
				// PC receives hlt from ID


cpu DUT(
		.clk(clk),
		.hlt(hlt),
		.rst_n(rst_n)
		);
		
initial begin
	$dumpfile("cpu_dump.vcd");
	$dumpvars(0,cpu_tb);
	clk = 0;
	rst_n = 0;
	#5
	rst_n = 1;

	#100
	$finish;
end

always begin
	#5 clk = ~clk;
end

endmodule
