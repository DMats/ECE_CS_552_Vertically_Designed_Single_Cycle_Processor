module cache_controller(
	// Inputs
	clk, rst_n, i_rdy, u_rdy,
	// Outputs
	u_re, i_we//, stall
	);
	
	// Inputs
	input wire clk, rst_n, i_rdy, u_rdy;
	
	// Outputs
	output reg u_re, i_we;//, stall;
	
	localparam state_idle = 3'b000;
	localparam state_i_rd = 3'b001;
	
	reg [2:0] current_state, next_state;
	
	always@(posedge clk, negedge rst_n) begin
		if(~rst_n)begin
			current_state <= 3'b000;
		end
		else begin
			current_state <= next_state;
		end
	end
	
	always@(current_state, i_rdy, u_rdy) begin
		// Defaults
		next_state = state_idle;
		u_re = 0;
		i_we = 0;
		//stall = 0;
		
		case(current_state)
		
			/* Idle state */
			state_idle : begin
				if(i_rdy) begin
					next_state = state_idle;
					u_re = 0;
					i_we = 0;
					//stall = 0;
				end
				else begin
					next_state = state_i_rd;
					u_re = 1;
					i_we = 0;
					//stall = 1;
				end
			end
			
			/* i_rd state : when there is an I-cache miss */
			state_i_rd : begin
				if(u_rdy) begin
					next_state = state_idle;
					i_we = 1;
					//stall = 1;
					u_re = 0;
				end
				else begin
					next_state = state_i_rd;
					i_we = 0;
					//stall = 1;
					u_re = 1;
				end
			end
		
		endcase	
	end


endmodule

