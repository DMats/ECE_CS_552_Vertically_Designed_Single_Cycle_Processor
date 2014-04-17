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

	output [1:0] ForwardA, ForwardB;

	// ForwardA controls the mux for src1
	assign ForwardA = 	((EX_MEM_RegWrite) 							&& 
						(EX_MEM_RegisterRd != 4'h0) 				&& 
						(EX_MEM_RegisterRd == ID_EX_RegisterRs)) 	? 	2'b10:
						((MEM_WB_RegWrite)							&&
						(MEM_WB_RegisterRd != 4'h0)					&&
						(!(EX_MEM_RegWrite 							&&
						(EX_MEM_RegisterRd != 4'b0)					&&
						(EX_MEM_RegisterRd != ID_EX_RegisterRs)))	&&
						(MEM_WB_RegisterRd == ID_EX_RegisterRs))	?	2'b01:
																		2'b00;

	// ForwardB controls the mux for src0
	assign ForwardB =	((EX_MEM_RegWrite)							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd == ID_EX_RegisterRt))	?	2'b10:
						((MEM_WB_RegWrite)							&&
						(MEM_WB_RegisterRd != 4'h0)					&&
						(!(EX_MEM_RegWrite							&&
						(EX_MEM_RegisterRd != 4'h0)					&&
						(EX_MEM_RegisterRd != ID_EX_RegisterRt)))	&&
						(MEM_WB_RegisterRd == ID_EX_RegisterRt))	?	2'b01:
																		2'b00;


endmodule

