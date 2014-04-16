// Author: R Scott Carson
// Instruction Decode Architecture
// CS/ECE 552, Spring 2014

module I_DECODE(
	//Inputs
	instr, PC, 
	//Outputs
	p0_addr, re0, p1_addr, re1, dst_addr, we_rf, hlt, src1sel, shamt, func, imm8, 
	we_mem, re_mem, wb_sel, j_ctrl);

	// Inputs
	input[15:0] instr, PC;

	// Outputs
	output [3:0] p0_addr, p1_addr, dst_addr, shamt;
	output [2:0] func;
	output hlt, src1sel, re0, re1, we_rf;
	output [7:0] imm8;
	output we_mem, re_mem, wb_sel;
	
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
	localparam lwOp = 4'b1000;
	localparam swOp = 4'b1001;
	localparam lhbOp = 4'b1010;
	localparam llbOp = 4'b1011;
	localparam hltOp = 4'b1111;
	localparam bOp = 4'b1100;
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;

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
	assign dst_addr = 	(opcode == jalOp)		?	4'b1111:
													instr[11:8];
										
	assign p1_addr = (opcode == swOp)			?	instr[11:8]:
													instr[7:4];

	assign p0_addr = 	(opcode == lhbOp)					?	instr[11:8]: 
						(opcode == lwOp)||(opcode == swOp)	?   instr[7:4]:
						(opcode == jrOp)  					?	instr[7:4]:
																instr[3:0];

	assign imm8 = (opcode == lwOp)||(opcode == swOp)	?	({{4{instr[3]}},instr[3:0]}):
															instr[7:0];

	// Extract the shift amount.  For llb, we set shift to 0
	assign shamt =  (opcode == llbOp)	?	(4'b0000):
											instr[3:0];
	
	// Determine ALU control signals based on opcode
	assign func = 	((opcode == addOp)||(opcode == addzOp))	? 	add16:
					(opcode == subOp)						?	sub16:
					(opcode == andOp)						?	and16:
					(opcode == norOp)						?	nor16:
					((opcode == sllOp)||(opcode == llbOp))	? 	sll16:
					(opcode == srlOp)						?	srl16:
					(opcode == sraOp)						?	sra16:
					(opcode == lwOp) 						?   add16: // uses add because of immediate offset
					(opcode == swOp)						?   add16: // uses add because of immediate offset
					(opcode == lhbOp)						?	lhb16:
																3'bxxx;
	
	// Determine if the result will be written back to the register file.
	assign we_rf = 	((opcode == addzOp)&&(~Z))	?	1'b0:
					(opcode == bOp)				?	1'b0:
					(opcode == jrOp)			?	1'b0:
					(opcode == swOp)			?	1'b0:
													1'b1;
												
	assign re0 = 	(opcode == llbOp)	?	1'b0:
											1'b1;
											
	assign re1 =	(opcode == llbOp)	?	1'b0:
											1'b1;
	
	assign src1sel = 	((opcode == llbOp)||(opcode == lhbOp))	?	1'b0:
						((opcode == lwOp)||(opcode == swOp))  	?   1'b0:
																	1'b1;

	assign we_mem = (opcode == swOp)	?	1'b1:
											1'b0;

	assign re_mem = (opcode == lwOp)	?	1'b1:
											1'b0;

	assign wb_sel = (opcode == lwOp)	?   1'b0:
											1'b1;
										
endmodule