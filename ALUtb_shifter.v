// Shifter testbench - Tests SLL, SRL, SRA, and LHB
module ALUtb_shifter_simple();

	reg [15:0] src1_stim, src0_stim;
	reg [2:0] ops_stim;
	reg	[3:0] shamt_stim;

	wire [15:0] out_mon;
	wire ov_mon, zr_mon;
	
	// Used for calculation of overflow
	integer rand;
	
	// Initialize the ALU
	ALU DUT(	.dst(out_mon), 
				.ov(ov_mon), 
				.zr(zr_mon), 
				.src1(src1_stim), 
				.src0(src0_stim), 
				.ops(ops_stim), 
				.shamt(shamt_stim));

	initial begin			
		$display("Starting ALU shifter simple testbench...");
		$display("Testing SLL, SRL, SRA, LHB");
		
		src1_stim = 16'hff48;
		src0_stim = 16'h0001;
		shamt_stim = 4'b0001;
		ops_stim = 	3'b100; // SLL
		#5
		if((ops_stim == 3'b100) && (out_mon != 16'h0002)) begin
			$display("Inputs: src1=%h, src0=%h, SLL", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h0002, out_mon);
			$stop();									
		end
		
		src1_stim = 16'hff48;
		src0_stim = 16'h0002;
		shamt_stim = 4'b0001;
		ops_stim = 	3'b101; // SRL
		#5
		if((ops_stim == 3'b101) && (out_mon != 16'h0001)) begin
			$display("Inputs: src1=%h, src0=%h, SRL", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h0001, out_mon);
			$stop();									
		end
		
		src1_stim = 16'hff48;
		src0_stim = 16'h8004;
		shamt_stim = 4'b0010;
		ops_stim = 	3'b111; // SRA
		#5
		if((ops_stim == 3'b111) && (out_mon != 16'he001)) begin
			$display("Inputs: src1=%h, src0=%h, SRA", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'he001, out_mon);
			$stop();									
		end
		
		src1_stim = 16'hff48;
		src0_stim = 16'h80e3;
		shamt_stim = 4'b0010;
		ops_stim = 	3'b110; // SRA
		#5
		if((ops_stim == 3'b110) && (out_mon != 16'he348)) begin
			$display("Inputs: src1=%h, src0=%h, LHB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'he348, out_mon);
			$stop();									
		end
		
		$display("Simple shifter test completed successfully!");
	end

endmodule




// Shifter testbench - Tests SLL, SRL, SRA, and LHB
module ALUtb_shifter_random();

	reg [15:0] src1_stim, src0_stim;
	reg [2:0] ops_stim;
	reg	[3:0] shamt_stim;

	wire [15:0] out_mon;
	wire ov_mon, zr_mon;
	
	// Used for calculation of overflow
	integer rand;
	
	// Initialize the ALU
	ALU DUT(	.dst(out_mon), 
				.ov(ov_mon), 
				.zr(zr_mon), 
				.src1(src1_stim), 
				.src0(src0_stim), 
				.ops(ops_stim), 
				.shamt(shamt_stim));

	initial begin			
		$display("Starting ALU arithmetic testbench...");
		$display("Testing ADD, SUB %h", (~(1'b1|1'b0)));
	end
	
	// Each iteration generates 4 random numbers and generates a random opcode
	// (either SLL, SRL, SRA, or LHB).  It then delays to allow the operation to complete
	// and then checks return values against expected values.  If an error is
	// detected, it halts the execution and displays information about the input
	// and expected output.
	always begin
		src1_stim = $random;
		src0_stim = $random;
		shamt_stim = ($random)&4'hf;
		
		rand = $random % 4;
		ops_stim = 	(rand==0)	?	(3'b100): // SLL
					(rand==1)	?	(3'b101): // SRL
					(rand==2)	?	(3'b111): // SRA
					(rand==3)	?	(3'b110): // LHB
									(3'b000);
		
		#5
		if((ops_stim == 3'b100) && (out_mon != (src0_stim<<shamt_stim))) begin
			$display("Inputs: src1=%h, src0=%h, SLL", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src0_stim<<shamt_stim, out_mon);
			$stop();									
		end
		else if((ops_stim == 3'b101) && (out_mon != (src0_stim>>shamt_stim))) begin
			$display("Inputs: src1=%h, src0=%h, SRL", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src0_stim>>shamt_stim, out_mon);
			$stop();									
		end
		
		else if((ops_stim == 3'b111) && (out_mon != ($signed(src0_stim)>>>shamt_stim))) begin
			$display("Inputs: src1=%h, src0=%h, SRA", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", $signed(src0_stim)>>>shamt_stim, out_mon);
			$stop();									
		end
		
		else if((ops_stim == 3'b110) && (out_mon != {src0_stim[7:0],src1_stim[7:0]})) begin
			$display("Inputs: src1=%h, src0=%h, LHB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", {src0_stim[7:0],src1_stim[7:0]}, out_mon);
			$stop();									
		end
		
		if(zr_mon != &(~out_mon)) begin
			$display("Inputs: src1=%h, src0=%h", src1_stim, src0_stim);
			$display("ERROR: Zero flag mismatch, expected %h", (& out_mon));
			$stop();
		end
	end

endmodule

