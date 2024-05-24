/******************************************************************
*Module name : FSM
*Filename    : FSM.v
*Type        : Verilog Module
*
*Description : Finite State Machine for convolver data flow
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

module FSM(
   input  clk,
   input  rstn,
   input  start_i,
	input  shape_i,
	input  x_i_COMP_i,//Bandera del comparador para el contador de x_i
	input  y_i_COMP_i,////Bandera del comparador para el contador de y_i
	input  same_i_COMP_i, //Bandera del comparador para el contador de same_i
   input  aux_i_COMP_i, //Bandera del comparador para el contador de aux_i - para inicializar memoria
	
	output reg busy,
	output reg done,	
	//size_x_reg 
	output reg sizex_clr,
	output reg sizex_en,
	//size_y_reg 
	output reg sizey_clr,
	output reg sizey_en,
	//sz_full_reg
	output reg size_full_en,
	output reg size_full_clr,
	//sz_same_reg
	output reg size_same_en,
	output reg size_same_clr,
	//multi_reg
	output reg multi_reg_en,
	output reg multi_reg_clr,
	//ADD_reg
	output reg ADD_reg_clr,
	output reg ADD_reg_en,
	//aux_reg
	output reg aux_en,
   output reg aux_clr,
	//zind_reg
	output reg zind_en,
   output reg zind_clr,
	output reg aux_2_zind,
	//mux1 - selector de dirección de lectura de memoria interna
	output reg read_addr_sel,
	//x_i_reg
	output reg x_ind_en,
   output reg x_ind_clr,
	//y_i_reg
	output reg y_ind_en,
   output reg y_ind_clr,
	//same_i_reg
	output reg same_ind_en,
   output reg same_ind_clr,
	//mux2 - //Multiplexor después de init_same
	output reg init_same_sel,
	//ptr_reg
	output reg ptr_en,
   output reg ptr_clr,
	//s_z_mem - memoria s_z interna
	output reg we_s_z,
	//WE_Z
	output reg WE_Z,
	output reg z_ind_same_reg_sel
	
);


 localparam [4:0] S1=5'b00001, S2=5'b00010, S3=5'b00011, S4=5'b00100, S5=5'b00101, S6=5'b00110, 
 S7=5'b00111, S8=5'b01000, S9=5'b01001, S10=5'b01010, S11=5'b01011, S12=5'b01100, S13=5'b01101,	
 S14=5'b01110,	S15=5'b01111, S16=5'b10000, S17=5'b10001, S18=5'b10010, S19=5'b10011, S20=5'b10100,
 S21=5'b10101, S22=5'b10110,S23=5'b10111, S24=5'b11000, S25=5'b11001; 

 reg [4:0] state;
 reg [4:0] next;

 //(1) State register
 always@(posedge clk or negedge rstn)
     if(!rstn) 
			state <= S1;                                            
     else      
			state <= next;

			
 //(2) Combinational next state logic
 always@* begin
     //next = XX;
     case(state)
         S2: if(start_i) 
					next = S3;
             else      //@ loopback
					next = S2;
         S3:   
				 next = S4;     
         
         S4:             
				 next = S5;
			
			S5: if(aux_i_COMP_i)
					next = S6;
				 else 
					next = S5;

			S6: 
				 next = S7;
					
		   S7:             //**
				 next = S8;
				 
		   S8:             
				 next = S9;
			
			S9:     
				 next = S10;
				 
			S10:     
				 next = S11;	 
				 
			S11:     
				 next = S12; 
			
			S12:     
				 next = S13; 
			

			S13: if(x_i_COMP_i) //** todo X //
					 next = S14;
				  else 
					 next = S7;		
			S14: 
				  next = S15;
				  
		   S15:  
				  next = S16;
				  
		   S16: 
				  next = S17;
		   
					 
		   S17: if(y_i_COMP_i) //Todo Y
					 next = S18;
				  else 
					 next = S7;
			S18: 
					next = S19;
			
			S19: if(shape_i)
					 next = S20;
					else 
					 next = S23;
			
//			S14: if(aux_i_COMP_i)
//					 next = S15;
//					else 
//					 next = S14;
			S20: 
					next = S21;
			
			S21: if(aux_i_COMP_i)
						next = S22;
					else 
						next = S20;
			S22: 
					next = S2;
					
			
			S23: 
					next = S24;
			
			S24: if(same_i_COMP_i)
					 next = S25;
					else 
					 next = S23; 
			S25: 
					next = S2;
	
         default:  next = S2;
     endcase
 end
 

 //(3) Registered output logic (Moore outputs)
 always@(posedge clk or negedge rstn) begin
     if(!rstn) begin //S1
         busy <= 1'b0;
			done <= 1'b0;
			sizex_clr <= 1'b1;
			sizex_en  <= 1'b0;
			sizey_clr <= 1'b1;
			sizey_en <= 1'b0;
			size_full_en <= 1'b0;
			size_full_clr <= 1'b1;		
			size_same_en <= 1'b0;
			size_same_clr <= 1'b1;
			aux_en <= 1'b0;
			aux_clr <= 1'b1;		
			multi_reg_en <= 1'b0;
			multi_reg_clr <= 1'b1;
			ADD_reg_en <= 1'b0;
			ADD_reg_clr  <= 1'b1;
			zind_en <= 1'b0;
			zind_clr <= 1'b1;
			aux_2_zind <= 1'b0;
			read_addr_sel <= 1'b0;// 1 Ptr_reg 0 zind
			x_ind_en <= 1'b0;
			x_ind_clr <= 1'b1;			
			y_ind_en <= 1'b0;
         y_ind_clr <= 1'b1;			
			same_ind_en <= 1'b0;
			same_ind_clr <= 1'b1;		
			init_same_sel <= 1'b1; //1 init_same 0 ptr feedback
		   ptr_en <= 1'b0;
         ptr_clr <= 1'b1;
			we_s_z <= 1'b0;
		   WE_Z <= 1'b0;	
			z_ind_same_reg_sel <= 1'b1; //1 zind reg 0 same
     end
     else begin
         //dout_o <= 3'b000;//First default values!
			//enable y selectores de muxes
			busy <= 1'b0;
			done <= 1'b0;
			sizex_en  <= 1'b0;
			sizey_en <= 1'b0;
			size_full_en <= 1'b0;
			size_same_en <= 1'b0;
			aux_en <= 1'b0;
			multi_reg_en <= 1'b0;
			ADD_reg_en <= 1'b0;
			zind_en <= 1'b0;
			//read_addr_sel <= 1'b0;// 1 Ptr_reg 0 zind - mux1
			x_ind_en <= 1'b0;
			y_ind_en <= 1'b0;
			same_ind_en <= 1'b0;
			init_same_sel <= 1'b1; //1 init_same 0 ptr feedback - mux2
			ptr_en <= 1'b0; 
			we_s_z <= 1'b0; //we memoria interna
		   WE_Z <= 1'b0; //WE salida
			aux_2_zind <= 1'b0;
			//z_ind_same_reg_sel <= 1'b1; //1 zind reg 0 same - mux3
			

			//Clrs 
			sizex_clr <= 1'b0;
			sizey_clr <= 1'b0;
			size_full_clr <= 1'b0;
			size_same_clr <= 1'b0;
			aux_clr <= 1'b0;
			multi_reg_clr <= 1'b0;
			ADD_reg_clr  <= 1'b0;
			zind_clr <= 1'b0;
			x_ind_clr <= 1'b0;
			y_ind_clr <= 1'b0;
			same_ind_clr <= 1'b0;
			ptr_clr <= 1'b0;			  
			
             case(next)	
						 S2: if(start_i) begin
									busy <= 1'b1;
									done <= 1'b0;
									aux_clr <= 1'b1;
								   x_ind_clr <= 1'b1;
								   y_ind_clr <= 1'b1;
								   same_ind_clr <= 1'b1;
								   ptr_clr <= 1'b1;
								   sizex_clr <= 1'b1;
								   sizey_clr <= 1'b1;
								   size_full_clr <= 1'b1;
								   size_same_clr <= 1'b1;
								   zind_clr <= 1'b1;
								   multi_reg_clr <= 1'b1;
								   ADD_reg_clr  <= 1'b1;
									
									//Particularmente
									//ptr_clr <= 1'b1;
									ptr_en <= 1'b1; 
								 end
							 else begin     //IDLE
									busy <= 1'b0;
									done <= 1'b0;
								 end
						 S3: begin 
								 sizex_en  <= 1'b1;
								 sizey_en <= 1'b1;
								// ptr_en <= 1'b1;
							  end
						 S4: begin 
								size_full_en <= 1'b1;
								size_same_en <= 1'b1;
								 ptr_en <= 1'b1;
							  end
						 S5: if(aux_i_COMP_i) begin
										aux_en <= 1'b0;
										we_s_z <= 1'b0;
										ADD_reg_clr  <= 1'b0; //Tener cuidado de si el valor que se actualiza de la suma efectua la escritura de la memoria al instante o un ciclo despues de ser ese el caso mover we o ADD (we preferentemente) 
										//zind_clr <= 1'b1;
									end
							  else begin
										aux_en <= 1'b1;
										we_s_z <= 1'b1;
										ADD_reg_clr  <= 1'b1; //Tener cuidado de si el valor que se actualiza de la suma efectua la escritura de la memoria al instante o un ciclo despues de ser ese el caso mover we o ADD (we preferentemente)
										zind_en <= 1'b1; 
									end
						 S6: begin 
									aux_clr <= 1'b1;
									zind_clr <= 1'b1;
							  end
						 S7: begin 
									multi_reg_en <= 1'b1;
							  end
						 S8: begin 
									ADD_reg_en <= 1'b1; //Tener cuidado de si el valor que se actualiza de la suma efectua la escritura de la memoria al instante o un ciclo despues de ser ese el caso mover we o ADD (we preferentemente)
									//we_s_z <= 1'b1;
							  end
						 S9: begin 
									zind_en <= 1'b1;
									we_s_z <= 1'b1;
							  end
						 S10: begin 
									x_ind_en <= 1'b1;
							  end
							  
							  
							  
//						 S11: begin 
//									x_ind_clr <= 1'b1;
//							  end  					  
						 S13: if(x_i_COMP_i) begin
									//x_ind_en <= 1'b1;//*****
										x_ind_clr <= 1'b1;
										y_ind_en <= 1'b1;
									end

//	S14: 
//				  next = S15;
//				  
//		   S15:  
//				  next = S16;
//				  
//		   S16: 
//				  next = S17;								
									
									
								//else 
									//x_ind_en <= 1'b1;
						 S15: begin //Cambie de 14 a 13
									aux_2_zind <= 1'b1; 
							   end
//						 S12: if(y_i_COMP_i)
//									y_ind_en <= 1'b0; 13 dummy        Pasan estados 13 y 14
//								else 
//									y_ind_en <= 1'b1;

			//S16
						 
						S18: begin
									zind_clr <= 1'b1;
							  end
								
						S19: if(shape_i) begin
										//zind_clr <= 1'b1;
										read_addr_sel <= 1'b0; //Poner en todos los estados restantes así 
										z_ind_same_reg_sel <= 1'b0; //1 zind reg 0 same - mux3
									end
								else begin
										read_addr_sel <= 1'b1; //Poner en todos los estados restantes así 
										z_ind_same_reg_sel <= 1'b0; //1 zind reg 0 same - mux3 //One hot
								end
								
						S20: begin
									zind_en <= 1'b1;
									aux_en <= 1'b1;
									read_addr_sel <= 1'b0; //Poner en todos los estados restantes así 
							  end
					   S21: begin
									same_ind_en <= 1'b1;
									WE_Z <= 1'b1; 
							  end 
					  
						S22:  begin 
									busy <= 1'b0;
									done <= 1'b1;
							   end							
								
						S23: begin 
									ptr_en <= 1'b1;
									//WE_Z <= 1'b1; cambiar
									init_same_sel <= 1'b0;
							   end
								
						S24: begin 
									WE_Z <= 1'b1;
									init_same_sel <= 1'b0; //Tener cuidado con esta ventana
									same_ind_en <= 1'b1;
							   end
						S25: begin 
									busy <= 1'b0;
									done <= 1'b1;
							   end
										
             endcase
     end

 end

endmodule
