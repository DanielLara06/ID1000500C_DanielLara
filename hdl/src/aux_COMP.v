/******************************************************************
*Module name : aux_COMP
*Filename    : aux_COMP.v
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

module aux_COMP(
	input [5:0] aux_reg_i,
	input [5:0] sz_full_i,
	
	output COMP_o);
	
assign COMP_o = (aux_reg_i == (sz_full_i+6'b000000))?1'b1:1'b0; //Caso de prueba, si es 8 manda 1 a FSM, de lo contrario manda 0 -6'b000001 poner 2 para 32x32
endmodule

