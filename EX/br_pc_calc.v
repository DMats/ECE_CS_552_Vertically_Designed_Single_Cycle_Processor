// br_pc_calc module
// Author:  David Mateo
// This module is meant to calculate the alternate pc for branch instructions.
module br_pc_calc(instr, pc, br_pc);


	input [15:0] instr;
	input [15:0] pc;

	wire [3:0] opcode;
	wire [8:0] br_offset;

	// Relevant Opcodes
	localparam bOp = 4'b1100;

	assign opcode = instr[15:12];
	assign br_offset = instr[8:0];

	assign br_pc = (opcode==bOp) 	? pc + 1'b1 + br_offset :
									16'hxxxx;
endmodule