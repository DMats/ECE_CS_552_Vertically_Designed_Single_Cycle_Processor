// Forwarding Control Unit
// Author:  David Mateo
// This module creates the forwarding control signals.
module FCU(
	// Input
	p0_addr_EX,
	p1_addr_EX,
	we_rf_MEM_WB, 
	dst_addr_MEM_WB, 
	we_rf_WB,
	dst_addr_WB,
	re_mem_MEM,
	// Output
	forwardA,
	forwardB
	);

	input we_rf_MEM_WB, we_rf_WB, re_mem_MEM;
	input [3:0] dst_addr_MEM_WB;
	input [3:0] p1_addr_EX;
	input [3:0] p0_addr_EX;
	input [3:0] dst_addr_WB;

	output [1:0] forwardA, forwardB;

	forwarding_logic FL(
		// Input
		.we_rf_MEM_WB(we_rf_MEM_WB),
		.dst_addr_MEM_WB(dst_addr_MEM_WB),
		.p1_addr_EX(p1_addr_EX),
		.p0_addr_EX(p0_addr_EX),
		.we_rf_WB(we_rf_WB),
		.dst_addr_WB(dst_addr_WB),
		.re_mem_MEM(re_mem_MEM),
		// Output
		.forwardA(forwardA),
		.forwardB(forwardB)
		);

endmodule
