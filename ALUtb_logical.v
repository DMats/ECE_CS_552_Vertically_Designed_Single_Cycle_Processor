/*
* R Scott Carson
* 16 bit ALU Testbenches
*/

// Logical testbench - Tests AND and NOR instructions
module ALUtb_logical();

	reg [15:0] src1_stim, src0_stim;
	reg [2:0] ops_stim;
	reg	[3:0] shamt_stim;

	wire [15:0] out_mon;
	wire ov_mon, zr_mon;

	ALU DUT(	.dst(out_mon), 
				.ov(ov_mon), 
				.zr(zr_mon), 
				.src1(src1_stim), 
				.src0(src0_stim), 
				.ops(ops_stim), 
				.shamt(shamt_stim));

	initial begin			
		$display("Starting ALU logic testbench...");
		$display("Testing AND, NOR");
	end
	
	// Each iteration generates 2 random numbers and generates a random opcode
	// (either AND or NOR).  It then delays to allow the operation to complete
	// and then checks return values against expected values.  If an error is
	// detected, it halts the execution and displays information about the input
	// and expected output.
	always begin
		src1_stim = $random;
		src0_stim = $random;
		shamt_stim = 4'b0000;
		ops_stim = ($random % 2)	?	(3'b010): // AND
										(3'b011); // NOR
		
		#5
		if((ops_stim == 3'b010) && (out_mon != (src1_stim&src0_stim))) begin
			$display("Inputs: src1=%h, src0=%h, AND", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src1_stim&src0_stim, out_mon);
			$stop();									
		end
		else if((ops_stim == 3'b011) && (out_mon != (~(src1_stim|src0_stim)))) begin
			$display("Inputs: src1=%h, src0=%h, NOR", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src1_stim|~src0_stim, out_mon);
			$stop();									
		end	
		
		if(ov_mon != 0) begin
			$display("Inputs: src1=%h, src0=%h", src1_stim, src0_stim);
			$display("ERROR: Overflow mismatch, expected 0");
			$stop();
		end
		
		if(zr_mon != &(~out_mon)) begin
			$display("Inputs: src1=%h, src0=%h", src1_stim, src0_stim);
			$display("ERROR: Zero flag mismatch, expected %h", ~(& out_mon));
			$stop();
		end
	end
endmodule
