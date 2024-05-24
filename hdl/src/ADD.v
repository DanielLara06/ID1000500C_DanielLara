/******************************************************************
*Module name : ADD
*Filename    : ADD.v
*Type        : Verilog Module
*
*Description : Accumulator/Adder (combinational logic) 
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

module ADD(
	input [15:0] multi_i,
	input [15:0] S_Z_data_i,
	
	output [15:0] result_o); 
	
assign result_o = multi_i + S_Z_data_i;
	
endmodule 
