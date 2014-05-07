module cache_controller(
	// Inputs
	clk, rst_n, i_rdy, d_rdy, u_rdy, data_re, data_we, dirty,
	// Outputs
	u_re, u_we, d_we, d_re, i_we, addr_sel, d_set_dirty, evict//, stall
	);
	
	// Inputs
	input wire clk, rst_n, i_rdy, d_rdy, dirty, u_rdy, data_re, data_we;
	
	// Outputs
	output reg u_re, u_we, d_we, d_re, i_we, addr_sel, d_set_dirty, evict;//, stall;
	
	localparam state_idle = 3'b000;
	localparam state_i_rd = 3'b001;
	localparam state_d_rd_evict = 3'b010;
	localparam state_d_rd_miss = 3'b011;
	localparam state_d_w_evict = 3'b100;
	localparam state_d_w_miss = 3'b101;
	
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
		evict = 0;
		u_re = 0;
		u_we = 0;
		d_re = 0;
		d_we = 0;
		i_we = 0;
		addr_sel = 0;
		d_set_dirty = 0;
		//stall = 0;
		
		case(current_state)
		
			/* Idle state */
			state_idle : begin
				if(i_rdy & d_rdy) begin
					next_state = state_idle;
					evict = 0;
					u_re = 0;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 0;
					if(data_we) begin
						d_set_dirty = 1;
					end
					else begin
						d_set_dirty = 0;
					end
					//stall = 0;
				end
				else if (~i_rdy & (~(data_re & data_we) | d_rdy)) begin// & d_rdy & ~(d_re || d_we)) begin
					next_state = state_i_rd;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 0;
					d_set_dirty = 0;
					//stall = 1;
				end
				else if (~d_rdy) begin
					if(data_re & dirty) begin // Here we evict data before handling the miss
						next_state = state_d_rd_evict;
						evict = 1;
						u_re = 0;
						u_we = 1;
						d_re = 0;
						d_we = 0;
						i_we = 0;
						addr_sel = 1;
						d_set_dirty = 0;// Choose the reconstructed address for data being evicted
					end
					else if(data_re & ~dirty) begin
						next_state = state_d_rd_miss;
						evict = 0;
						u_re = 1;
						u_we = 0;
						d_re = 0;
						d_we = 0;
						i_we = 0;
						addr_sel = 1;
						d_set_dirty = 0;
					end
					else if(data_we & dirty) begin // Here we evict data before handling the miss
						next_state = state_d_w_evict;
						evict = 1;
						u_re = 0;
						u_we = 1;
						d_re = 0;
						d_we = 0;
						i_we = 0;
						addr_sel = 1;
						d_set_dirty = 0;
					end
					else if(data_we & ~dirty) begin
						next_state = state_d_w_miss;
						evict = 0;
						u_re = 1;
						u_we = 0;
						d_re = 0;
						d_we = 0;
						i_we = 0;
						addr_sel = 1;
						d_set_dirty = 0;
					end
				end
			end
			
			/* i_rd state : when there is an I-cache miss */
			state_i_rd : begin
				if(u_rdy) begin
					next_state = state_idle;
					evict = 0;
					u_re = 0;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 1;
					addr_sel = 0;
					d_set_dirty = 0;
				end
				else begin
					next_state = state_i_rd;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 0;
					d_set_dirty = 0;
				end
			end
			
			
			/* */
			state_d_rd_evict : begin
				if(u_rdy) begin
					next_state = state_d_rd_miss;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 1;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;					
				end
				else begin
					next_state = state_d_rd_evict;
					evict = 1;
					u_re = 0;
					u_we = 1;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;
				end
			end
			
			
			/* */ 
			state_d_rd_miss : begin
				if(u_rdy & i_rdy) begin
					next_state = state_idle;
					evict = 0;
					u_re = 0;
					u_we = 0;
					d_re = 0;
					d_we = 1;
					i_we = 0;
					addr_sel = 0;
					d_set_dirty = 0;
				end
				else if(u_rdy & ~i_rdy) begin
					next_state = state_i_rd;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 0;
					d_set_dirty = 0;
				end
				else begin
					next_state = state_d_rd_miss;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 1;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;	
				end
			end
			
			
			/* */
			state_d_w_evict : begin
				if(u_rdy) begin
					next_state = state_d_w_miss;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;	
				end
				else begin
					next_state = state_d_w_evict;
					evict = 1;
					u_re = 0;
					u_we = 1;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;
				end
			end
			
			
			/* */
			state_d_w_miss : begin
				if(u_rdy & i_rdy) begin
					next_state = state_idle;
					evict = 0;
					u_re = 0;
					u_we = 0;
					d_re = 0;
					d_we = 1;
					i_we = 0;
					addr_sel = 0;
					d_set_dirty = 0;	
				end
				else if(u_rdy & ~i_rdy) begin
					next_state = state_i_rd;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 1;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;	
				end
				else begin
					next_state = state_d_w_miss;
					evict = 0;
					u_re = 1;
					u_we = 0;
					d_re = 0;
					d_we = 0;
					i_we = 0;
					addr_sel = 1;
					d_set_dirty = 0;
				end
			end
			
			
			default : begin
				next_state = state_idle;
				u_re = 0;
				u_we = 0;
				d_re = 0;
				d_we = 0;
				i_we = 0;
				addr_sel = 0;
				d_set_dirty = 0;
			end
		
		endcase	
	end


endmodule

