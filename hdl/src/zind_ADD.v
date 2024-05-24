/******************************************************************
*Module name : zind_ADD
*Filename    : zind_ADD.v
*Type        : Verilog Module
*
*Description : z indexes adder
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

module zind_ADD(
	input [5:0] zind_i,
	
	output [5:0] zind_o);
	
assign zind_o = zind_i + 6'b000001;

endmodule
