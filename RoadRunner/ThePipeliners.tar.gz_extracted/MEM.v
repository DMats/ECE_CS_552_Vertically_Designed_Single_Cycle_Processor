module MEM(we_mem, re_mem, sdata, addr, ldata, clk);

input wire [15:0] sdata, addr;
input wire clk, we_mem, re_mem;

output wire [15:0] ldata;

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

endmodule
