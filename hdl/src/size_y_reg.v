/******************************************************************
*Module name : size_y_reg
*Filename    : size_y_reg.v
*Type        : Verilog Module
*
*Description : "Y" signal length Register 
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

module size_y_reg(
	input clk,
	input rstn,
	input sizey_clr,
	input sizey_en,
	input [4:0] sizeY_i,
 
	output reg [4:0] size_y_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			size_y_o <= 5'b00000;
		else if(sizey_clr)
			size_y_o <= 5'b00000;
		else if(sizey_en)
			size_y_o <= sizeY_i;
end
endmodule 