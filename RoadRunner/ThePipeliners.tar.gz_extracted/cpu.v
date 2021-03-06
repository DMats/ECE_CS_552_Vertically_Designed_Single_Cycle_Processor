module cpu(hlt, pc, clk, rst_n);

// Inputs and Outputs
input clk, rst_n;
output hlt;
output [15:0] pc;

// IF stage wires
wire [15:0] instr_IF_ID_EX;
wire [15:0] pc_IF_ID_EX_MEM_WB, alt_pc_IF, pc_IF;
wire alt_pc_ctrl_IF;
wire flush_IF_ID, stall_or_hlt_IF_ID;

// ID stage wires
wire [15:0] instr_ID_EX;
wire [15:0] pc_ID_EX_MEM_WB, j_pc_ID;
wire [15:0] p0_ID_EX, p1_ID_EX;
wire [7:0] imm8_ID_EX;
wire [3:0] shamt_ID_EX, dst_addr_ID_EX_MEM_WB, p0_addr_ID_EX, p1_addr_ID_EX;
wire [2:0] func_ID_EX;
wire we_mem_ID_EX_MEM, re_mem_ID_EX_MEM, wb_sel_ID_EX_MEM_WB, src1sel_ID_EX,
	we_rf_ID_EX_MEM_WB, j_ctrl_ID_EX_MEM_WB, hlt_ID_EX_MEM_WB, stall_or_hlt_ID_EX, 
	hlt_ID_EX_MEM_WB_CTRL, flush_ID_EX, prev_stall_IF_ID, prev_flush_IF_ID;

// EX stage wires
wire [15:0] p0_EX, p1_EX, jump_reg_EX, instr_EX, b_pc_EX, sdata_EX_MEM, 
	alu_result_EX_MEM_WB, pc_EX_MEM_WB;
wire [7:0] imm8_EX;
wire [3:0] shamt_EX, dst_addr_EX_MEM_WB, p0_addr_EX, p1_addr_EX;
wire [2:0] func_EX;
wire src1sel_EX, we_mem_EX_MEM, re_mem_EX_MEM, wb_sel_EX_MEM_WB, we_rf_EX_MEM_WB;
wire N_EX, Z_EX, V_EX, b_ctrl_EX_MEM, j_ctrl_EX_MEM_WB;
wire we_rf_EX_MEM_WB_mux, hlt_EX_MEM_WB, stall_or_hlt_EX_MEM;
wire [15:0] alu_result_EX_MEM_WB_lcl;

localparam addzOp = 4'b0001;

// MEM stage wires
wire wb_sel_MEM_WB, we_rf_MEM_WB, we_mem_MEM, re_mem_MEM, b_ctrl_MEM, j_ctrl_MEM_WB, stall_or_hlt_MEM_WB, hlt_MEM_WB;
wire [15:0] alu_result_MEM_WB, sdata_MEM, ldata_MEM_WB, addr_mem_MEM, pc_MEM_WB;
wire [3:0] dst_addr_MEM_WB;

// WB stage wires
wire [15:0] wb_data_WB, alu_result_WB, ldata_WB, pc_WB;
wire we_rf_WB, wb_sel_WB, hlt_WB;
wire [3:0] dst_addr_WB;

// FCU Wires
wire [1:0] forwardA, forwardB;

// HDU wires
wire stall_PC, stall_IF_ID, stall_ID_EX, stall_EX_MEM, stall_MEM_WB, d_access_stall;

// Mem Heirarchy wires
wire i_rdy_CC, d_rdy_CC;


// Assign top level outputs!
assign pc = pc_WB;
assign hlt = hlt_WB;

/************************ IF *************************************************/




// Instantiate IF
IF instruction_fetch(	
	// Output
	.iaddr(pc_IF),
	.pc_plus_1(pc_IF_ID_EX_MEM_WB),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.hlt(hlt_ID_EX_MEM_WB),
	.alt_pc_ctrl(alt_pc_ctrl_IF),
	.alt_pc(alt_pc_IF),
	.stall(stall_PC)
	);
	
	assign alt_pc_ctrl_IF = (j_ctrl_ID_EX_MEM_WB | b_ctrl_EX_MEM);
	assign alt_pc_IF = 	(j_ctrl_ID_EX_MEM_WB) 	? 	j_pc_ID	:
						(b_ctrl_EX_MEM) 		? 	b_pc_EX	:
													16'hxxxx;
	
/************************ IF *************************************************/
	
	
	
	
// IF_ID Flip Flop ////////////////////////////////////////////////////////////
IF_ID_FF IF_ID(
	// Output
	.instr_ID(instr_ID_EX),
	.pc_ID(pc_ID_EX_MEM_WB),
	.prev_stall_ID(prev_stall_IF_ID),
	.prev_flush_ID(prev_flush_IF_ID),
	// Inputs
	.instr_IF(instr_IF_ID_EX),
	.pc_IF(pc_IF_ID_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_IF_ID),
	.flush(flush_IF_ID)
	);
	
	assign flush_IF_ID = (b_ctrl_EX_MEM | j_ctrl_ID_EX_MEM_WB | (prev_stall_IF_ID & prev_flush_IF_ID)) ? 1'b1 : 1'b0;
	assign stall_or_hlt_IF_ID = stall_IF_ID | hlt_ID_EX_MEM_WB;
///////////////////////////////////////////////////////////////////////////////




/************************ ID *************************************************/

// Instantiate ID
ID instruction_decode(	
	// Output
	.p0(p0_ID_EX),
	.p1(p1_ID_EX),
	.p0_addr(p0_addr_ID_EX),
	.p1_addr(p1_addr_ID_EX),
	.shamt(shamt_ID_EX),
	.func(func_ID_EX),
	.src1sel(src1sel_ID_EX),
	.hlt(hlt_ID_EX_MEM_WB_CTRL),
	.imm8(imm8_ID_EX),
	.we_rf(we_rf_ID_EX_MEM_WB),
	.we_mem(we_mem_ID_EX_MEM),
	.re_mem(re_mem_ID_EX_MEM),
	.wb_sel(wb_sel_ID_EX_MEM_WB),
	.dst_addr_new(dst_addr_ID_EX_MEM_WB),
	.j_pc(j_pc_ID),
	.j_ctrl(j_ctrl_ID_EX_MEM_WB),
	// Input
	.instr(instr_ID_EX),
	.pc(pc_ID_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.dst_data_WB(wb_data_WB),
	.dst_addr_WB(dst_addr_WB),
	.we_WB(we_rf_WB),
	.hlt_WB(hlt_WB),
	.MEM_data(alu_result_MEM_WB),
	.MEM_ldata(ldata_MEM_WB),
	.MEM_we(we_rf_MEM_WB),
	.MEM_mem_re(re_mem_MEM),
	.MEM_dst(dst_addr_MEM_WB),
	.EX_data(alu_result_EX_MEM_WB),
	.EX_we(we_rf_EX_MEM_WB_mux),
	.EX_dst(dst_addr_EX_MEM_WB)
	);
	
	assign hlt_ID_EX_MEM_WB = hlt_ID_EX_MEM_WB_CTRL&(~b_ctrl_EX_MEM)&(~j_ctrl_EX_MEM_WB);
	
/************************ ID *************************************************/
	
	
	
// ID_EX Flip Flop ////////////////////////////////////////////////////////////
ID_EX_FF ID_EX(
	// Output
	.p0_EX(p0_EX),
	.p1_EX(p1_EX),
	.p0_addr_EX(p0_addr_EX),
	.p1_addr_EX(p1_addr_EX),
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
	.pc_EX(pc_EX_MEM_WB),
	.j_ctrl_EX(j_ctrl_EX_MEM_WB),
	// Input
	.p0_ID(p0_ID_EX),
	.p1_ID(p1_ID_EX),
	.p0_addr_ID(p0_addr_ID_EX),
	.p1_addr_ID(p1_addr_ID_EX),
	.shamt_ID(shamt_ID_EX),
	.func_ID(func_ID_EX),
	.imm8_ID(imm8_ID_EX),
	.we_rf_ID(we_rf_ID_EX_MEM_WB),
	.we_mem_ID(we_mem_ID_EX_MEM),
	.re_mem_ID(re_mem_ID_EX_MEM),
	.wb_sel_ID(wb_sel_ID_EX_MEM_WB),
	.dst_addr_ID(dst_addr_ID_EX_MEM_WB),
	.src1sel_ID(src1sel_ID_EX),
	.pc_ID(pc_ID_EX_MEM_WB),
	.j_ctrl_ID(j_ctrl_ID_EX_MEM_WB),
	.instr_ID(instr_ID_EX),
	.hlt_ID(hlt_ID_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_ID_EX),
	.flush(flush_ID_EX)
	);

	assign flush_ID_EX = (b_ctrl_EX_MEM) ? 1'b1 : 1'b0;
	assign stall_or_hlt_ID_EX = stall_ID_EX | hlt_EX_MEM_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ EX *************************************************/





// Instantiate EX
EX execution(
	// Output
	.dst(alu_result_EX_MEM_WB_lcl),
	.N(N_EX),
	.Z(Z_EX),
	.V(V_EX),
	.br_pc(b_pc_EX),
	.br_ctrl(b_ctrl_EX_MEM),
	.sdata(sdata_EX_MEM),
	// Input
	.clk(clk),
	.rst_n(rst_n),
	.pc(pc_EX_MEM_WB),
	.func(func_EX),
	.shamt(shamt_EX),
	.src1sel(src1sel_EX),
	.p0(p0_EX),
	.imm8(imm8_EX),
	.p1(p1_EX),
	.instr(instr_EX),
	.alu_result_MEM_WB(alu_result_MEM_WB),
	.wb_data_WB(wb_data_WB),
	.ldata_MEM_WB(ldata_MEM_WB),
	.prev_br_ctrl(b_ctrl_MEM),
	.prev_j_ctrl(j_ctrl_MEM_WB),
	.forwardA(forwardA),
	.forwardB(forwardB)
	);

assign alu_result_EX_MEM_WB = (j_ctrl_EX_MEM_WB) ? pc_EX_MEM_WB : alu_result_EX_MEM_WB_lcl;
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
	.pc_MEM(pc_MEM_WB),
	.j_ctrl_MEM(j_ctrl_MEM_WB),
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
	.pc_EX(pc_EX_MEM_WB),
	.j_ctrl_EX(j_ctrl_EX_MEM_WB),
	.hlt_EX(hlt_EX_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_EX_MEM)
	);

	assign stall_or_hlt_EX_MEM = stall_EX_MEM | hlt_MEM_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ MEM *************************************************/
	
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
	.pc_WB(pc_WB),
	.j_ctrl_WB(j_ctrl_WB),
	.hlt_WB(hlt_WB),
	// Inputs
	.ldata_MEM(ldata_MEM_WB),
	.alu_result_MEM(alu_result_MEM_WB),
	.we_rf_MEM(we_rf_MEM_WB),
	.wb_sel_MEM(wb_sel_MEM_WB),
	.dst_addr_MEM(dst_addr_MEM_WB),
	.pc_MEM(pc_MEM_WB),
	.j_ctrl_MEM(j_ctrl_MEM_WB),
	.hlt_MEM(hlt_MEM_WB),
	.clk(clk),
	.rst_n(rst_n),
	.stall(stall_or_hlt_MEM_WB)
	);

	assign stall_or_hlt_MEM_WB = stall_MEM_WB | hlt_WB;
///////////////////////////////////////////////////////////////////////////////



/************************ WB *************************************************/


WB write_back(
	// Output
	.wb_data(wb_data_WB),
	// Input
	.wb_sel(wb_sel_WB),
	.rd_data(ldata_WB),
	.alu_result(alu_result_WB),
	.pc(pc_WB),
	.j_ctrl(j_ctrl_WB)
	);
	
/************************ WB *************************************************/

// FCU ////////////////////////////////////////////////////////////////////////


FCU forwarding_control_unit(
	// Output
	.forwardA(forwardA),
	.forwardB(forwardB),
	// Input
	.p0_addr_EX(p0_addr_EX),			
	.p1_addr_EX(p1_addr_EX),			
	.we_rf_MEM_WB(we_rf_MEM_WB), 		
	.dst_addr_MEM_WB(dst_addr_MEM_WB), 	
	.we_rf_WB(we_rf_WB),				
	.dst_addr_WB(dst_addr_WB),
	.re_mem_MEM(re_mem_MEM)			
	);
///////////////////////////////////////////////////////////////////////////////

// HDU ////////////////////////////////////////////////////////////////////////

HDU hazard_detection_unit(
	// Output
	.stall_PC(stall_PC),
	.stall_IF_ID(stall_IF_ID),
	.stall_ID_EX(stall_ID_EX),
	.stall_EX_MEM(stall_EX_MEM),
	.stall_MEM_WB(stall_MEM_WB),
	// Input
	.clk(clk), 
	.rst_n(rst_n), 
	.instr(instr_IF_ID_EX),
	.i_rdy(i_rdy_CC),
	.d_rdy(d_access_stall)
	);
	
	assign d_access_stall = (d_rdy_CC) | (~re_mem_MEM & ~we_mem_MEM);
///////////////////////////////////////////////////////////////////////////////


// Memory Heirarchy ///////////////////////////////////////////////////////////

mem_heirarchy MH(
	// Outputs
	.instr(instr_IF_ID_EX),
	.i_rdy(i_rdy_CC),
	.d_rdy_CC(d_rdy_CC),
	.d_rd_data(ldata_MEM_WB),
	//Inputs
	.clk(clk),
	.rst_n(rst_n),
	.i_addr(pc_IF),
	.d_addr(addr_mem_MEM),
	.extern_d_re(re_mem_MEM),
	.extern_d_we(we_mem_MEM),
	.wrt_data(sdata_MEM)
	);
	
endmodule
