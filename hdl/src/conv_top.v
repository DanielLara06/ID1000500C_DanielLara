/******************************************************************
*Module name : conv_top
*Filename    : conv_top.v
*Type        : Verilog Module
*
*Description : Convolver Top entity.  
*					
*------------------------------------------------------------------
*	clocks    : posedge clock "clk"
*	reset		 : sync rstn,
* 
*Parameters  : none
*
* Author		 :	Daniel Alejandro Lara López
* email 		 :	Daniel.Lara@cinvestav.mx
* Date  		 :	24/04/2024
******************************************************************/
module conv_top(
	input clk,
	input rstn,
	input start,
	input shape,
	input  [4:0] sizeX,
	input  [4:0] sizeY,
	input  [7:0] dataX,
	input  [7:0] dataY,
	
	output [4:0] memX_addr, 
	output [4:0] memY_addr, //Adaptar y_i de 6 a 5 bits, no tomar el [6], es el mas significativo.
	output [5:0] memZ_addr,
	output  [15:0] data_Z_o,
	output WE_Z, //De máquina de estados 
	output busy, //De FSM
	output done); //De FSM
	
//Registers and wires
wire [4:0] size_x_2_mod;
wire [4:0] size_y_2_mod;
wire size_xclr_2_FSM;
wire sizex_en_2_FSM;
wire size_yclr_2_FSM;
wire sizey_en_2_FSM;
wire size_fullen_2_FSM;
wire size_fullclr_2_FSM;
wire [5:0] size_full_2_COMP;
wire size_sameen_2_FSM;
wire size_sameclr_2_FSM;
wire [4:0] size_same_2_COMP;
wire [15:0] multi_2_reg;
wire [15:0] multi_reg_2_ADD;
wire multi_reg_en;
wire multi_reg_clr;
wire [15:0] S_Z_data_2_ADD; 
wire [15:0] ADD_2_reg; 
wire ADD_FSM_2_regen;
wire ADD_FSM_2_regclr;
wire [15:0] ADD_2_S_Z_data_i;
wire [5:0] aux_reg_feedback;
wire [5:0] aux_ADD_2_reg;
wire FSM_2_aux_regen;
wire FSM_2_aux_regclr;
wire COMP_aux_2_FSM;
//wire [5:0] zind_reg_feedback;
wire [5:0] ADD_2_Zind_reg;
wire FSM_2_zind_regen;
wire FSM_2_zind_regclr;
//wire y_en_2_zind_clr; //Inicializador, asigna zind = aux o zind = y_i (misma frecuencia)
wire [5:0] zindreg_2_mux;
wire read_addr_i_sel_mux;
//wire [5:0] ptrreg_2_mux;
wire [5:0] read_addr_i;
wire [5:0] x_i_feedback;
wire [5:0] x_i_2_reg;
wire FSM_2_x_i_regen;
wire FSM_2_x_i_regclr;
wire COMP_x_2_FSM;
wire [5:0] y_i_feedback;
wire [5:0] y_i_2_reg;
wire FSM_2_y_i_regen;
wire FSM_2_y_i_regclr;
wire COMP_y_2_FSM;
wire [4:0] same_i_feedback;
wire [4:0] same_i_2_reg;
wire FSM_2_same_regen;
wire FSM_2_same_regclr;
wire COMP_same_2_FSM;
wire [5:0] init_same_2_mux;
wire FSM_2_init_samesel;
wire [5:0] mux_2_ptr;
wire [5:0] ptr_feedback;
wire [5:0] ptr_2_reg;
wire FSM_2_ptr_regen;
wire FSM_2_ptr_regclr;
wire s_z_we;
wire z_ind_same_sel;
wire aux_zind_en;
reg [5:0] aux_bit; 

//Design instances
	
size_x_reg U1 
		(
			.clk		(clk),
			.rstn		(rstn),
			.sizex_clr	(size_xclr_2_FSM), //salida de FSM
			.sizex_en (sizex_en_2_FSM),
			.sizeX_i		(sizeX),
			
			.size_x_o		(size_x_2_mod)
);	


size_y_reg U2 
		(
			.clk		(clk),
			.rstn		(rstn),
			.sizey_clr	(size_yclr_2_FSM), //salida de FSM
			.sizey_en (sizey_en_2_FSM), //Salida a FSM
			.sizeY_i		(sizeY),
			
			.size_y_o		(size_y_2_mod)
);	

sz_full_reg U3 
		(
			.clk		(clk),
			.rstn		(rstn),
			.sizex_i	(size_x_2_mod),
			.sizey_i	(size_y_2_mod),
			.size_full_en	(size_fullen_2_FSM), //Salida de FSM //Mismo estado que sz_same_reg para activación 
			.size_full_clr	(size_fullclr_2_FSM), //Salida de FSM	//Mismo clear que sz_same_reg para reseteo
			
			.size_full_o	(size_full_2_COMP) //Entrada de FSM
);
	
sz_same_reg U4 
		(
			.clk		(clk),
			.rstn		(rstn),
			.sizex_same_i	(size_x_2_mod),
			.size_same_en	(size_sameen_2_FSM), //Salida de FSM ////Mismo estado que sz_full_reg para activación 
			.size_same_clr	(size_sameclr_2_FSM), //Salida de FSM //Mismo estado que sz_full_reg para activación 
			
			.size_same_o	(size_same_2_COMP) //Entrada de FSM
);

multi U5
	(
		.S_X_in	(dataX),
		.S_Y_in	(dataY),
		
		.multi_o	(multi_2_reg)
);

multi_reg U6 
		(
			.clk		(clk),
			.rstn		(rstn),
			.multi_i	(multi_2_reg),
			.multi_reg_en	(multi_reg_en), //Salida de FSM 
			.multi_reg_clr	(multi_reg_clr), //Salida de FSM 
			
			.multi_o	(multi_reg_2_ADD) //Entrada de FSM
);

ADD U7
	(
		.multi_i	(multi_reg_2_ADD),
		.S_Z_data_i	(S_Z_data_2_ADD),
		
		.result_o	(ADD_2_reg)
);


ADD_reg U8

		(
			.clk	(clk),
			.rstn	(rstn),
			.ADD_reg_clr	(ADD_FSM_2_regclr), //Salida de FSM
			.ADD_reg_en	(ADD_FSM_2_regen), //Salida de FSM
			.ADD_2_reg_i	(ADD_2_reg), 
			
			.ADD_reg_o	(ADD_2_S_Z_data_i)
);




aux_ADD U9
		
	  (
		 .aux_i	(aux_reg_feedback),
		 
		 .aux_o	(aux_ADD_2_reg)
				
);


aux_reg U10

	  (
		   .clk	(clk),
			.rstn	(rstn),
			.aux_reg_i	(aux_ADD_2_reg),
			.aux_reg_en	(FSM_2_aux_regen), //Salida de FSM
			.aux_reg_clr	(FSM_2_aux_regclr), //Salida de FSM
			
			.aux_reg_o	(aux_reg_feedback)
);


aux_COMP U11
		(
			.aux_reg_i	(aux_reg_feedback),
			.sz_full_i	(size_full_2_COMP),
			
			.COMP_o	(COMP_aux_2_FSM)
);



zind_ADD U12

	 (
			.zind_i	(zindreg_2_mux),
			
			.zind_o	(ADD_2_Zind_reg)
);


zind_reg U13

	 (
			.clk	(clk),
			.rstn	(rstn),
			.zind_reg_i	(ADD_2_Zind_reg),
			.y_i	(y_i_feedback),
			.zind_en	(FSM_2_zind_regen), //Salida de FSM
			.zind_clr	(FSM_2_zind_regclr), //Salida de FSM
			.y_i_en_clr	(aux_zind_en),
			
			.zind_reg_o	(zindreg_2_mux) 
);

mux U14 //Multiplexor conectado a la entrada addr de la memoria interna 
	 (
			.select	(read_addr_i_sel_mux), 
			.i_one	(ptr_feedback), 
			.i_zero	(zindreg_2_mux),
			
			.mux_o	(read_addr_i)
				 
);

x_i U15
	(
		.x_ind_i	(x_i_feedback), 
		
		.x_ind_o	(x_i_2_reg)
);
		
x_i_reg U16
	(
		.clk	(clk),
		.rstn	(rstn),
		.x_ind_i	(x_i_2_reg),
		.x_ind_en	(FSM_2_x_i_regen), //Salida de FSM
		.x_ind_clr	(FSM_2_x_i_regclr), //Salida de FSM
		
		.x_ind_o	(x_i_feedback) 
);

x_i_COMP  U17
		(
			.x_i	(x_i_feedback),
			.sz_x	(size_x_2_mod),
			
			.COMP_x_o	(COMP_x_2_FSM) //A FSM
);
	
	
	
y_i U18
	(
		.y_ind_i	(y_i_feedback), 
		
		.y_ind_o	(y_i_2_reg)
);




y_i_reg U19
	(
		.clk	(clk),
		.rstn	(rstn),
		.y_ind_i	(y_i_2_reg),
		.y_ind_en	(FSM_2_y_i_regen), //Salida de FSM
		.y_ind_clr	(FSM_2_y_i_regclr), //Salida de FSM
		
		.y_ind_o	(y_i_feedback) 
);


y_i_COMP U20
		(
			.y_i	(y_i_feedback),
			.sz_y	(size_y_2_mod),
			
			.COMP_y_o	(COMP_y_2_FSM) //A FSM
);


same_i U21
	(
		.same_index_i	(same_i_feedback), 
		
		.same_index_o	(same_i_2_reg)
);

same_i_reg U22
	(
		.clk	(clk),
		.rstn	(rstn),
		.same_ind_i	(same_i_2_reg),
		.same_ind_en	(FSM_2_same_regen), //Salida de FSM
		.same_ind_clr	(FSM_2_same_regclr), //Salida de FSM
		
		.same_ind_o	(same_i_feedback) //******
);


same_i_COMP U23
		(
			.same_i	(same_i_feedback),
			.sz_same	(size_same_2_COMP),
			
			.COMP_same_o	(COMP_same_2_FSM) //A FSM
);	

init_same U24

	(
		.size_y_i	(size_y_2_mod),
		
		.oper_o	(init_same_2_mux)	
	
);

mux U25 //Multiplexor después de init_same

	(
		.select	(FSM_2_init_samesel), //Salida FSM
		.i_one	(init_same_2_mux), //inicialización
		.i_zero	(ptr_feedback),
		
		.mux_o	(mux_2_ptr)
	
);


ptr_i U26

	(
		.init_same_i	(mux_2_ptr),
		
		.ptr_o	(ptr_2_reg)
);

ptr_reg U27
	
	(
		.clk	(clk),
		.rstn	(rstn),
		.ptr_i	(ptr_2_reg),
		.ptr_en	(FSM_2_ptr_regen), //Salida FSM
		.ptr_clr	(FSM_2_ptr_regclr), //Salida FSM
		
		.ptr_o	(ptr_feedback)
);
	
	
	
s_z_mem U28 //Full size convolution memory

	(
		.clk	(clk),
		.write_en_i	(s_z_we), //Salida FSM
		.write_addr_i	(zindreg_2_mux), //Mismo contador que read_addr
		.read_addr_i	(read_addr_i),
		.write_data_i	(ADD_2_S_Z_data_i),
		
		.read_data_o	(S_Z_data_2_ADD)
);

always@(posedge clk, negedge rstn) begin 
	if (!rstn)
		aux_bit = 6'b000000;
	else if(WE_Z) begin
		aux_bit = aux_bit + 6'b000001;
	end
	
end

mux U29 //Multiplexor para contador de salida

	(
		.select	(z_ind_same_sel), //Salida FSM
		.i_one	(zindreg_2_mux), //inicialización
		.i_zero	(aux_bit),//{1'b0,same_i_feedback}
		
		.mux_o	(memZ_addr)
	
);


FSM U30 //*******************Checar temprano 
	(
		.clk	(clk),
		.rstn	(rstn),
		.start_i	(start),
		.shape_i	(shape),
		.x_i_COMP_i	(COMP_x_2_FSM),
		.y_i_COMP_i	(COMP_y_2_FSM),
		.same_i_COMP_i	(COMP_same_2_FSM),
		.aux_i_COMP_i	(COMP_aux_2_FSM),
		
		
		.busy	(busy),
		.done	(done),
		.sizex_clr	(size_xclr_2_FSM),
		.sizex_en	(sizex_en_2_FSM),
		.sizey_clr	(size_yclr_2_FSM),
		.sizey_en	(sizey_en_2_FSM),	
		.size_full_en	(size_fullen_2_FSM),
		.size_full_clr	(size_fullclr_2_FSM),
		.size_same_en	(size_sameen_2_FSM),
		.size_same_clr	(size_sameclr_2_FSM),
		.multi_reg_en	(multi_reg_en),
		.multi_reg_clr	(multi_reg_clr),	
		.ADD_reg_en	(ADD_FSM_2_regen),
		.ADD_reg_clr	(ADD_FSM_2_regclr),
		.aux_en	(FSM_2_aux_regen),
		.aux_clr	(FSM_2_aux_regclr),
		.zind_en	(FSM_2_zind_regen),
		.zind_clr	(FSM_2_zind_regclr),
		.aux_2_zind (aux_zind_en),
		.read_addr_sel	(read_addr_i_sel_mux),
		.x_ind_en	(FSM_2_x_i_regen),
		.x_ind_clr	(FSM_2_x_i_regclr),
		.y_ind_en	(FSM_2_y_i_regen),
		.y_ind_clr	(FSM_2_y_i_regclr),
		.same_ind_en	(FSM_2_same_regen),
		.same_ind_clr	(FSM_2_same_regclr),
		.init_same_sel	(FSM_2_init_samesel),
		.ptr_en	(FSM_2_ptr_regen),
		.ptr_clr	(FSM_2_ptr_regclr),
		.we_s_z	(s_z_we),
		.WE_Z	(WE_Z),
		.z_ind_same_reg_sel	(z_ind_same_sel)

);


//Direct Assignments 
assign data_Z_o = S_Z_data_2_ADD;
assign memX_addr = x_i_feedback[4:0];
assign memY_addr = y_i_feedback[4:0];	
	
endmodule
	