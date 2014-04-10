// R Scott Carson and David Mateo

module cache(
	//Inputs
	addr, wr_line, we, clk, rst_n,
	//Outputs
	instr, hit
	);
	
	//Inputs
	input wire [15:0] addr;
	input wire [63:0] wr_line;
	input wire we;
	
	//Outputs
	output reg [15:0] instr;
	output wire hit;
	
	reg [63:0]data[63:0];
	reg [7:0]tag[63:0];
	reg valid[63:0];
	
	wire [15:0] word_mux;
	wire tag_eq;
	
	always @(posedge clk) begin
		if(clk) begin
			instr <= word_mux;
		end
		else begin
			instr <= instr;
		end
	end
	
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			valid[63:0] <= 64'h0000_0000_0000_0000;
		end
		else if(we) begin
			data[63:0][addr[7:2]] <= wr_line;
			tag[7:0][addr[7:2]] <= addr[15:8];
			vaid[addr[7:2]] <= 1'b1;
		end
	end
	
	
	//Combinational logics n shit
	case (addr[1:0]) begin
		2'b00 : 
			assign word_mux = data[15:0][addr[7:2]];
		2'b01 :
			assign word_mux = data[31:16][addr[7:2]];
		2'b10 :
			assign word_mux = data[47:32][addr[7:2]];
		2'b11 : 
			assign word_mux = data[63:48][addr[7:2]];
	endcase
	
	assign tag_eq = (tag[7:0] == addr[15:8]);
	assign hit = (tag_eq & valid[addr[7:2]) ? 1'b1 : 1'b0;
	
endmodule