/******************************************************************
*Module name : same_i_COMP
*Filename    : same_i_COMP.v
*Type        : Verilog Module
*
*Description : auxiliar counter reg 
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module same_i_COMP(
	input [4:0] same_i,
	input [4:0] sz_same,
	
	output COMP_same_o);
	
assign COMP_same_o = (same_i == (sz_same-5'b00001))?1'b1:1'b0; 
endmodule 