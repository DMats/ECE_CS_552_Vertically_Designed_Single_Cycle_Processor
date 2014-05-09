module IF_ID_FF(
	instr_ID, pc_ID, prev_flush_ID, prev_stall_ID, 
	instr_IF, pc_IF, stall, rst_n, clk, flush);

	// Inputs
	input wire [15:0] instr_IF, pc_IF;
	input wire stall, rst_n, clk, flush;	

	// Outputs
	output reg [15:0] instr_ID, pc_ID;
	output reg prev_flush_ID, prev_stall_ID;
	
	// Local wires
	wire [15:0] next_instr, next_pc;
	
	// Sequential Logic
	always@(posedge clk, negedge rst_n)begin
		if (~rst_n) begin
			instr_ID <= 16'hB000;
			pc_ID <= 16'h0000;
			prev_flush_ID <= 1'b0;
			prev_stall_ID <= 1'b0;
			//$display("%g Reset Happened.  If a branch was taken or global reset, then this is correct.  If the branch was not taken, then this is a glitch!!!", $time);
		end
		else begin
			instr_ID <= next_instr;
			pc_ID <= next_pc;
			prev_flush_ID <= flush;
			prev_stall_ID <= stall;
		end
	end
	
	// Combinational Logic
	assign next_instr = (flush) ? 	16'hB000 	:
						(stall) ? 	instr_ID 	: 
									instr_IF;

	assign next_pc = 	(flush) ? 	16'h0000 	:
						(stall) ? 	pc_ID 		: 
									pc_IF;

endmodule
