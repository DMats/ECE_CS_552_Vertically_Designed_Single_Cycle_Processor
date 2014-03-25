// R Scott Carson
// 16 bit ALU
module ALU(ops, src1, src0, dst, ov, zr, n, shamt);
	input[2:0] ops;
	input[15:0] src1, src0;
	input[3:0] shamt;
	
	output[15:0] dst;
	output ov, zr, n;
	
	wire [16:0] temp_dst, arithmetic_temp, saturated_arithmetic;
	wire ov_pos, ov_neg, exception;
	
	//opcodes
	localparam add16 = 3'b000;
	localparam sub16 = 3'b001;
	localparam and16 = 3'b010;
	localparam nor16 = 3'b011;
	localparam sll16 = 3'b100;
	localparam srl16 = 3'b101;
	localparam sra16 = 3'b111;
	localparam lhb16 = 3'b110;
	
	// Addition and Subtraction with overflow //
	assign arithmetic_temp = 	(ops==add16)	?	(src1 + src0):
								(ops==sub16)	?	(src1 - src0):
													17'hxxxxx;
								
	assign exception = ((ops==sub16) & (src1[15] == src0[15]));
	assign ov_pos = (~src0[15] & ~src1[15] & arithmetic_temp[15] & ~exception);
	assign ov_neg = (src0[15] & src1[15] & ~arithmetic_temp[15] & ~exception);
	
	assign temp_dst = 	(ov_pos)	?	(16'h7FFF):
						(ov_neg)	?	(16'h8000):
										arithmetic_temp;
	
	// Perform required operation
	assign dst = 	(ops==add16)||(ops==sub16)	?	(temp_dst):
								(ops==and16)	?	{1'b0,(src1&src0)}:
								(ops==nor16)	?	{1'b0,~(src1|src0)}:
								(ops==sll16)	?	{1'b0,src1<<$unsigned(shamt)}:
								(ops==srl16)	?	{1'b0,src1>>$unsigned(shamt)}:
								(ops==sra16)	?	{1'b0,$signed(src1)>>>$unsigned(shamt)}:
								(ops==lhb16)	?	{1'b0,{src1[7:0],src0[7:0]}}:
													17'hxxxxx;

	// Combinational Logic for Flags //								
	// Determine if overflow has occured	
	assign ov = (ov_pos | ov_neg);
	// Check if result is 0					
	assign zr = &(~dst);
	// TODO:  n is unimplemented.  Do not leave it as 1'b0.
	assign n = 1'b0;

endmodule
