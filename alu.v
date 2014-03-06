// R Scott Carson
// 16 bit ALU
module ALU(ops, src1, src0, dst, ov, zr, shamt);
	input[2:0] ops;
	input[15:0] src1, src0;
	input[3:0] shamt;
	
	output[15:0] dst;
	output ov, zr;
	
	wire [16:0] temp_dst;
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
	
	// Perform required operation
	assign temp_dst = 	(ops==add16)	?	(src1 + src0):
						(ops==sub16)	?	(src1 - src0):
						(ops==and16)	?	{1'b0,(src1&src0)}:
						(ops==nor16)	?	{1'b0,~(src1|src0)}:
						(ops==sll16)	?	{1'b0,src0<<$unsigned(shamt)}:
						(ops==srl16)	?	{1'b0,src0>>$unsigned(shamt)}:
						(ops==sra16)	?	{1'b0,$signed(src0)>>>$unsigned(shamt)}:
						(ops==lhb16)	?	{1'b0,{src0[7:0],src1[7:0]}}:
											17'hxxxxx;
									
	// Determine if overflow has occured
	assign exception = ((ops==sub16)&(src1==src0));
	assign ov_pos = (~src0[15] & ~src1[15] & temp_dst[15] & ~exception)|(temp_dst[15]&~temp_dst[16]);
	assign ov_neg = (src0[15] & src1[15] & ~temp_dst[15] & ~exception)|(~temp_dst[15]&temp_dst[16]);
	assign ov = ((ov_pos | ov_neg)&((ops==add16)|(ops==sub16)));
	assign dst = 	((ov_neg)&((ops==add16)|(ops==sub16)))	?	16'h8000:
					((ov_pos)&((ops==add16)|(ops==sub16)))	?	16'h7fff:
																temp_dst[15:0];
								
	// Check if result is 0
	assign zr = &(~dst);
endmodule

