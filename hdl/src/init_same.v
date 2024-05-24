/******************************************************************
*Module name : init_same
*Filename    : init_same.v
*Type        : Verilog Module
*
*Description : Operation to initialize the central convolution counter
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

module init_same(
	input [4:0] size_y_i,
	
	output [5:0] oper_o);
	
wire [5:0] aux;
wire [5:0] aux2;

assign aux = {1'b0,size_y_i};	
assign aux2 = (size_y_i[0] == 1'b1)?((aux+6'b000001)/6'b000010):((aux+6'b000001)/6'b000010) + 6'b000001;
assign oper_o = aux2 - 6'b000010;
	
	
//always@(*) 
//begin
//	if(size_y[0] == 5'b00001) //impar a par
//		oper_o = ((size_y+5'b00001)/5'b00010) + 5'b00001;
//	else if(size_y[0] == 5'b00000) //par a impar
//		oper_o = ((size_y+5'b00001)/5'b00010);
//
//end

endmodule