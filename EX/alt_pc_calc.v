// alt_pc_calc module
// Author:  David Mateo
// This module is meant to calculate the alternate PC for program flow control
// instructions.  
module alt_pc_calc(instr, jump_reg, alt_pc);


	input [15:0] instr;
	input [15:0] jump_reg;

	wire [3:0] opcode;
	wire [8:0] br_offset;
	wire [11:0] jal_offset;

	localparam bOp = 4'b1100;
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;

	assign opcode = instr[15:12];
	assign br_offset = instr[8:0];
	assign jal_offset = instr[11:0];

	assign alt_pc = (opcode==bOp) 	? PC + 1'b1 + br_offset	 	:
					(opcode==jalOp) ? PC + 1'b1 + jal_offset 	:
					(opcode==jrOp)	? jump_reg					:
									  16'hxxxx;
endmodule