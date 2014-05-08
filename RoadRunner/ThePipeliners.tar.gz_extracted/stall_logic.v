// Stall Logic module
// Author: David Mateo
// This module generates the stall signal when pipeline hazards occur and
// implements the stalling state machine.
// Assuming full forwarding, the only type of stalling we'll need is 
// on a RAW Hazard involving a lw instruction followed by something that 
// uses the result of the lw.
module stall_logic(clk, rst_n, instr, stall);

	input clk, rst_n;
	input [15:0] instr;

	output reg stall;

	reg [15:0] curr_instr, prev_instr;
	reg [1:0] state, next_state;

	wire hazard;
	wire [3:0] curr_opcode, prev_opcode, curr_src1, curr_src2, curr_src_sw, curr_src_jr, prev_dest;
	wire two_sources, one_source, store_source, jump_reg_source;

	// States
	localparam STATE_START 		= 2'b00;
	localparam STATE_NO_STALL 	= 2'b01;
	localparam STATE_STALL 		= 2'b10;
	localparam STATE_UNUSED 	= 2'b11;

	// Instruction Opcodes
	localparam addOp = 4'b0000;
	localparam addzOp = 4'b0001;
	localparam subOp = 4'b0010;
	localparam andOp = 4'b0011;
	localparam norOp = 4'b0100;
	localparam sllOp = 4'b0101;
	localparam srlOp = 4'b0110;
	localparam sraOp = 4'b0111;
	localparam lwOp = 4'b1000;
	localparam swOp = 4'b1001;
	localparam lhbOp = 4'b1010;
	localparam llbOp = 4'b1011;
	localparam hltOp = 4'b1111;
	localparam bOp = 4'b1100;
	localparam jalOp = 4'b1101;
	localparam jrOp = 4'b1110;

	// Instr Shift Register
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			curr_instr <= 16'h0000;
			prev_instr <= 16'h0000;
		end
		else begin
			curr_instr <= instr;
			prev_instr <= curr_instr;
		end
	end

	// Logic to make hazard calculation easier
	assign curr_opcode = curr_instr[15:12];
	assign curr_src1 = curr_instr[7:4];
	assign curr_src2 = curr_instr[3:0];
	assign curr_src_sw = curr_instr[11:8];
	assign curr_src_jr = curr_instr[7:4];
	assign prev_opcode = prev_instr[15:12];
	assign prev_dest = prev_instr[11:8];
	assign two_sources 		=	((curr_opcode==addOp) 	||
								(curr_opcode==addzOp)	||
								(curr_opcode==subOp) 	||
								(curr_opcode==andOp)	||
								(curr_opcode==norOp));
	assign one_source		=	((curr_opcode==sllOp)	||
								(curr_opcode==srlOp)	||
								(curr_opcode==sraOp)	||
								(curr_opcode==lwOp));
	assign store_source 	=  	(curr_opcode==swOp);
	assign jump_reg_source 	=	(curr_opcode==jrOp); 
	// I realized that I could have used the read enable instead of the above nonsense.
	// But it's too late!  No turning back now!

	// Hazard Signal
	// The three major cases are separated			HERE
	assign hazard = (((prev_opcode==lwOp) 	&& 
					(two_sources) 			&& 
					((prev_dest==curr_src1) || 
					(prev_dest==curr_src2)))		||
					((prev_opcode==lwOp)	&&
					(one_source)			&&
					(prev_dest==curr_src1))			||
					((prev_opcode==lwOp)	&&
					(store_source)			&&
					(prev_dest==curr_src_sw))		||
					((prev_opcode==lwOp)	&&
					(jump_reg_source) 		&&
					(prev_dest==curr_src_jr)));

	// Stall State Machine - Sequential Logic //
	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			state <= STATE_START;
		end
		else begin
			state <= next_state;
		end
	end

	// Stall State Machine - Combinational Logic //
	always @(state, hazard) begin
		// Output Defaults
		next_state = STATE_START;
		stall = 1'b0;

		// Next State Logic
		case (state)
			STATE_START : begin
				next_state = STATE_NO_STALL; 	// At next clock, instr shift  
												// reg will be filled.
				stall = 1'b0;
			end

			STATE_NO_STALL : begin
				if(!hazard) begin
					next_state = STATE_NO_STALL;
					stall = 1'b0;
				end
				else if (hazard) begin
					next_state = STATE_STALL;
					stall = 1'b1;
				end
				else begin
					next_state = STATE_START;
					stall = 1'b0;
					//$display("%g ERROR: Impossible Path out of STATE_NO_STALL.", $time);
				end
			end

			STATE_STALL : begin
				next_state = STATE_NO_STALL;
				stall = 1'b0;
			end
			default : begin
				next_state = STATE_START;
				stall = 1'b0;
			end
		endcase
	end

	

endmodule
