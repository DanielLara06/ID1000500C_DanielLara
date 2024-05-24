/******************************************************************
*Module name : y_i_COMP
*Filename    : y_i_COMP.v
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

module y_i_COMP(
	input [5:0] y_i,
	input [4:0] sz_y,
	
	output COMP_y_o);
	
wire [6:0] aux;  
assign aux = {1'b0,sz_y}+6'b000000;  	 //Caso critico poner 1
	
assign COMP_y_o = (y_i == (aux))?1'b1:1'b0; //Caso de prueba, si es 4 manda 1 a FSM, de lo contrario manda 0 -6'b000001 {1'b0,sz_y}+6'b000001
endmodule
