/******************************************************************
*Module name : aux_reg
*Filename    : aux_reg.v
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
module aux_reg(
	input clk,
	input rstn,
	input [5:0] aux_reg_i,
   input aux_reg_en,
   input aux_reg_clr,
	
	output reg [5:0] aux_reg_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			aux_reg_o <= 6'b000000;
		else if(aux_reg_clr)
			aux_reg_o <= 6'b000000;
		else if(aux_reg_en)
			aux_reg_o <= aux_reg_i;
end
endmodule
