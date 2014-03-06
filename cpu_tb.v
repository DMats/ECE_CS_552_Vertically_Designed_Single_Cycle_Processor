// R Scott Carson
// David Mateo
// Single Cycle Non-Branching CPU testbench
// CS 552

//`include "cpu.v"

module cpu_tb();

reg clk, rst_n;
wire hlt;

cpu DUT(
		.clk(clk),
		.hlt(hlt),
		.rst_n(rst_n)
		);
		
initial begin
	$dumpfile("cpu_dump.vcd");
	$dumpvars(0,cpu_tb.v);
	clk = 0;
	rst_n = 0;
	#5
	rst_n = 1;
end

always begin
	#5 clk = ~clk;
end

endmodule
