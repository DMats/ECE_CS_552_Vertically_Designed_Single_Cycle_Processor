// R Scott Carson
// 16 bit ALU
module ALU(opcode, ops, src1, src0, shamt, prev_br_ctrl, clk, rst_n, dst, N, Z, V);
	input[3:0] opcode;
	input[2:0] ops;
	input[15:0] src1, src0;
	input[3:0] shamt;
	input clk, rst_n;
	input prev_br_ctrl;
	
	output [15:0] dst;
	output reg N, Z, V;
	
	wire [16:0] temp_dst, arithmetic_temp, saturated_arithmetic;
	wire ov_pos, ov_neg, exception, n, zr, ov;
	
	// Instruction Opcodes
	localparam addOp = 4'b0000;
	localparam addzOp = 4'b0001;
	localparam subOp = 4'b0010;
	localparam andOp = 4'b0011;
	localparam norOp = 4'b0100;
	localparam sllOp = 4'b0101;
	localparam srlOp = 4'b0110;
	localparam sraOp = 4'b0111;
	localparam lwOp = 4'b1000;
	localparam swOp = 4'b1001;
	localparam lhbOp = 4'b1010;
	localparam llbOp = 4'b1011;
	localparam hltOp = 4'b1111;
	localparam bOp = 4'b1100;
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;

	// ALU Operations
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

	assign update_NZV = 	((opcode == addOp)	||
							(opcode == addzOp) 	||
							(opcode == subOp));
	
	assign update_Z_only = 	((opcode == andOp)	||
							(opcode == norOp)	||
							(opcode == sllOp)	||
							(opcode == srlOp)	||
							(opcode == sraOp));

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
		else if (prev_br_ctrl) begin
			N <= N;
			Z <= Z;
			V <= V;
		end
		else if (update_Z_only) begin
			N <= N;
			Z <= zr;
			V <= V;
		end
		else if (update_NZV) begin
			N <= n;
			Z <= zr;
			V <= ov;
		end
		else begin
			N <= N;
			Z <= Z;
			V <= V;
		end
	end	

endmodule
