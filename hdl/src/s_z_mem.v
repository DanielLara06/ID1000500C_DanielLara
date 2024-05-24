/******************************************************************
*Module name : s_z_mem
*Filename    : s_z_mem.v
*Type        : Verilog Module
*
*Description : Full convolution memory 
*------------------------------------------------------------------
*	clocks    : clk
*	reset		 : rstn
* 
*Parameters  : DATA_WIDTH= 16,
					ADDR_WIDTH= 6
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/

module s_z_mem #(
		parameter DATA_WIDTH= 16,
		parameter ADDR_WIDTH= 6
)(
		input                    clk,		
		input                    write_en_i,
		input   [ADDR_WIDTH-1:0] write_addr_i,				
		input   [ADDR_WIDTH-1:0] read_addr_i,
		input   [DATA_WIDTH-1:0] write_data_i,
		
		output  reg [DATA_WIDTH-1:0] read_data_o
	   
);

// signal declaration
reg [DATA_WIDTH-1:0] RAM_structure [0:2**ADDR_WIDTH-1]; 

//initial begin  //load hexadecimal data in txt
//		$writememb("s_z.txt", RAM_structure);		
//end

//write and read operations
always @ (posedge clk) begin
		if(write_en_i)
				RAM_structure[write_addr_i] <= write_data_i;
		
				read_data_o <= RAM_structure[read_addr_i];		
end

endmodule
