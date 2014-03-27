// Author: R Scott Carson
// Instruction Decode Architecture
// CS/ECE 552, Spring 2014

module I_DECODE(
	//Inputs
	instr, N, Z, V, PC, jump_reg, 
	//Outputs
	alt_pc, alt_pc_ctrl, jal_pc, p0_addr, re0, p1_addr, re1, dst_addr, we, hlt, src1sel, shamt, func, imm8, we_mem, re_mem, wb_sel);

	// Inputs
	input[15:0] instr, PC, jump_reg;
	input N, Z, V;

	// Outputs
	output [3:0] p0_addr, p1_addr, dst_addr, shamt;
	output [2:0] func;
	output hlt, src1sel, re0, re1, we, alt_pc_ctrl;
	output [15:0] alt_pc, jal_pc;
	output [7:0] imm8;
	output we_mem, re_mem, wb_sel;
	
	wire [8:0] br_offset;
	wire [3:0] opcode, reg_dest, reg_src1, reg_src0;
	wire [2:0] br_cond;
	wire br_ctrl, jal_ctrl, jr_ctrl;

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
	
	// Branch condition codes
	localparam neq = 3'b000;
	localparam eq = 3'b001;
	localparam gt = 3'b010;
	localparam lt = 3'b011;
	localparam gte = 3'b100;
	localparam lte = 3'b101;
	localparam ovfl = 3'b110;
	localparam uncond = 3'b111;

	// Determine opcode and corresponding signals
	assign opcode = instr[15:12];

	// Halt Case //
	assign hlt = 	(opcode == hltOp)	?	(1'b1):
											(1'b0);
											
	// Branch case // 
	assign br_cond = instr[11:9];
	assign br_ctrl = (opcode==bOp)	?	1'b1	:	1'b0;
	assign br_offset = 	((br_ctrl)								&&
						((br_cond==neq)&&(Z==1'b0)) 			|| 
						((br_cond==eq)&&(Z==1'b1))				||
						((br_cond==gt)&&(Z==1'b0)&&(N==1'b0))	||
						((br_cond==lt)&&(N==1'b1))				||
						((br_cond==gte)&&(N==1'b0))				||
						((br_cond==lte)&&(N==1'b1)&&(Z==1'b1))	||
						((br_cond==ovfl)&&(V==1'b1))			||
						((br_cond==uncond)))	?	instr[8:0]	:	
													9'hxxx;
													
	// Jump and Link Register //
	assign jal_ctrl = (opcode==jalOp)	?	1'b1	:	1'b0;
	
	// Jump from Register // 
	assign jr_ctrl = (opcode==jrOp)	?	1'b1	:	1'b0;
	
	// Assign alternate program counter if required // 
	assign alt_pc = (br_ctrl)	?	PC + 1'b1 + br_offset	:
					(jal_ctrl)	?	PC + 1'b1 + jal_offset	:
					(jr_ctrl)	?	jump_reg:
									16'hxxxx;
									
	assign alt_pc_ctrl = ((br_ctrl)|(jal_ctrl)|(jr_ctrl));

	// Pull down hlt to prevent cyclic dependency between ID and PC
	//pulldown(hlt);

	// Extract all needed signals and then MUX them to output proper controls
	assign dst_addr = 	(jal_ctrl)				?	4'b1111:
													instr[11:8];
										
	assign p1_addr = (opcode == swOp)			?	instr[11:8]:
													instr[7:4];

	assign p0_addr = 	(opcode == lhbOp)					?	instr[11:8]: 
						(opcode == lwOp)||(opcode == swOp)	?   instr[7:4]:
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
	assign we = ((opcode == addzOp)&&(~Z))	?	1'b0:
				(br_ctrl)					?	1'b0:
				(jr_ctrl)					?	1'b0:
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