// Stall Logic module
// Author: David Mateo
// This module generates the stall signal when pipeline hazards occur and
// implements the stalling state machine.
module stall_logic(clk, rst_n, instr);

	input clk, rst_n;
	input [15:0] instr;

	output reg stall;

	reg [15:0] curr_instr, prev_instr;
	reg [1:0] state;
	wire [1:0] next_state;
	wire hazard, hazard2, hazard1

	// States
	localparam STATE_START 		= 2'b00;
	localparam STATE_NO_STALL 	= 2'b01;
	localparam STATE_STALL_2 	= 2'b10;
	localparam STATE_STALL_1 	= 2'b11;

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

	// hazard1 and hazard2 signal
	always @(*) begin
		if()
	end

	// hazard signal
	assign hazard = (hazard2 || hazard1);

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
	always @(*) begin
		// Output Defaults
		next_state = 2'b01;
		stall = 1'b0;

		// Next State Logic
		case (state)
			STATE_START : begin
				next_state = STATE_NO_STALL; 	// At next clock, instr shift  
												// reg will be filled.
				stall = 1'b0;
			end

			STATE_NO_STALL : begin
				if(!hazard2 || !hazard1) begin
					next_state = STATE_NO_STALL;
					stall = 1'b0;
				end
				else if (hazard2) begin
					next_state = STATE_STALL_2;
					stall = 1'b1;
				end
				else if (hazard1) begin
					next_state = STATE_START_1;
					stall = 1'b1;
				end
				else begin
					$display("%g ERROR: Impossible Path out of STATE_NO_STALL.", $time);
				end
			end

			STATE_STALL_2 : begin
				next_state = STATE_STALL_1;
				stall = 1'b1;
			end

			STATE_STALL_1 : begin
				next_state = STATE_NO_STALL;
				stall = 1'b1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
			end
		endcase
	end
