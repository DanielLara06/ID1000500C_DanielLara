/******************************************************************
*Module name : ADD_reg
*Filename    : ADD_reg.v
*Type        : Verilog Module
*
*Description : register for Accumulator/adder 
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

module ADD_reg(
	input clk,
	input rstn,
	input ADD_reg_clr,
	input ADD_reg_en,
	input [15:0] ADD_2_reg_i,
 
	output reg [15:0] ADD_reg_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			ADD_reg_o <= 16'b000000000000000;
		else if(ADD_reg_clr)
			ADD_reg_o <= 16'b000000000000000;
		else if(ADD_reg_en)
			ADD_reg_o <= ADD_2_reg_i;
end
endmodule 