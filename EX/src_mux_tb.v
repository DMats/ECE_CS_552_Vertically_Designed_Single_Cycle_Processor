// Author: R Scott Carson
// SRC_MUX and Sign Extend Logic Test Bench
// CS/ECE 552, Spring 2014

module src_mux_tb();

	reg[15:0] p1_stim;
	reg[7:0] imm8_stim;
	reg	src1sel_stim;
	
	wire [15:0] src1_mon;
	
	src_mux	DUT(	.p1(p1_stim),
					.imm8(imm8_stim),
					.src1sel(src1sel_stim),
					.src1(src1_mon)
					);
	
	initial begin
		
		p1_stim = 16'h1234;
		imm8_stim = 8'h80;
		src1sel_stim = 1'b1;
		
		#5
		
		src1sel_stim = 1'b0;
	
	end

endmodule
