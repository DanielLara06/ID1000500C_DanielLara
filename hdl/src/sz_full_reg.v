/******************************************************************
*Module name : sz_full_reg
*Filename    : sz_full_reg.v
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
module sz_full_reg(
	input clk,
	input rstn,
	input [4:0] sizex_i,
	input [4:0] sizey_i,
	input size_full_en,
	input size_full_clr,
	
	output reg [5:0] size_full_o);
	
wire [5:0] aux;

assign aux = (sizex_i + sizey_i);
	
always@(posedge clk or negedge rstn) 
begin
		if(!rstn)
			size_full_o <= 6'b000000;
		else if(size_full_clr)
			size_full_o <= 6'b000000;
		else if(size_full_en)
			size_full_o <= aux - 6'b000001;
end
endmodule
