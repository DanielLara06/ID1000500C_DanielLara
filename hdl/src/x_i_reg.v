/******************************************************************
*Module name : x_i_reg
*Filename    : x_index_reg.v
*Type        : Verilog Module
*
*Description : register counter for x indexes
*------------------------------------------------------------------
*	clocks    : clk
*	reset		 : rstn
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module x_i_reg(
	input clk,
	input rstn,
	input [5:0] x_ind_i,
   input x_ind_en,
   input x_ind_clr,
	
	output reg [5:0] x_ind_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			x_ind_o <= 6'b000000;
		else if(x_ind_clr)
			x_ind_o <= 6'b000000;
		else if(x_ind_en)
			x_ind_o <= x_ind_i;
end
endmodule
