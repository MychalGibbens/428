`timescale 1ns / 1ps
module tb();			
	
	reg clk;
	reg reset;
	reg LB;
	reg LP;
	reg on;
	//wire [4:0] c_state;
	//wire [4:0] active;
	reg led_3v, led_2v, led_1v, ready, power_led, battery_led;
	wire T;
	
	top r1(clk, reset, LB, LP, on, ready, led_3v, led_2v, led_1v, power_led, battery_led, T);

	initial begin
		reset = 1; clk = 0; LB = 0; LP = 0; on = 0; led_3v = 0; led_2v = 0; led_1v = 0; ready = 0; power_led = 0; battery_led = 0;
	end

	always
		#5 clk = !clk;

	initial begin
		#50 reset = 0;
		#50 on=1;
		#200 LP=1;
		#200; LP=0;
        #200;
		reset = 1;
		#50;
		reset = 0;
		#100;
		#100 LB=1;
		#300;

		$finish;
	end
endmodule
		
			

