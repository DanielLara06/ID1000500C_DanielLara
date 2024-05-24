/******************************************************************
*Module name : x_i_COMP
*Filename    : x_i_COMP.v
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

module x_i_COMP(
	input [5:0] x_i,
	input [4:0] sz_x,
	
	output COMP_x_o);

wire [6:0] aux; 

assign aux = {1'b0,sz_x}+6'b000000;  //Caso critico poner 1
	
assign COMP_x_o = (x_i == (aux))?1'b1:1'b0; //Caso de prueba, si es 4 manda 1 a FSM, de lo contrario manda 0 -5'b00001 sz_x 
endmodule
