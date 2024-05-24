/******************************************************************
*Module name : aux_ADD
*Filename    : aux_ADD.v
*Type        : Verilog Module
*
*Description : auxiliar counter 
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

module aux_ADD(
	input [5:0] aux_i,
	
	output [5:0] aux_o);
	
assign aux_o = aux_i + 6'b000001;

endmodule

