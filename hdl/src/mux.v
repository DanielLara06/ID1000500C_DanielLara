/******************************************************************
*Module name : mux
*Filename    : mux.v
*Type        : Verilog Module
*
*Description : 2x1 generic multiplexer 
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

module mux(
	input select,
	input [5:0] i_one,
	input [5:0] i_zero,
	
	output [5:0] mux_o);

assign mux_o = (select)?i_one:i_zero;
	
endmodule 