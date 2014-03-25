// Author: R Scott Carson
// Instruction Decode Architecture
// CS/ECE 552, Spring 2014

module I_DECODE(instr, zr, p0_addr, re0, p1_addr, re1, dst_addr, we, hlt, src1sel, shamt, func);

	// Inputs
	input[15:0] instr;
	input zr;

	// Outputs
	output [3:0] p0_addr, p1_addr, dst_addr, shamt;
	output [2:0] func;
	output hlt, src1sel, re0, re1, we;
	
	wire [3:0] opcode, reg_dest, reg_src1, reg_src0;


	initial begin
		$display("HELLO WORLD.");  // worked.
	end

	always @(instr) begin
		$display("instruction = %h", instr);
	end
	
	// Instruction Opcodes
	localparam addOp = 4'b0000;
	localparam addzOp = 4'b0001;
	localparam subOp = 4'b0010;
	localparam andOp = 4'b0011;
	localparam norOp = 4'b0100;
	localparam sllOp = 4'b0101;
	localparam srlOp = 4'b0110;
	localparam sraOp = 4'b0111;
	localparam lhbOp = 4'b1010;
	localparam llbOp = 4'b1011;
	localparam hltOp = 4'b1111;

	// ALU functions
	localparam add16 = 3'b000;
	localparam sub16 = 3'b001;
	localparam and16 = 3'b010;
	localparam nor16 = 3'b011;
	localparam sll16 = 3'b100;
	localparam srl16 = 3'b101;
	localparam sra16 = 3'b111;
	localparam lhb16 = 3'b110;

	// Determine opcode and corresponding signals
	assign opcode = instr[15:12];

	// Halt Case //
	assign hlt = 	(opcode == hltOp)	?	(1'b1):
											(1'b0);

	// Pull down hlt to prevent cyclic dependency between ID and PC
	//pulldown(hlt);

	// Extract all needed signals and then MUX them to output proper controls
	assign dst_addr = instr[11:8];
	assign p1_addr = instr[7:4];
	assign p0_addr = instr[3:0];

	// Extract the shift amount.  For llb, we set shift to 0
	assign shamt =  (opcode == llbOp)	?	(4'b0000):
											instr[3:0];
	
	assign func = 	((opcode == addOp)||(opcode == addzOp))	? 	add16:
					(opcode == subOp)						?	sub16:
					(opcode == andOp)						?	and16:
					(opcode == norOp)						?	nor16:
					((opcode == sllOp)||(opcode == llbOp))	? 	sll16:
					(opcode == srlOp)						?	srl16:
					(opcode == sraOp)						?	sra16:
					(opcode == lhbOp)						?	lhb16:
																3'bxxx;
	
	// Determine if the result will be written back to the register file.
	// For this version of the instruction decoder onlt the addz instruction
	// eliminates write back.
	assign we = ((opcode == addzOp)&&(~zr))	?	1'b0: 
												1'b1;
												
	assign re0 = 	(opcode == llbOp)	?	1'b0:
											1'b1;
											
	assign re1 =	(opcode == llbOp)	?	1'b0:
											1'b1;
	
	assign src1sel = ((opcode == llbOp)||(opcode == lhbOp))	?	1'b0:
																1'b1;
										
endmodule