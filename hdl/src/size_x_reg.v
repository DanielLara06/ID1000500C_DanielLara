/******************************************************************
*Module name : size_x_reg
*Filename    : size_x_reg.v
*Type        : Verilog Module
*
*Description : X signal length Register 
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn, async reg_clr
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module size_x_reg(
	input clk,
	input rstn,
	input sizex_clr,
	input sizex_en,
	input [4:0] sizeX_i,
 
	output reg [4:0] size_x_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			size_x_o <= 5'b00000;
		else if(sizex_clr)
			size_x_o <= 5'b00000;
		else if(sizex_en)
			size_x_o <= sizeX_i;
end
endmodule 