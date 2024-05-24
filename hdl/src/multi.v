/******************************************************************
*Module name : multi
*Filename    : multi.v
*Type        : Verilog Module
*
*Description : Multiplication block (combinational logic) 
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

module multi(
	input [7:0] S_X_in,
	input [7:0] S_Y_in,
	
	output [15:0] multi_o);
	
	assign multi_o = S_X_in*S_Y_in;
	

endmodule 