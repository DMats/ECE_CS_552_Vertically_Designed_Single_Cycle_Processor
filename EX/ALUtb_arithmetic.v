// Arithmetic testbench - Tests ADD and SUB instructions
module ALUtb_arithmetic_simple();

	reg [15:0] src1_stim, src0_stim;
	reg [2:0] ops_stim;
	reg	[3:0] shamt_stim;

	wire [15:0] out_mon;
	wire ov_mon, zr_mon;
	
	// Used for calculation of overflow
	integer ov_pos, ov_neg, ov_temp;
	
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
		$display("Testing ADD, SUB");
		$display("Base and fringe cases:");
		
		src1_stim = 16'h7FFF;
		src0_stim = 16'h7FFF;
		shamt_stim = 4'b0000;
		ops_stim = 3'b000;
		#10
		if((ops_stim == 3'b000) && (out_mon != 16'h7FFF) && (ov_mon != 1)) begin
			$display("Inputs: src1=%h, src0=%h, ADD", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h7fff, out_mon);
			$stop();									
		end
		
		src1_stim = 16'ha000;
		src0_stim = 16'ha000;
		shamt_stim = 4'b0000;
		#10
		if((ops_stim == 3'b000) && (out_mon != 16'h8000) && (ov_mon != 1)) begin
			$display("Inputs: src1=%h, src0=%h, ADD", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h8000, out_mon);
			$stop();									
		end
		
		src1_stim = 16'h0001;
		src0_stim = 16'h0000;
		shamt_stim = 4'b0000;
		#10
		if((ops_stim == 3'b000) && (out_mon != 16'h0001) && (ov_mon != 0)) begin
			$display("Inputs: src1=%h, src0=%h, ADD", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h0001, out_mon);
			$stop();									
		end
		
		ops_stim = 3'b001;
		src1_stim = 16'h0001;
		src0_stim = 16'h0001;
		shamt_stim = 4'b0000;
		#10
		if((ops_stim==3'b001) && (out_mon!=16'h0000) && (ov_mon!=0) && (zr_mon!=1)) begin
			$display("Inputs: src1=%h, src0=%h, SUB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h0000, out_mon);
			$stop();									
		end
		
		src1_stim = 16'ha5a5;
		src0_stim = 16'ha5a5;
		shamt_stim = 4'b0000;
		#10
		if((ops_stim==3'b001) && (out_mon!=16'h0000) && (ov_mon!=0) && (zr_mon!=1)) begin
			$display("Inputs: src1=%h, src0=%h, SUB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h0000, out_mon);
			$stop();									
		end
		
		src1_stim = 16'ha000;
		src0_stim = 16'h7fff;
		shamt_stim = 4'b0000;
		#10
		if((ops_stim==3'b001) && (out_mon!=16'h8000) && (ov_mon!=1) && (zr_mon!=0)) begin
			$display("Inputs: src1=%h, src0=%h, SUB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", 16'h8000, out_mon);
			$stop();									
		end
		
		$display("Base and fringe testing successful!");
	end
endmodule


// Arithmetic testbench - Tests ADD and SUB instructions
module ALUtb_arithmetic_random();

	reg [15:0] src1_stim, src0_stim;
	reg [2:0] ops_stim;
	reg	[3:0] shamt_stim;

	wire [15:0] out_mon;
	wire ov_mon, zr_mon;
	
	// Used for calculation of overflow
	integer ov_pos, ov_neg, ov_temp;
	
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
		$display("Testing ADD, SUB");
	end
	
	// Each iteration generates 2 random numbers and generates a random opcode
	// (either ADD or SUB).  It then delays to allow the operation to complete
	// and then checks return values against expected values.  If an error is
	// detected, it halts the execution and displays information about the input
	// and expected output.
	always begin
		src1_stim = $random;
		src0_stim = $random;
		shamt_stim = 4'b0000;
		
		ops_stim = ($random % 2)	?	(3'b000): // ADD
										(3'b001); // SUB
		
		#5
		if((ops_stim == 3'b000) && (out_mon != (src1_stim+src0_stim)) && (ov_mon == 0)) begin
			$display("Inputs: src1=%h, src0=%h, ADD", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src1_stim+src0_stim, out_mon);
			$stop();									
		end
		else if((ops_stim == 3'b001) && (out_mon != (src1_stim-src0_stim)) && (ov_mon == 0)) begin
			$display("Inputs: src1=%h, src0=%h, SUB", src1_stim, src0_stim);
			$display("ERROR: Expected %h, returned %h", src1_stim-src0_stim, out_mon);
			$stop();									
		end	
		
		//Check for overflow correctness
		assign ov_pos = ~src0_stim[15] & ~src1_stim[15] & out_mon[15];
		assign ov_neg = src0_stim[15] & src1_stim[15] & ~out_mon[15];
		assign ov_temp = ((ops_stim==3'b000)||(ops_stim==3'b001))	?	(ov_pos | ov_neg):
																		1'b0;
																	
		if(ov_temp != ov_mon) begin
			$display("Inputs: src1=%h, src0=%h", src1_stim, src0_stim);
			$display("ERROR: Overflow flag mismatch, expected %h", ov_temp);
			$stop();			
		end
		
		if(zr_mon != &(~out_mon)) begin
			$display("Inputs: src1=%h, src0=%h", src1_stim, src0_stim);
			$display("ERROR: Zero flag mismatch, expected %h", (& out_mon));
			$stop();
		end
	end
endmodule
