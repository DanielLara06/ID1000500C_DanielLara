/******************************************************************
*Module name : sz_same_reg
*Filename    : sz_same_reg.v
*Type        : Verilog Module
*
*Description : Gets the central convolution length
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
module sz_same_reg(
	input clk,
	input rstn,
	input [4:0] sizex_same_i,
	input size_same_en,
	input size_same_clr,
	
	output reg [4:0] size_same_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			size_same_o <= 5'b00000;
		else if(size_same_clr)
			size_same_o <= 5'b00000;
		else if(size_same_en)
			size_same_o <= sizex_same_i;
end
endmodule