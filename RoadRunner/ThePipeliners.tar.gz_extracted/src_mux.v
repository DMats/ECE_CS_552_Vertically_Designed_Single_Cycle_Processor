// Author: R Scott Carson
// SRC_MUX and Sign Extend Logic
// CS/ECE 552, Spring 2014

module src_mux(src1, src1sel, p1, imm8);

	// Inputs
	input [15:0] p1;
	input [7:0] imm8;
	input src1sel;
	
	// Outputs
	output [15:0] src1;
	
	assign src1 = (src1sel)	?	p1:
								({{8{imm8[7]}}, imm8});
		
endmodule
