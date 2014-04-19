// R Scott Carson
// 16 bit ALU
module ALU(ops, src1, src0, shamt, prev_br_ctrl, clk, rst_n, dst, N, Z, V);
	input[2:0] ops;
	input[15:0] src1, src0;
	input[3:0] shamt;
	input clk, rst_n;
	input prev_br_ctrl;
	
	output [15:0] dst;
	output reg N, Z, V;
	
	wire [16:0] temp_dst, arithmetic_temp, saturated_arithmetic;
	wire ov_pos, ov_neg, exception, n, zr, ov;
	
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
	// Check if result is negative
	assign n = ((ops==add16) || (ops==sub16)) ? dst[15] :  N;
	// Check if result is 0					
	assign zr = &(~dst);
	// Determine if overflow has occured	
	assign ov = ((ops==add16) || (ops==sub16)) ? (ov_pos | ov_neg) : V;

	// Sequential Logic for Flags //
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			N <= 1'b0;
			Z <= 1'b0;
			V <= 1'b0;
		end
		else if (prev_br_ctrl && rst_n) begin
			N <= N;
			Z <= Z;
			V <= V;
		end
		else begin
			N <= n;
			Z <= zr;
			V <= ov;
		end
	end	

endmodule
