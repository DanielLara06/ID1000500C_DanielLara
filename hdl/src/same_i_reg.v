/******************************************************************
*Module name : same_i_reg
*Filename    : same_i_reg.v
*Type        : Verilog Module
*
*Description : register counter for x indexes
*------------------------------------------------------------------
*	clocks    : clk
*	reset		 : rstn
* 
*Parameters  : none
*same_index_reg
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module same_i_reg(
	input clk,
	input rstn,
	input [4:0] same_ind_i,
   input same_ind_en,
   input same_ind_clr,
	
	output reg [4:0] same_ind_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			same_ind_o <= 4'b000000;
		else if(same_ind_clr)
			same_ind_o <= 4'b000000;
		else if(same_ind_en)
			same_ind_o <= same_ind_i;
end
endmodule
