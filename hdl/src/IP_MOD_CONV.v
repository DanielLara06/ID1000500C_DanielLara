 /******************************************************************
*Module name : IP_MOD_CONV
*Filename    : IP_MOD_CONV.v
*Type        : Verilog Module
*
*Description : Top Level Entity for testing the IP Module - convolver core.  
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
module IP_MOD_CONV(
	 clk,
    rst_a,
    en_s,
    data_in, //different data in information types
    data_out, //different data out information types
    write, //Used for protocol to write different information types
    read, //Used for protocol to read different information types
    start, //Used to start the IP-core
    conf_dbus, //Used for protocol to determine different actions types
    int_req //Interruption request
);

	 localparam DATA_WIDTH = 'd32; //define data length
    localparam MEM_ADDR_MAX_WIDTH = 'd16;//'d16
	  localparam MEM_ADDR_MAX_WIDTH_O = 'd6;//'d16
    localparam ADDR_WIDTH_MEMI = 'd6; //define Memory In depth
    localparam ADDR_WIDTH_MEMO = 'd6; //define Memory Out depth
    localparam SIZE_CR = 'd1; //define Configuration Register depth
    localparam STATUS_WIDTH = 'd8; //define status length
    localparam INT_WIDTH = 'd8; //define status length

    input wire clk;
    input wire rst_a;
    input wire en_s;
    input wire [DATA_WIDTH-1:0] data_in; //different data in information types
    output wire [DATA_WIDTH-1:0] data_out; //different data out information types
    input wire write; //Used for protocol to write different information types
    input wire read; //Used for protocol to read different information types
    input wire start; //Used to start the IP-core
    input wire [4:0] conf_dbus; //Used for protocol to determine different actions types
    output wire int_req; //Interruption request

    wire [DATA_WIDTH-1:0] data_MemIn0; //data readed for memory in 0
    wire [MEM_ADDR_MAX_WIDTH-1:0] rd_addr_MemIn0; //address read for memory in 0
	 wire [DATA_WIDTH-1:0] data_MemIn1; //data readed for memory in 1
    wire [MEM_ADDR_MAX_WIDTH-1:0] rd_addr_MemIn1; //address read for memory in 1

    wire [DATA_WIDTH-1:0] data_ConfigReg; //data readed for configuration register

    wire [DATA_WIDTH-1:0] data_MemOut0; //data to write for memory out 0
    wire [MEM_ADDR_MAX_WIDTH_O-1:0] wr_addr_MemOut0; //address write for memory out 0
    wire wr_en_MemOut0; //enable write for memory out 0

    wire start_IPcore; //Used to start the IP-core

    wire [STATUS_WIDTH-1:0] status_IPcore; //data of IP-core to set the flags value
    wire [INT_WIDTH-1:0] int_IPcore;
	 

	 
ID1000500C_aip
    INTERFACE
    (
        .clk (clk),
        .rst (rst_a),
        .en (en_s),
			
			 //--- AIP-Interface ---//
        .dataInAIP (data_in),
        .dataOutAIP (data_out),
        .configAIP (conf_dbus),
        .readAIP (read),
        .writeAIP (write),
        .startAIP (start),
        .intAIP (int_req),
		  

		   //--- IP-core ---//
		  .rdDataMemIn_0	(data_MemIn0), //X Data
		  .rdDataMemIn_1	(data_MemIn1), //Y Data
		  .rdAddrMemIn_0	(rd_addr_MemIn0), //X ADDR 
		  .rdAddrMemIn_1	(rd_addr_MemIn1), //Y ADDR


		  .wrDataMemOut_0	(data_MemOut0), 
		  .wrAddrMemOut_0	(wr_addr_MemOut0),
		  .wrEnMemOut_0	(wr_en_MemOut0),

		  .rdDataConfigReg	(data_ConfigReg),
		  
		  .statusIPcore_Busy	(status_IPcore[0]),
		  .intIPCore_Done	(int_IPcore[0]),
		  .startIPcore	(start_IPcore)
    );

conv_top DUT
		(
			.clk		(clk),
			.rstn		(rst_a),
			.start		(start_IPcore),
			.shape		(data_ConfigReg[10]),
			.sizeX		(data_ConfigReg[4:0]),
			.sizeY		(data_ConfigReg[9:5]),
			.dataX		(data_MemIn0[7:0]),
			.dataY		(data_MemIn1[7:0]),
			
			.memZ_addr	(wr_addr_MemOut0[5:0]),
			.memX_addr	(rd_addr_MemIn0[4:0]),
			.memY_addr	(rd_addr_MemIn1[4:0]),
			.data_Z_o		(data_MemOut0[15:0]),
			.busy		(status_IPcore[0]),
			.done		(int_IPcore[0]),
			.WE_Z	(wr_en_MemOut0)
			
			
);

assign data_MemOut0[31:16] = {16{1'b0}};
endmodule
