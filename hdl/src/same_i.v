/******************************************************************
*Module name : same_i
*Filename    : same_i.v
*Type        : Verilog Module
*
*Description : counter for same convolution indexes
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module same_i(
	input [4:0] same_index_i,
	
	output [4:0] same_index_o);
	
assign same_index_o = same_index_i + 5'b00001;

endmodule
