module cpu(hlt, clk, rst_n);

input clk, rst_n;
output hlt;


wire [15:0] instr_lcl, dst_lcl, src0_lcl, p1_lcl, alt_pc_lcl, pc_lcl,sdata_lcl, ldata_lcl, alu_result_lcl, wb_data_lcl;

// IF output flop wires
wire [15:0] instr_IF_ID;
wire [15:0] pc_IF_ID;

// ID input flop wires
wire [15:0] instr_ID;
wire [15:0]pc_ID;
// ID output flop wires
wire [15:0] p0_ID_EX, p1_ID_EX;
wire [7:0] imm8_ID_EX;
wire [3:0] shamt_ID_EX;
wire [2:0] func_ID_EX;
wire we_mem_ID_EX_MEM, re_mem_ID_EX_MEM, wb_sel_ID_EX_MEM_WB, src1sel_ID_EX;


wire [8:0] br_offset;
wire [3:0] shamt_lcl;
wire [2:0] func_lcl;
wire hlt_lcl, src1sel_lcl, alt_pc_ctrl;
wire N_lcl, Z_lcl, V_lcl;
wire we_mem_lcl, re_mem_lcl, wb_sel_lcl;
wire [7:0] imm8_lcl;

// 

// Instantiate IF
IF instruction_fetch(	
	// Output
	.instr(instr_IF_ID),
	.pc(pc_IF_ID),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.hlt(hlt_IF),
	.alt_pc_ctrl(alt_pc_ctrl_IF),
	.alt_pc(alt_pc_IF)
	);
	
// IF_ID Flip Flop ////////////////////////////////////////////////////////////
IF_ID IF_ID_FF(
	// Output
	.instr_ID(instr_ID),
	.pc_ID(pc_ID),
	// Inputs
	.instr_IF(instr_IF_ID),
	.pc_IF(pc_IF_ID),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall)
	);
///////////////////////////////////////////////////////////////////////////////

// Instantiate ID
ID instruction_decode(	
	// Output
	.p0(p0_ID_EX),
	.p1(p1_ID_EX),
	.shamt(shamt_ID_EX),
	.func(func_ID_EX),
	.src1sel(src1sel_ID_EX),
	.hlt(hlt_lcl),
	.alt_pc_ctrl(alt_pc_ctrl),
	.alt_pc(alt_pc_lcl),
	.imm8(imm8_ID_EX),
	.we_mem(we_mem_ID_EX_MEM),
	.re_mem(re_mem_ID_EX_MEM),
	.wb_sel(wb_sel_ID_EX_MEM_WB),
	// Input
	.instr(instr_ID),
	.pc(pc_ID),
	.clk(clk),
	.rst_n(rst_n),
	.N(N_lcl),
	.Z(Z_lcl),
	.V(V_lcl),
	.dst(wb_data_lcl)
	);
	
// ID_EX Flip Flop ////////////////////////////////////////////////////////////
ID_EX ID_EX_FF(
	// Output
	.p0_EX(p0_EX),
	.p1_EX(p1_EX),
	.shamt_EX(shamt_EX),
	.func_EX(func_EX),
	.imm8_EX(imm8_EX),
	.we_mem_EX(we_mem_EX_MEM),
	.re_mem_EX(re_mem_EX_MEM),
	.wb_sel_EX(wb_sel_EX_MEM),
	// Input
	.p0_ID(p0_ID_EX),
	.p1_ID(p1_ID_EX),
	.shamt_ID(shamt_ID_EX),
	.func_ID(func_ID_EX),
	.imm8_ID(imm8_ID_EX),
	.we_mem_ID(we_mem_ID_EX),
	.re_mem_ID(re_mem_ID_EX),
	.wb_sel_ID(wb_sel_ID_EX),
	.src1sel_ID(src1sel_ID_EX),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall)
	);
///////////////////////////////////////////////////////////////////////////////

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
assign sdata_lcl = p1_lcl;

endmodule