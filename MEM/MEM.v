module MEM(we_mem, re_mem, sdata, alu_result, addr, ldata, clk);

input wire [15:0] sdata, addr;
input wire clk, rst_n, we_mem, re_mem;

output wire [15:0] ldata, alu_result;

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

assign alu_result = addr;

endmodule