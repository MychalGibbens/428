`timescale 1ns / 1ps
module FSM(
	input clk,
	input reset,
	input on,
	input LB,
	input LP,
	input T,
	output ready, led_3v, led_2v, led_1v, power_led, battery_led,
	output reg [4:0] c_state,
	output reg [4:0] active
	);
	
	//wire ready, led_3v, led_2v, led_1v;
	reg load, cnt_enable;
	reg [1:0] sel;
	reg [5:0] light;
	reg [4:0] n_state;
	//reg [3:0] active;
   
	//Power - On Sequence
	parameter   OFF   		=  	5'b00000   ;
	parameter   countT1  	=  	5'b00001   ;
	parameter   turnon2_5   =  	5'b00010   ;
	parameter   countT2 	=  	5'b00011   ;
	parameter   turnon1_2   =  	5'b00100   ;
	parameter   ON    		=  	5'b00101   ;
	
	//Power - Off Sequence
	parameter   countT3    	=  	5'b00110   ;
	parameter   turnoff1_2 	=  	5'b00111   ;
	parameter   countT4  	=   5'b01000   ;
	parameter   turnoff2_5 	=   5'b01001   ;
	parameter   countT5  	=   5'b01010   ;
	parameter   turnoff3_3  =  	5'b01011   ;
	
	//Low - Power Sequence
	parameter   lowPT4  	=  	5'b01100   ;
	parameter   lowP2off   	=   5'b01101   ;
	parameter   lowPT5  	=  	5'b01110   ;
	parameter   lowP3off   	=  	5'b01111   ;
	parameter   lowP  		=  	5'b10000   ;
    
	always@(*) begin	
	case(c_state)	
	//Power - On Sequence
	OFF: begin
		if(on && !LB)	begin
			n_state <= countT1; active <= 5'b10000; sel <= 2'b00; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= OFF; active <= 5'b00000; sel <= 2'b00; load <= 0; cnt_enable <= 0; end
		end
		
	countT1: begin
		n_state <= turnon2_5; active <= 5'b10000; sel <= 2'b00; load <= 0; cnt_enable <= 1;
		end
		
	turnon2_5: begin
		if(T)	begin
			n_state <= countT2; active <= 5'b00010; sel <= 2'b01; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= turnon2_5; active <= 5'b10000; sel <= 2'b00; load <= 0; cnt_enable <= 1; end
		end
		
	countT2: begin
		n_state <= turnon1_2; active <= 5'b00010; sel <= 2'b01; load <= 0; cnt_enable <= 1;
		end
		
	turnon1_2: begin
		if(T)	begin
			n_state <= ON; active <= 5'b00100; sel <= 2'b01; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= turnon1_2; active <= 5'b00010; sel <= 2'b01; load <= 0; cnt_enable <= 1; end
		end
		
	ON: begin
		if(LP) begin
			n_state <= lowPT4; active <= 5'b00101; sel <= 2'b10; load <= 1; cnt_enable <= 1; end
		else if(LB || !on) begin	
			n_state <= countT3; active <= 5'b01000; sel <= 2'b00; load <= 1; cnt_enable <= 1; end
		else begin
			n_state <= ON; active <= 5'b00100; sel <= 2'b00; load <= 0; cnt_enable <= 0; end
		end
		
	//Power - Off Sequence	
	countT3: begin
			n_state <= turnoff1_2; active <= 5'b01000; sel <= 2'b00; load <= 0; cnt_enable <= 1; 
		end

	turnoff1_2: begin
		if(T)	begin
			n_state <= countT4; active <= 5'b01001; sel <= 2'b10; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= turnoff1_2; active <= 5'b01000; sel <= 2'b00; load <= 0; cnt_enable <= 1; end
		end
		
	countT4: begin
		n_state <= turnoff2_5; active <= 5'b01001; sel <= 2'b10; load <= 0; cnt_enable <= 1; 
		end
		
	turnoff2_5: begin
		if(T)	begin
			n_state <= countT5; active <= 5'b01010; sel <= 2'b10; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= turnoff2_5; active <= 5'b01001; sel <= 2'b10; load <= 0; cnt_enable <= 1; end
		end
		
	countT5: begin
		n_state <= turnoff3_3; active <= 5'b01010; sel <= 2'b10; load <= 0; cnt_enable <= 1;
		end
		
	turnoff3_3: begin
		if(T)	begin
			n_state <= OFF; active <= 5'b00000; sel <= 2'b00; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= turnoff3_3; active <= 5'b01010; sel <= 2'b10; load <= 0; cnt_enable <= 1; end
		end
		
	//Low - Power Sequence	
	lowPT4: begin
		n_state <= lowP2off; active <= 5'b00101; sel <= 2'b10; load <= 0; cnt_enable <= 1;
		end		
		
	lowP2off: begin
		if(T)	begin
			n_state <= lowPT5; active <= 5'b00110; sel <= 2'b10; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= lowP2off; active <= 5'b00101; sel <= 2'b10; load <= 0; cnt_enable <= 1; end
		end
		
	lowPT5: begin
		n_state <= lowP3off; active <= 5'b00110; sel <= 2'b10; load <= 0; cnt_enable <= 1;
		end
		
	lowP3off: begin
		if(T)	begin
			n_state <= lowP; active <= 5'b00111; sel <= 2'b00; load <= 1; cnt_enable <= 1; end
		else	begin
			n_state <= lowP3off; active <= 5'b00110; sel <= 2'b10; load <= 0; cnt_enable <= 1; end
		end
		
	lowP: begin
		if(LB || !on) begin
			n_state <= OFF; active <= 5'b00000; sel <= 2'b00; load <= 0; cnt_enable <= 0; end
		else if(on && !LP) begin	
			n_state <= ON; active <= 5'b00100; sel <= 2'b00; load <= 0; cnt_enable <= 0; end
		else begin
			n_state <= lowP; active <= 5'b00111; sel <= 2'b10; load <= 0; cnt_enable <= 0; end  
		end
		
	default: n_state <= OFF;
	endcase
	end

	//update state registers 
   	always@(posedge clk or posedge reset)	begin
   		if(reset)  begin
         		c_state  <=  OFF    ;
         		light[5:0] <= 0;	end
   		else   begin
         		c_state <=  n_state ;	end
        end
        
	  always@(c_state)begin                
	   case(active)
	   //Power - On Sequence
	   5'b00000: light = 6'b000000; //All zero outputs
	   5'b00001: light = 6'b100000; //3.3V LED active
	   5'b00010: light = 6'b110000; //3.3, 2.5V LED active
	   5'b00011: light = 6'b111000; //3.3, 2.5, and 1.2V active
	   5'b00100: light = 6'b111100; //Power-On sequence success
	   //Low - Power Sequence
	   5'b00101: light = 6'b111110; //Low-Power sequence started
	   5'b00110: light = 6'b101110; //Low-Power, only 1.2, 3.3V on
	   5'b00111: light = 6'b001110; //Low-Power only 1.2V on	
	   //Power - Off Sequence
	   5'b01000: light = 6'b111001; //Low Battery Active
	   5'b01001: light = 6'b110001; //Low Battery only 2.5, 3.3V active
	   5'b01010: light = 6'b100001; //Low Battery only 3.3V active
	   5'b01011: light = 6'b000001; //All turned off, go to OFF state
	  
	   default: light <= 6'b000000; //
	   endcase
	  end 
	
	assign {led_3v,led_2v,led_1v,ready,power_led,battery_led} = {light[5:0]};
  
endmodule
	
	
	
	
	
	
	
	
	
	
	
	
