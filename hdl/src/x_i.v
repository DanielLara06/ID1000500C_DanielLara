/******************************************************************
*Module name : x_i
*Filename    : x_i.v
*Type        : Verilog Module
*
*Description : counter for x indexes
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

module x_i(
	input [5:0] x_ind_i,
	
	output [5:0] x_ind_o);
	
assign x_ind_o = x_ind_i + 6'b000001;

endmodule
