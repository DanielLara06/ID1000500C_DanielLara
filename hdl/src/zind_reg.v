/******************************************************************
*Module name : zind_reg
*Filename    : zind_reg.v
*Type        : Verilog Module
*
*Description : z indexes adder
*------------------------------------------------------------------
*	clocks    : none
*	reset		 : none
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module zind_reg(
	input clk,
	input rstn,
	input [5:0] zind_reg_i,
	input [5:0] y_i,
   input zind_en,
   input zind_clr,
	input y_i_en_clr,
	
	output reg [5:0] zind_reg_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			zind_reg_o <= 6'b00000;
		else if (y_i_en_clr)
			zind_reg_o <= y_i;
		else if(zind_clr)
			zind_reg_o <= 6'b00000;
		else if(zind_en)
			zind_reg_o <= zind_reg_i;
end
endmodule

