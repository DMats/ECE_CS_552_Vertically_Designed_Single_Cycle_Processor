// Author:  David Mateo
// Instruction Fetch
// This module contains all modules used for Instruction Fetch 
module IF(instr, clk, rst_n, hlt);

output wire [15:0] instr;
input wire clk, rst_n, hlt;

wire [15:0] iaddr;

IM instr_mem(.clk(clk), .addr(iaddr), .rd_en(1'b1), .instr(instr));

PC program_counter(.clk(clk), .iaddr(iaddr), .rst_n(rst_n), .hlt(hlt));

endmodule