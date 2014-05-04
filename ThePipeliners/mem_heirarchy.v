module mem_heirarchy(
	// Inputs
	i_addr, d_addr, wrt_data, d_re, d_we, clk, rst_n,
	//Outputs
	instr, i_rdy, rd_data, d_rdy, stall
	);
	
	// Inputs
	input wire [15:0] i_addr, d_addr, wrt_data;
	input wire d_re, d_we, clk, rst_n;
	
	// Outputs
	output wire [15:0] instr, rd_data;
	output wire i_rdy, d_rdy, stall;
	
	wire [63:0] i_wr_data, u_wr_data, u_rd_data;
	wire [13:0] u_addr;
	wire u_rdy, u_re, i_we, u_we;
	
	cach_controller CC(
		// Inputs
		.clk(clk),
		.rst_n(rst_n),
		.i_rdy(i_rdy),
		.u_rdy(u_rdy),
		// Outputs
		.u_re(u_re),
		.i_we(i_we),
		.stall(stall)
		);
		
	cache IC(
		//Inputs
		.addr(i_addr[15:2]),
		.wr_data(i_wr_data),
		.we(i_we),
		.re(1'b1),
		.wdirty(1'b0),
		.clk(clk),
		.rst_n(rst_n),
		// Outputs
		.read_out(instr),
		.hit(i_rdy)
		);
		
	unified_mem U_MEM(
		//Inputs
		.clk(clk),
		.rst_n(rst_n),
		.re(u_re),
		.we(u_we),
		.addr(u_addr),
		.wdata(u_wr_data),
		//Outputs
		.rd_data(u_rd_data),
		.u_rdy(u_rdy)
		);
		
		assign u_addr = i_addr[15:2];
		
		
endmodule