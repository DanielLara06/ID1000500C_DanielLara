/******************************************************************
*Module name : conv_top_tb
*Filename    : conv_top_tb.v
*Type        : Verilog Module
*
*Description : Testbench module for testing the convolver core.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn, async ptrz_clr
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/
`timescale 1ns/100ps 

module conv_top_tb();

integer f,x, data, status; //fichero
integer i, k, j, y, z, ii, fd;

reg clk;
reg rstn;
reg start_tb;
reg shape_tb;
reg [4:0] sizeX_tb;
reg [4:0] sizeY_tb;
reg [7:0] dataX_tb;
reg [7:0] dataY_tb;

wire [5:0] memZ_addr_tb;
wire [4:0] memX_addr_tb;
wire [4:0] memY_addr_tb;
wire [15:0] data_Z_o_tb;
wire busy_tb;
wire done_tb;
wire WE_Z_tb;

wire [5:0] Zread_addr_tb;
wire [15:0] dataZ_o_tb;



//Bidimensional array for memories
reg [7:0] memory_dataX [0:31];
reg [7:0] memory_dataY [0:31];
//reg [15:0] memory_dataZ [0:63];


//testbench and design instances

conv_top DUT
		(
			.clk		(clk),
			.rstn		(rstn),
			.start		(start_tb),
			.shape		(shape_tb),
			.sizeX		(sizeX_tb),
			.sizeY		(sizeY_tb),
			.dataX		(dataX_tb),
			.dataY		(dataY_tb),
			
			.memZ_addr	(memZ_addr_tb),
			.memX_addr	(memX_addr_tb),
			.memY_addr	(memY_addr_tb),
			.data_Z_o		(data_Z_o_tb),
			.busy		(busy_tb),
			.done		(done_tb),
			.WE_Z	(WE_Z_tb)
			
			
);

Z_MEM mem_o
		(
			.clk		(clk),
			.write_en_i	(WE_Z_tb),
			.write_addr_i	(memZ_addr_tb),
			.read_addr_i	(Zread_addr_tb),
			.write_data_i	(data_Z_o_tb),
			
			.read_data_o	(dataZ_o_tb)
			
);



initial 
	begin 
		
		//Inicialization process
		clk = 1'b0;
		rstn = 1'b1;
		start_tb = 1'b0;
		shape_tb = 1'b0;//Full convolution
		sizeX_tb = 5'b00101;
		sizeY_tb = 5'b01010;//5'b00101;
		
		#10
		rstn = 1'b0;
		#10 // o poner 20
		rstn = 1'b1;
		
//X and Y memory load 
 f = $fopen("S_X.txt","r");
   j = 0; 
   while(!$feof(f)) begin
      status = $fscanf(f,"%b \n",data);
      memory_dataX[j] = data;  // bit inicio dato 1
      j = j + 1;
   end
   $fclose(f);
    
   x = $fopen("S_Y.txt","r");
   j = 0;
   while(!$feof(x)) begin
      status = $fscanf(x,"%b \n",data);
      memory_dataY[j] = data;  // bit inicio dato 1
      j = j + 1;
   end
   $fclose(x);

   #10 
	start_tb = 1'b1;
   #40 
	start_tb = 1'b0;

	
end



always @(*) begin
//	if(WE_Z_tb) begin
//		memory_dataZ[memZ_addr_tb] <= data_Z_o_tb;		
//	end


	dataX_tb <= memory_dataX[memX_addr_tb];
	dataY_tb <= memory_dataY[memY_addr_tb];		

end


always @(posedge clk) begin
    if(done_tb) begin
        fd = $fopen("S_Z.txt","w");
        for(ii=0; ii < 14; ii = ii+1) begin
            $fdisplay(fd, "%b", mem_o.RAM_structure[ii]);
        end
        $fclose(fd);
        //#20000
        //$stop;
    end
end

   
always #10 clk <= ~clk;

endmodule 