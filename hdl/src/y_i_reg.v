/******************************************************************
*Module name : y_i_reg
*Filename    : y_i_reg.v
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

module y_i_reg(
	input clk,
	input rstn,
	input [5:0] y_ind_i,
   input y_ind_en,
   input y_ind_clr,
	
	output reg [5:0] y_ind_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			y_ind_o <= 6'b000000;
		else if(y_ind_clr)
			y_ind_o <= 6'b000000;
		else if(y_ind_en)
			y_ind_o <= y_ind_i;//{1'b0,y_ind_i};
end
endmodule
