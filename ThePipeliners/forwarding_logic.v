// Forwarding Logic
// Author:  David Mateo
// This module generates the forwarding control signals.
// The logic here was taken from pages 366 and 389 of the book:
// "Computer Organization and Design" by Patterson and Hennessy
module forwarding_logic(
	// Input
	EX_MEM_RegWrite, 
	EX_MEM_RegisterRd, 
	ID_EX_RegisterRs,
	ID_EX_RegisterRt,
	//ID_EX_Opcode,
	MEM_WB_RegWrite,
	MEM_WB_RegisterRd,
	// Output
	ForwardA,
	ForwardB
	);

	input EX_MEM_RegWrite, MEM_WB_RegWrite;
	input [3:0] EX_MEM_RegisterRd;
	input [3:0] ID_EX_RegisterRs;
	input [3:0] ID_EX_RegisterRt;
	input [3:0] MEM_WB_RegisterRd;

	input [3:0] ID_EX_Opcode;

	output [1:0] ForwardA, ForwardB;

	/*
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

	assign two_sources 	= 	((ID_EX_Opcode==addOp) 	||
							(ID_EX_Opcode==addzOp)	||
							(ID_EX_Opcode==subOp) 	||
							(ID_EX_Opcode==andOp)	||
							(ID_EX_Opcode==norOp));
	assign one_source	= 	((ID_EX_Opcode==sllOp)	||
							(ID_EX_Opcode==srlOp)	||
							(ID_EX_Opcode==sraOp)	||
							(ID_EX_Opcode==lwOp));
	assign jump_reg_source = (ID_EX_Opcode==jrOp);


	// ForwardA controls the mux for src1, p1, muxA, Rs
	assign ForwardA = 	((two_sources||one_source)	&&
						(EX_MEM_RegWrite) 							&& 
						(EX_MEM_RegisterRd != 4'h0) 				&& 
						(EX_MEM_RegisterRd == ID_EX_RegisterRs)) 	? 	2'b10:
						((two_sources||one_source||jump_reg_source)	&&
						(MEM_WB_RegWrite)							&&
						(MEM_WB_RegisterRd != 4'h0)					&&
						(!((two_sources||one_source)				&&
						EX_MEM_RegWrite 							&&
						(EX_MEM_RegisterRd != 4'b0)					&&
						(EX_MEM_RegisterRd != ID_EX_RegisterRs)))	&&
						(MEM_WB_RegisterRd == ID_EX_RegisterRs))	?	2'b01:
																		2'b00;

	// ForwardB controls the mux for src0, p0, muxB, Rt
	assign ForwardB =	(((two_sources)								&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRt))	||
						(jump_reg_source)							&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRs))	?	2'b10:
						(((two_sources)								&&
						(MEM_WB_RegWrite)							&&
						(MEM_WB_RegisterRd != 4'h0)					&&
						(!(((two_sources)							&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRt))	||
						((jump_reg_source)							&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRs))))	&&
						(MEM_WB_RegisterRd == ID_EX_RegisterRt))	||
						((jump_reg_source)							&&
						(MEM_WB_RegWrite)							&&
						(MEM_WB_RegisterRd != 4'h0)					&&
						(!(((two_sources)							&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRt))	||
						((jump_reg_source)							&&
						(EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRs))))	&&
						(MEM_WB_RegisterRd == ID_EX_RegisterRs)))	?	2'b01:
																		2'b00;*/


endmodule

