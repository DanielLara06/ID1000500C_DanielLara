`timescale 1ns/1ns

module IP_MOD_CONV_TB();

            //----------------------------------------------------------
            //.......MANDATORY TB PARAMETERS............................
            //----------------------------------------------------------
localparam	CYCLE		    = 'd20, // Define the clock work cycle in ns (user)
            DATAWIDTH    = 'd32, // AIP BITWIDTH
            MAX_SIZE_MEM = 'd8,  // MAX MEMORY SIZE AMONG ALL AIP MEMORIES (Defined by the user)
            //------------------------------------------------------------
            //..................CONFIG VALUES.............................
            //------------------------------------------------------------           
            STATUS   = 5'd30,//Mandatory config
            IP_ID    = 5'd31,//Mandatory config
            MDATAIN_X  = 5'd0, // Config values defined in the CSV file
            ADATAIN_X 	= 5'd1,
				MDATAIN_Y  = 5'd2, // Config values defined in the CSV file
            ADATAIN_Y 	= 5'd3,
				MDATAOUT_Z  = 5'd4, // Config values defined in the CSV file
            ADATAOUT_Z 	= 5'd5,	
				CCONF_REG = 5'b00110,
				ACONF_REG = 5'b00111,
            //------------------------------------------------------------
            //..................PARAMETERS DEFINED BY THE USER............
            //------------------------------------------------------------
            SIZE_MEM     = 'd32,  //Size of the memories of the IP dummy
				SIZE_MEM2     = 'd64,  //Size of the memories of the IP dummy
				CONFVAL = 5'b00011, //Data for config. Register
				DATACONFREG = 10'b0101000101, //10'b1111111111,//10'b0101000101,
				SHAPE = 1'b1,
            INT_BIT_DONE = 'd0; //Bit corresponding to the Int Done flag.
            


//AIP Interface signals
reg			 readAIP;
reg			 writeAIP;
reg			 startAIP;
reg	[4:0] configAIP;
reg	[DATAWIDTH-1:0] dataInAIP;

wire		    intAIP;
wire	[DATAWIDTH-1:0] dataOutAIP;

reg   clk, rst_a, en_s;

//Clock source procedural block
always #(CYCLE/2) clk = !clk;


//DUT instance
IP_MOD_CONV
DUT
(
    .clk		(clk),
    .rst_a		(rst_a),
    .en_s		(en_s),
    .data_in	(dataInAIP),      //different data in information types
    .data_out	(dataOutAIP),     //different data out information types
    .write		(writeAIP),       //Used for protocol to write different information types
    .read		(readAIP),        //Used for protocol to read different information types
    .start		(startAIP),       //Used to start the IP core
    .conf_dbus	(configAIP),      //Used for protocol to determine different actions types
    .int_req	(intAIP)          //Interruption request
);

//Testbench stimulus
initial
   begin
      $display($time, " << Start Simulation >>");
      
      aipReset();  
      conv_task();
      
      $display($time, " << End Simulation >>");
      $stop;      
   end

task conv_task;
   //variables   
   //Auxiliar variables
   reg [DATAWIDTH-1:0] tb_data;

   reg [DATAWIDTH-1:0] dataSet_x [SIZE_MEM-1:0]; //para memoria de entrada
   reg [(DATAWIDTH*SIZE_MEM)-1:0] dataSet_packed_x; 
	
	reg [DATAWIDTH-1:0] dataSet_y [SIZE_MEM-1:0]; //para memoria de entrada
   reg [(DATAWIDTH*SIZE_MEM)-1:0] dataSet_packed_y; 
	
   reg [DATAWIDTH-1:0] result [64-1:0]; //para memoria de salida
   reg [(DATAWIDTH*64)-1:0] result_packed;
	
	reg [DATAWIDTH-1:0] s_z [64-1:0]; //para resultado desde Matlab
	//reg [(DATAWIDTH*64)-1:0] s_z_packed;
	
	integer i,f,x,j,z,data,status;
   begin
        // READ IP_ID
        getID(tb_data);
        $display ("%7T Read ID %h", $time, tb_data);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);
        
        //(INTERRUPTIONS) 
        //FOR ENABLING INTERRUPTIONS
        enableINT(INT_BIT_DONE);
        

        // RANDOM DATA GENERATION X
        //for (i = 0; i < 32; i=i+1) begin //generating random data
		  f = $fopen("S_X.txt","r");
		  j = 0;
		  while(!$feof(f)) begin
				status = $fscanf(f,"%h \n",data);
				dataSet_x[j] = data;  // bit inicio dato 1
				j = j + 1;
		  end
		  $fclose(f);
		  
         //dataSet_x[i] = $urandom%100;          
        //end     
        
        //****CONVERTION TO A SINGLE ARRAY X
        for (i = 0; i < (32) ; i=i+1) begin 
            dataSet_packed_x[DATAWIDTH*i+:DATAWIDTH] = dataSet_x[i]; 
        end        
        
        writeMem(MDATAIN_X, dataSet_packed_x, SIZE_MEM,0);
		  
		  // RANDOM DATA GENERATION Y
        //for (i = 0; i < 32; i=i+1) begin //generating random data
        x = $fopen("S_Y.txt","r");
        j = 0;
		  while(!$feof(x)) begin
				status = $fscanf(x,"%h \n",data);
				dataSet_y[j] = data;  // bit inicio dato 1
				j = j + 1;
		  end
		  $fclose(x);
				//dataSet_y[i] = $urandom%100;          
        //end     
        
        //****CONVERTION TO A SINGLE ARRAY Y
        for (i = 0; i < (32) ; i=i+1) begin 
            dataSet_packed_y[DATAWIDTH*i+:DATAWIDTH] = dataSet_y[i]; 
        end        
        
        writeMem(MDATAIN_Y, dataSet_packed_y, SIZE_MEM,0);
	
		  //Bringing Matlab's result 
		  z = $fopen("S_Z.txt","r");
        j = 0;
		  while(!$feof(z)) begin
				status = $fscanf(x,"%h \n",data);
				s_z[j] = data;  // bit inicio dato 1
				j = j + 1;
		  end
		  $fclose(z);
		  
        
        //CONFREG DECLARATION
		  tb_data[9:0] = DATACONFREG; 
		  tb_data[10]    = SHAPE; 
        $display("%7T Sending Configuration", $time);
        writeConfReg(CCONF_REG,tb_data,1,0);

        // START PROCESS
        $display("%7T Sending start", $time);
        start();

        /*// (WITHOUT INTERRUPTIONS) 
        //WAIT FOR DONE FLAG WITHOUT INTERRUPTS ENABLED
        tb_data = 0;
        while (!tb_data[0]) begin//checking bit DONE
            getStatus(tb_data);
            $display("%7T Status - %08x", $time, tb_data);
            #(CYCLE*10);
        end 
        //(WITHOUT INTERRUPTIONS)*/
        
        // (INTERRUPTIONS) 
        // WAIT FOR DONE FLAG WITH INTERRUPTIONS ENABLED     
        while (intAIP) begin//checking intAIP signal
            #(CYCLE*10);
        end
        // (INTERRUPTIONS)  
        
        $display("%7T Done flag detected!", $time);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);
        
        //CLEAR INT DONE FLAG
        clearINT(INT_BIT_DONE);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);     


        // READ MEM OUT
        readMem(MDATAOUT_Z, result_packed, SIZE_MEM2, 0);
        //*****CONVERTION TO A 2D ARRAY
        for (i = 0; i < ((64)) ; i=i+1) begin 
            result[i]= result_packed[DATAWIDTH*i+:DATAWIDTH]; 
        end
        
        $display ("\t\tO \t\tResult");
        for (i = 0; i < ((64)); i=i+1) begin
            //read_interface(MDATAOUT, tb_data);
            $display ("Read data %2d \t%8h \t%8h \t%s", i, result[i], s_z[i],(result[i] == s_z[i] ? "OK": "ERROR"));
				//$display ("Read data %2d \t%8h \t%8h \t%8h", i, dataSet_x[i], dataSet_y[i], result[i]); //(dataSet[i] === result[i] ? "OK": "ERROR"));
        end
        
		   //$display ("Read data %2d \t%8h \t%8h \t%s", i, dataSet[i], result[i], (dataSet[i] === result[i] ? "OK": "ERROR"));

		  
		  
		  
        // DISABLE INTERRUPTIONS
        disableINT(INT_BIT_DONE);

        #(CYCLE*15);
   
   end

endtask
//*******************************************************************
//*********************AIP TASKS DEFINITION**************************
//*******************************************************************

task aipReset;
   begin
      clk		= 1'b1;
      en_s		= 1'b1;
      readAIP	= 1'b0;
      writeAIP	= 1'b0;
      startAIP	= 1'b0;
      configAIP= 5'b00000;
      dataInAIP= 32'd0;
      
      rst_a		= 1'b0;	// reset is active
      #3 rst_a	= 1'b1;	// at time #n release reset
      #37;
   end
endtask


task getID;
   output [DATAWIDTH-1:0] read_ID;
      
      begin
         single_read(IP_ID,read_ID);
      end
endtask

task getStatus;
   output [DATAWIDTH-1:0] read_status;
      
      begin
         single_read(STATUS,read_status);
      end
endtask

task writeMem;
        input [                         4:0] config_value;
        input [(DATAWIDTH*32)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;

      integer i;
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = write_data[(i*DATAWIDTH)+:DATAWIDTH];
               writeAIP = 1'b1;
               #(CYCLE);
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task writeConfReg;
        input [                         4:0] config_value;
        input [(DATAWIDTH*MAX_SIZE_MEM)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;
        
        integer i;
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = write_data[(i*DATAWIDTH)+:DATAWIDTH];
               writeAIP = 1'b1;
               #(CYCLE);
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask



task readMem;
        input [                         4:0] config_value;   
        output[(DATAWIDTH*63)-1:0] read_data;     
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;        
        
        integer i;
        begin
            //SET POINTER
            single_write(config_value+1, offset);
        
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin               
               readAIP = 1'b1;
               #(CYCLE);
               read_data[(i*DATAWIDTH)+:DATAWIDTH]=dataOutAIP;
            end
            readAIP = 1'b0;
            #(CYCLE);
        end
endtask

task enableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
       
  begin

       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b1; //enabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task disableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
  begin
   
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b0; //disabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task clearINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] clear_value;
       reg [7:0] mask;
    
  begin
    
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       clear_value = 7'd1 <<  idxInt;

       single_write(STATUS, {8'd0,mask,8'd0,clear_value});//write status reg
  end
endtask

task start;
  begin
      startAIP = 1'b1;
      #(CYCLE);
      startAIP = 1'b0;
      #(CYCLE);
  end
endtask

task single_write;
        input [          4:0] config_value;
        input [DATAWIDTH-1:0] write_data;
        begin
            configAIP = config_value;
            dataInAIP = write_data;
            #(CYCLE)
            writeAIP = 1'b1;
            #(CYCLE)
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task single_read;
  input  [          4:0] config_value;
  output [DATAWIDTH-1:0] read_data;
  begin
      configAIP = config_value;
      #(CYCLE);
      readAIP = 1'b1;
      #(CYCLE);
      read_data = dataOutAIP;
      readAIP = 1'b0;
      #(CYCLE);
  end
endtask

endmodule

   