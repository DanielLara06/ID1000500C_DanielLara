/******************************************************************
*Module name : ptr_i
*Filename    : ptr_i.v
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

module ptr_i(
	input [5:0] init_same_i,
	
	output [5:0] ptr_o);
	
assign ptr_o = init_same_i + 6'b000001;

endmodule
