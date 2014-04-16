module MEM(we_mem, re_mem, sdata, alu_result, addr, ldata, clk, instr_15_9, N, Z, V, alt_pc_ctrl);

input wire [15:0] sdata, addr;
input wire clk, rst_n, we_mem, re_mem;
input wire [6:0] instr_15_9;

output wire [15:0] ldata, alu_result;
output wire alt_pc_ctrl;

DM data_memory(
	// Output
	.rd_data(ldata),
	// Input
	.wrt_data(sdata),
	.addr(addr),
	.clk(clk),
	.re(re_mem),
	.we(we_mem)
	);

alt_pc_ctrl APC(
	// Input
	.opcode(instr_15_9[6:3]),
	.br_cond(instr_15_9[2:0]),
	.N(N),
	.Z(Z),
	.V(V),
	// Output
	.alt_pc_ctrl(alt_pc_ctrl)
	);

assign alu_result = addr;

endmodule