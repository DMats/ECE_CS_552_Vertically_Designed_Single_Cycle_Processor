module cpu(hlt, pc, clk, rst_n);

input clk, rst_n;
output hlt, pc;

/************************ IF *************************************************/

// IF stage wires
wire [15:0] instr_IF_ID_EX;
wire [15:0] pc_IF_ID_EX, alt_pc_IF;
wire alt_pc_ctrl_IF;
wire rst_n_IF_ID, stall_or_hlt_IF_ID;


// Instantiate IF
IF instruction_fetch(	
	// Output
	.instr(instr_IF_ID_EX),
	.pc_plus_1(pc_IF_ID_EX),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.hlt(hlt_ID_EX_MEM_WB),
	.alt_pc_ctrl(alt_pc_ctrl_IF),
	.alt_pc(alt_pc_IF)
	);
	
	assign alt_pc_ctrl_IF = (j_ctrl_ID || b_ctrl_EX_MEM);
	assign alt_pc_IF = 	(j_ctrl_ID) ? j_pc_ID:
						(b_ctrl_EX_MEM) ? b_pc_EX:
										16'hxxxx;

	assign pc = pc_ID_EX;
	assign hlt = hlt_WB;
	
/************************ IF *************************************************/
	
	
	
	
// IF_ID Flip Flop ////////////////////////////////////////////////////////////
IF_ID_FF IF_ID(
	// Output
	.instr_ID(instr_ID_EX),
	.pc_ID(pc_ID_EX),
	// Inputs
	.instr_IF(instr_IF_ID_EX),
	.pc_IF(pc_IF_ID_EX),
	.clk(clk),
	.rst_n(rst_n_IF_ID),
	.stall(stall_or_hlt_IF_ID)
	);
	
	assign rst_n_IF_ID = (~b_ctrl_EX_MEM & rst_n) ? 1'b1 : 1'b0;
	assign stall_or_hlt_IF_ID = stall_IF_ID | hlt_EX_MEM_WB;
///////////////////////////////////////////////////////////////////////////////




/************************ ID *************************************************/

// ID stage wires
wire [15:0] instr_ID_EX;
wire [15:0]pc_ID_EX, j_pc_ID;
wire [15:0] p0_ID_EX, p1_ID_EX;
wire [7:0] imm8_ID_EX;
wire [3:0] shamt_ID_EX, dst_addr_ID_EX_MEM_WB;
wire [2:0] func_ID_EX;
wire we_mem_ID_EX_MEM, re_mem_ID_EX_MEM, wb_sel_ID_EX_MEM_WB, src1sel_ID_EX,
	we_rf_ID_EX_MEM_WB, j_ctrl_ID, hlt_ID_EX_MEM_WB, stall_or_hlt_ID_EX;

// Instantiate ID
ID instruction_decode(	
	// Output
	.p0(p0_ID_EX),
	.p1(p1_ID_EX),
	.shamt(shamt_ID_EX),
	.func(func_ID_EX),
	.src1sel(src1sel_ID_EX),
	.hlt(hlt_ID_EX_MEM_WB),
	.imm8(imm8_ID_EX),
	.we_rf(we_rf_ID_EX_MEM_WB),
	.we_mem(we_mem_ID_EX_MEM),
	.re_mem(re_mem_ID_EX_MEM),
	.wb_sel(wb_sel_ID_EX_MEM_WB),
	.dst_addr_new(dst_addr_ID_EX_MEM_WB),
	.j_pc(j_pc_ID),
	.j_ctrl(j_ctrl_ID),
	// Input
	.instr(instr_ID_EX),
	.pc(pc_ID_EX),
	.clk(clk),
	.rst_n(rst_n),
	.dst_data_WB(wb_data_WB),
	.dst_addr_WB(dst_addr_WB),
	.we_WB(we_rf_WB),
	.hlt_WB(hlt_WB)
	);
	
/************************ ID *************************************************/
	
	
	
// ID_EX Flip Flop ////////////////////////////////////////////////////////////
ID_EX_FF ID_EX(
	// Output
	.p0_EX(p0_EX),
	.p1_EX(p1_EX),
	.shamt_EX(shamt_EX),
	.func_EX(func_EX),
	.imm8_EX(imm8_EX),
	.we_rf_EX(we_rf_EX_MEM_WB),
	.we_mem_EX(we_mem_EX_MEM),
	.re_mem_EX(re_mem_EX_MEM),
	.wb_sel_EX(wb_sel_EX_MEM_WB),
	.dst_addr_EX(dst_addr_EX_MEM_WB),
	.src1sel_EX(src1sel_EX),
	.instr_EX(instr_EX),
	.hlt_EX(hlt_EX_MEM_WB),
	.pc_EX(pc_EX),
	// Input
	.p0_ID(p0_ID_EX),
	.p1_ID(p1_ID_EX),
	.shamt_ID(shamt_ID_EX),
	.func_ID(func_ID_EX),
	.imm8_ID(imm8_ID_EX),
	.we_rf_ID(we_rf_ID_EX_MEM_WB),
	.we_mem_ID(we_mem_ID_EX_MEM),
	.re_mem_ID(re_mem_ID_EX_MEM),
	.wb_sel_ID(wb_sel_ID_EX_MEM_WB),
	.dst_addr_ID(dst_addr_ID_EX_MEM_WB),
	.src1sel_ID(src1sel_ID_EX),
	.pc_ID(pc_ID_EX),
	.instr_ID(instr_ID_EX),
	.hlt_ID(hlt_ID_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_ID_EX)
	);

	assign stall_or_hlt_ID_EX = stall_ID_EX | hlt_EX_MEM_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ EX *************************************************/

// EX stage wires
wire [15:0] p0_EX, p1_EX, jump_reg_EX, instr_EX, pc_EX, b_pc_EX, sdata_EX_MEM, alu_result_EX_MEM_WB;
wire [7:0] imm8_EX;
wire [3:0] shamt_EX, dst_addr_EX_MEM_WB;
wire [2:0] func_EX;
wire src1sel_EX, we_mem_EX_MEM, re_mem_EX_MEM, wb_sel_EX_MEM_WB, we_rf_EX_MEM_WB;
wire N_EX, Z_EX, V_EX, b_ctrl_EX_MEM;
wire we_rf_EX_MEM_WB_mux, hlt_EX_MEM_WB, stall_or_hlt_EX_MEM;

localparam addzOp = 4'b0001;

// Instantiate EX
EX execution(
	// Output
	.dst(alu_result_EX_MEM_WB),
	.N(N_EX),
	.Z(Z_EX),
	.V(V_EX),
	.br_pc(b_pc_EX),
	.br_ctrl(b_ctrl_EX_MEM),
	.sdata(sdata_EX_MEM),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.pc(pc_EX),
	.func(func_EX),
	.shamt(shamt_EX),
	.src1sel(src1sel_EX),
	.p0(p0_EX),
	.imm8(imm8_EX),
	.p1(p1_EX),
	.instr(instr_EX),
	.alu_result_MEM_WB(alu_result_MEM_WB),
	.wb_data_WB(wb_data_WB),
	.prev_br_ctrl(b_ctrl_MEM),
	.forwardA(forwardA),
	.forwardB(forwardB)
	);

assign we_rf_EX_MEM_WB_mux = ((instr_EX[15:12] == addzOp)&&(~Z_EX))	? 1'b0 : we_rf_EX_MEM_WB;

/************************ EX *************************************************/


	
// EX_MEM Flip Flop ///////////////////////////////////////////////////////////
EX_MEM_FF EX_MEM(
	// Outputs
	.sdata_MEM(sdata_MEM),
	.we_rf_MEM(we_rf_MEM_WB),
	.we_mem_MEM(we_mem_MEM),
	.re_mem_MEM(re_mem_MEM),
	.alu_result_MEM(alu_result_MEM_WB),
	.wb_sel_MEM(wb_sel_MEM_WB),
	.dst_addr_MEM(dst_addr_MEM_WB),
	.b_ctrl_MEM(b_ctrl_MEM),
	.hlt_MEM(hlt_MEM_WB),
	//Inputs
	.sdata_EX(sdata_EX_MEM),
	.we_rf_EX(we_rf_EX_MEM_WB_mux),
	.we_mem_EX(we_mem_EX_MEM),
	.re_mem_EX(re_mem_EX_MEM),
	.alu_result_EX(alu_result_EX_MEM_WB),
	.wb_sel_EX(wb_sel_EX_MEM_WB),
	.dst_addr_EX(dst_addr_EX_MEM_WB),
	.b_ctrl_EX(b_ctrl_EX_MEM),
	.hlt_EX(hlt_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_EX_MEM)
	);

	assign stall_or_hlt_EX_MEM = stall_EX_MEM | hlt_MEM_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ MEM *************************************************/

// MEM stage wires
wire wb_sel_MEM_WB, we_rf_MEM_WB, we_mem_MEM, re_mem_MEM, b_ctrl_MEM, stall_or_hlt_MEM_WB, hlt_MEM_WB;
wire [15:0] alu_result_MEM_WB, sdata_MEM, ldata_MEM_WB, addr_mem_MEM;
wire [3:0] dst_addr_MEM_WB;

MEM memory(
	// Output
	.ldata(ldata_MEM_WB),
	// Input
	.sdata(sdata_MEM),
	.re_mem(re_mem_MEM),
	.we_mem(we_mem_MEM),
	.clk(clk),
	.addr(addr_mem_MEM)
	);
	
assign addr_mem_MEM = alu_result_MEM_WB;
	
/************************ MEM *************************************************/



// MEM_WB Flip Flop ///////////////////////////////////////////////////////////
MEM_WB_FF MEM_WB(
	// Outputs
	.ldata_WB(ldata_WB),
	.alu_result_WB(alu_result_WB),
	.we_rf_WB(we_rf_WB),
	.wb_sel_WB(wb_sel_WB),
	.dst_addr_WB(dst_addr_WB),
	.hlt_WB(hlt_WB),
	// Inputs
	.ldata_MEM(ldata_MEM_WB),
	.alu_result_MEM(alu_result_MEM_WB),
	.we_rf_MEM(we_rf_MEM_WB),
	.wb_sel_MEM(wb_sel_MEM_WB),
	.dst_addr_MEM(dst_addr_MEM_WB),
	.hlt_MEM(hlt_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_MEM_WB)
	);

	assign stall_or_hlt_MEM_WB = stall_MEM_WB | hlt_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ WB *************************************************/
wire [15:0] wb_data_WB, alu_result_WB, ldata_WB;
wire we_rf_WB, wb_sel_WB, hlt_WB;
wire [3:0] dst_addr_WB;

WB write_back(
	// Output
	.wb_data(wb_data_WB),
	// Input
	.wb_sel(wb_sel_WB),
	.rd_data(ldata_WB),
	.alu_result(alu_result_WB)
	);
	
/************************ WB *************************************************/

// FCU ////////////////////////////////////////////////////////////////////////
wire [1:0] forwardA, forwardB;

FCU forwarding_control_unit(
	// Output
	.ForwardA(forwardA),
	.ForwardB(forwardB),
	// Input
	.EX_MEM_RegWrite(we_rf_MEM_WB), 
	.EX_MEM_RegisterRd(dst_addr_MEM_WB), 
	.ID_EX_RegisterRs(instr_EX[7:4]),
	.ID_EX_RegisterRt(instr_EX[3:0]),
	.MEM_WB_RegWrite(we_rf_WB),
	.MEM_WB_RegisterRd(dst_addr_WB)
	);
///////////////////////////////////////////////////////////////////////////////

// HDU ////////////////////////////////////////////////////////////////////////
wire stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB;

HDU hazard_detection_unit(
	// Output
	.stall_IF_ID(stall_IF_ID),
	.stall_ID_EX(stall_ID_EX),
	.stall_EX_MEM(stall_EX_MEM),
	.stall_MEM_WB(stall_MEM_WB),
	// Input
	.clk(clk), 
	.rst_n(rst_n), 
	.instr(instr_ID_EX) 
	);
///////////////////////////////////////////////////////////////////////////////

endmodule
