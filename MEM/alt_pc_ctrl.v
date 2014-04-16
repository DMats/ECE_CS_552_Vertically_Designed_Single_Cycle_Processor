// alt_pc_ctrl module
// Author:  David Mateo
// This module creates the alt_pc_ctrl signal that is fed back into the IF 
// stage.
module alt_pc_ctrl(opcode, br_cond);

	input [3:0] opcode;
	input [3:0] br_cond;
	input N, Z, V;

	output alt_pc_ctrl;

	// Relevant Opcodes
	localparam bOp = 4'b1100;
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;	

	// Branch condition codes
	localparam neq = 3'b000;
	localparam eq = 3'b001;
	localparam gt = 3'b010
	localparam lt = 3'b011;
	localparam gte = 3'b100;
	localparam lte = 3'b101;
	localparam ovfl = 3'b110;
	localparam uncond = 3'b111;

	assign br_ctrl 		= 	((opcode==bOp)							&&
							((br_cond==neq)&&(Z==1'b0)) 			|| 
							((br_cond==eq)&&(Z==1'b1))				||
							((br_cond==gt)&&(Z==1'b0)&&(N==1'b0))	||
							((br_cond==lt)&&(N==1'b1))				||
							((br_cond==gte)&&(N==1'b0))				||
							((br_cond==lte)&&(N==1'b1)&&(Z==1'b1))	||
							((br_cond==ovfl)&&(V==1'b1))			||
							((br_cond==uncond)))	?	instr[8:0]	:	
													9'hxxx;

	assign jr_ctrl 		= 	(opcode==jrOp);

	assign jalOp 		= 	(opcode==jalOp);

	assign alt_pc_ctrl 	= 	((br_ctrl)|(jal_ctrl)|(jr_ctrl));

endmodule
