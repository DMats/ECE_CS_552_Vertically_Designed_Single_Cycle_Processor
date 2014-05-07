module mem_heirarchy(
	// Inputs
	i_addr, d_addr, wrt_data, extern_d_re, extern_d_we, clk, rst_n,
	//Outputs
	instr, i_rdy, d_rd_data, d_rdy
	);
	
	// Inputs
	input wire [15:0] i_addr, d_addr, wrt_data;
	input wire extern_d_re, extern_d_we, clk, rst_n;
	
	// Outputs
	output wire [15:0] instr, d_rd_data;
	output wire i_rdy, d_rdy;
	
	wire [63:0] i_wr_data, u_wr_data, u_rd_data, i_cache_line, updated_d_line, d_data, d_cache_line;
	wire [13:0] u_addr, d_constr_addr;
	wire [7:0] i_tag, d_tag;
	wire [1:0] i_offset, d_offset;
	wire u_rdy, u_re, i_we, u_we, dcache_w_sel, addr_sel, d_we_mux, d_re_mux, 
		d_re, d_we, set_dirty, evict, d_dirty;
	
	cache_controller CC(
		// Inputs
		.clk(clk),
		.rst_n(rst_n),
		.i_rdy(i_rdy),
		.u_rdy(u_rdy),
		.d_rdy(d_rdy),
		.data_re(extern_d_re),
		.data_we(extern_d_we),
		.dirty(d_dirty),
		// Outputs
		.u_re(u_re),
		.i_we(i_we),
		.d_we(d_we),
		.d_re(d_re),
		.addr_sel(addr_sel),
		.evict(evict),
		.d_set_dirty(set_dirty)
		);
		
	cache IC(
		//Inputs
		.addr(i_addr[15:2]),
		.wr_data(u_rd_data),
		.we(i_we),
		.re(1'b1),
		.wdirty(1'b0),
		.clk(clk),
		.rst_n(rst_n),
		// Outputs
		.rd_data(i_cache_line),
		.tag_out(i_tag),
		.hit(i_rdy)
		);
		
	assign i_offset = i_addr[1:0];	
	assign instr = 	(i_offset == 2'b00)	?	i_cache_line[15:0]:
					(i_offset == 2'b01)	?	i_cache_line[31:16]:
					(i_offset == 2'b10)	?	i_cache_line[47:32]:
					(i_offset == 2'b11)	?	i_cache_line[63:48]:
												16'hxxxx;
		
	cache DC(
		//Inputs
		.addr(d_addr[15:2]),
		.wr_data(d_data),
		.we(d_we_mux),
		.re(d_re_mux),
		.wdirty(write_dirty),
		.clk(clk),
		.rst_n(rst_n),
		// Outputs
		.rd_data(d_cache_line),
		.tag_out(d_tag),
		.hit(d_rdy),
		.dirty(d_dirty)
		);
		
	assign d_we_mux = (d_rdy) ? extern_d_we : d_we;
	assign d_re_mux = (d_rdy) ? extern_d_re : d_re;
	
	assign updated_d_line = (d_offset == 2'b00)	?	{d_cache_line[63:16], wrt_data}: 
							(d_offset == 2'b01)	?	{d_cache_line[63:32], wrt_data, d_cache_line[15:0]}:
							(d_offset == 2'b10)	?	{d_cache_line[63:48], wrt_data, d_cache_line[31:0]}:
							(d_offset == 2'b11)	?	{wrt_data, d_cache_line[47:0]}:
													64'hxxxx_xxxx_xxxx_xxxx;
		
	assign d_data = (d_rdy) ? updated_d_line : u_rd_data;
		
	assign d_offset = d_addr[1:0];	
	assign d_rd_data = 	(d_offset == 2'b00)	?	d_cache_line[15:0]:
						(d_offset == 2'b01)	?	d_cache_line[31:16]:
						(d_offset == 2'b10)	?	d_cache_line[47:32]:
						(d_offset == 2'b11)	?	d_cache_line[63:48]:
												16'hxxxx;
	assign d_constr_addr = (evict) ? {d_tag, d_addr[7:2]} : d_addr[15:2];
		
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
		.rdy(u_rdy)
		);
		
	assign u_wr_data = d_cache_line;
		
	assign u_addr = (addr_sel) ? d_constr_addr[15:2] : i_addr[15:2];
		
		
endmodule