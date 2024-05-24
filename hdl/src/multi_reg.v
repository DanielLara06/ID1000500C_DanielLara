/******************************************************************
*Module name : multi_reg
*Filename    : multi_reg.v
*Type        : Verilog Module
*
*Description : Computes the full size convolution length
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
module multi_reg(
	input clk,
	input rstn,
	input [15:0] multi_i,
	input multi_reg_en,
	input multi_reg_clr,
	
	output reg [15:0] multi_o);

	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			multi_o <= 16'h0000;
		else if(multi_reg_clr)
			multi_o <= 16'h0000;
		else if(multi_reg_en)
			multi_o <= multi_i;
end
endmodule
