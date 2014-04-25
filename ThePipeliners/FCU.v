// Forwarding Control Unit
// Author:  David Mateo
// This module creates the forwarding control signals.
module FCU(
	// Input
	EX_MEM_RegWrite, 
	EX_MEM_RegisterRd, 
	ID_EX_RegisterRs,
	ID_EX_RegisterRt,
	ID_EX_Opcode,
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

	forwarding_logic FL(
		// Input
		.EX_MEM_RegWrite(EX_MEM_RegWrite),
		.EX_MEM_RegisterRd(EX_MEM_RegisterRd),
		.ID_EX_RegisterRs(ID_EX_RegisterRs),
		.ID_EX_RegisterRt(ID_EX_RegisterRt),
		//.ID_EX_Opcode(ID_EX_Opcode),
		.MEM_WB_RegWrite(MEM_WB_RegWrite),
		.MEM_WB_RegisterRd(MEM_WB_RegisterRd),
		// Output
		.ForwardA(ForwardA),
		.ForwardB(ForwardB)
		);

endmodule
