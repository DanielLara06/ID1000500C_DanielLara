/******************************************************************
*Module name : y_i
*Filename    : y_i.v
*Type        : Verilog Module
*
*Description : counter for y indexes
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

module y_i(
	input [5:0] y_ind_i,
	
	output [5:0] y_ind_o);
	
assign y_ind_o = y_ind_i + 6'b000001;

endmodule
