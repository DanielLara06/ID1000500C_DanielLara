/******************************************************************
*Module name : ptr_reg
*Filename    : ptr_reg.v
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

module ptr_reg(
	input clk,
	input rstn,
	input [5:0] ptr_i,
   input ptr_en,
   input ptr_clr,
	
	output reg [5:0] ptr_o);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			ptr_o <= 6'b000000;
		else if(ptr_clr)
			ptr_o <= 6'b000000;
		else if(ptr_en)
			ptr_o <= ptr_i;
end
endmodule
