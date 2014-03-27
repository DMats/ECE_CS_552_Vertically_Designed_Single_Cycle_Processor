`include "IF/IF.v"
`include "ID/ID.v"
`include "EX/EX.v"

module cpu(hlt, clk, rst_n);

input clk, rst_n;
output hlt;


wire [15:0] instr_lcl, dst_lcl, src0_lcl, p1_lcl, alt_pc_lcl, pc_lcl,sdata_lcl, ldata_lcl, alu_result_lcl, wb_data_lcl;
wire [8:0] br_offset;
wire [3:0] shamt_lcl;
wire [2:0] func_lcl;
wire hlt_lcl, src1sel_lcl, alt_pc_ctrl;
wire N_lcl, Z_lcl, V_lcl;
wire we_mem_lcl, re_mem_lcl, wb_sel_lcl;
wire [7:0] imm8_lcl;

// Instantiate IF
IF instruction_fetch(	
	// Output
	.instr(instr_lcl),
	.pc(pc_lcl),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.hlt(hlt_lcl),
	.alt_pc_ctrl(alt_pc_ctrl),
	.alt_pc(alt_pc_lcl)
	);

// Instantiate ID
ID instruction_decode(	
	// Output
	.p0(src0_lcl),
	.p1(p1_lcl),
	.shamt(shamt_lcl),
	.func(func_lcl),
	.src1sel(src1sel_lcl),
	.hlt(hlt_lcl),
	.alt_pc_ctrl(alt_pc_ctrl),
	.alt_pc(alt_pc_lcl),
	.imm8(imm8_lcl),
	.we_mem(we_mem_lcl),
	.re_mem(re_mem_lcl),
	.wb_sel(wb_sel_lcl),
	// Input
	.instr(instr_lcl),
	.pc(pc_lcl),
	.clk(clk),
	.rst_n(rst_n),
	.N(N_lcl),
	.Z(Z_lcl),
	.V(V_lcl),
	.dst(dst_lcl)
	);

// Instantiate EX
EX execution(
	// Output
	.dst(dst_lcl),
	.N(N_lcl),
	.Z(Z_lcl),
	.V(V_lcl),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.func(func_lcl),
	.shamt(shamt_lcl),
	.src1sel(src1sel_lcl),
	.src0(src0_lcl),
	.imm8(imm8_lcl),
	.p1(p1_lcl)
	);

MEM memory(
	// Output
	.ldata(ldata_lcl),
	.alu_result(alu_result_lcl),
	// Input
	.sdata(sdata_lcl),
	.re_mem(re_mem_lcl),
	.we_mem(we_mem_lcl),
	.clk(clk),
	.addr(dst_lcl)
	);

WB write_back(
	// Output
	.wb_data(wb_data_lcl),
	// Input
	.wb_sel(wb_sel_lcl),
	.rd_data(ldata_lcl),
	.alu_result(alu_result_lcl)
	);

assign hlt = hlt_lcl;

endmodule