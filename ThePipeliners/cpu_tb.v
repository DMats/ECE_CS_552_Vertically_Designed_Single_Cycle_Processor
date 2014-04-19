// R Scott Carson
// David Mateo
// Single Cycle Non-Branching CPU testbench
// CS 552

//`include "cpu.v"

`timescale 10ns/10ns

module cpu_tb();

reg clk, rst_n;
wire hlt;

cpu DUT(
		.clk(clk),
		.hlt(hlt),
		.rst_n(rst_n)
		);
		
initial begin
	$dumpfile("Debug/cpu_dump.vcd");
	$dumpvars(0,cpu_tb);
	clk = 0;
	rst_n = 0;
	#5
	rst_n = 1;

	#1000
	$finish;
end

always begin
	#5 clk = ~clk;
end

endmodule
