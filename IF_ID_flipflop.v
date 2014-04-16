module IF_ID_FF(instr_ID, pc_ID, instr_IF, pc_IF, stall, rst_n, clk);

	// Inputs
	input wire [15:0] instr_IF, pc_IF;
	input wire stall, rst_n, clk;
	
	// Outputs
	output reg[15:0] instr_ID, pc_ID;
	
	// Local wires
	wire [15:0] next_instr, next_pc;
	
	always@(posedge clk, negedge rst_n)begin
		if(~rst_n)begin
			instr_ID <= 16'h0000;
			pc_ID <= 16'h0000;
		end
		else begin
			instr_ID <= next_instr;
			pc_ID <= next_pc;
		end
	end
	
	assign next_instr = (stall) ? instr_ID : instr_IF;
	assign next_pc = (stall) ? pc_ID : pc_IF;
	
endmodule