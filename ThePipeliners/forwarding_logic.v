// Forwarding Logic
// Author:  David Mateo
// This module generates the forwarding control signals.
// The logic here was taken from pages 366 and 389 of the book:
// "Computer Organization and Design" by Patterson and Hennessy
module forwarding_logic(
	// Input
	we_rf_MEM_WB, 
	dst_addr_MEM_WB, 
	p1_addr_EX,
	p0_addr_EX,
	we_rf_WB,
	dst_addr_WB,
	re_mem_MEM,
	// Output
	forwardA,
	forwardB
	);


	input we_rf_MEM_WB, we_rf_WB, re_mem_MEM;
	input [3:0] dst_addr_MEM_WB;
	input [3:0] p1_addr_EX;
	input [3:0] p0_addr_EX;
	input [3:0] dst_addr_WB;

	output [1:0] forwardA, forwardB;


	assign forwardA =	// Forward ldata from MEM
						(re_mem_MEM							&&
						we_rf_MEM_WB 						&& 
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p1_addr_EX))	?	2'b11:

						// Forward alu result from MEM
						(!re_mem_MEM						&&
						we_rf_MEM_WB 						&& 
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p1_addr_EX))	?	2'b10:

						// Forward from WB
						// But only if not already forwarding from MEM
						(we_rf_WB 							&&
						(dst_addr_WB != 4'h0)				&&
						(dst_addr_WB == p1_addr_EX))		&&
						(!
						(we_rf_MEM_WB 						&& 
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p1_addr_EX))
						)									?	2'b01:
																2'b00;


	assign forwardB = 	// Forward ldata from MEM
						(re_mem_MEM							&&
						we_rf_MEM_WB						&&
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p0_addr_EX))	?	2'b11:

						// Forward alu result from MEM	
						(!re_mem_MEM						&&
						we_rf_MEM_WB						&&
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p0_addr_EX))	?	2'b10:

						// Forward from WB
						// But only if not already forwarding from MEM
						(we_rf_WB 							&&
						(dst_addr_WB != 4'h0)				&&
						(dst_addr_WB == p0_addr_EX))		&&
						(!
						(we_rf_MEM_WB						&&
						(dst_addr_MEM_WB != 4'h0) 			&&
						(dst_addr_MEM_WB == p0_addr_EX))
						)									?	2'b01:
																2'b00;


/*	// ForwardA controls the mux for src1, p1, muxA, Rs
	assign forwardA = 	((two_sources||one_source)						&&
						(we_rf_MEM_WB) 									&& 
						(dst_addr_MEM_WB != 4'h0) 						&& 
						(dst_addr_MEM_WB == p1_addr_EX)) 		? 	2'b10:
						((two_sources||one_source||jump_reg_source)		&&
						(we_rf_WB)										&&
						(dst_addr_WB != 4'h0)							&&
						(!((two_sources||one_source)					&&
						we_rf_MEM_WB 									&&
						(dst_addr_MEM_WB != 4'b0)						&&
						(dst_addr_MEM_WB != p1_addr_EX)))				&&
						(dst_addr_WB == p1_addr_EX))			?	2'b01:
																	2'b00;

	LOL THIS IS THE RESULT OF TRYING TO VERILOG AT 3AM
	
	// ForwardB controls the mux for src0, p0, muxB, Rt
	assign forwardB =	(((two_sources)								&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p0_addr_EX))			||
						(jump_reg_source)							&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p1_addr_EX))	?	2'b10:
						(((two_sources)								&&
						(we_rf_WB)									&&
						(dst_addr_WB != 4'h0)						&&
						(!(((two_sources)							&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p0_addr_EX))			||
						((jump_reg_source)							&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p1_addr_EX))))			&&
						(dst_addr_WB == p0_addr_EX))				||
						((jump_reg_source)							&&
						(we_rf_WB)									&&
						(dst_addr_WB != 4'h0)						&&
						(!(((two_sources)							&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p0_addr_EX))			||
						((jump_reg_source)							&&
						(we_rf_MEM_WB)								&&
						(dst_addr_MEM_WB != 4'h0)					&&
						(dst_addr_MEM_WB == p1_addr_EX))))			&&
						(dst_addr_WB == p1_addr_EX)))		?	2'b01:
																2'b00;
*/

endmodule

