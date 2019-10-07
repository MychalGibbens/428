`timescale 1ns / 1ps
module top(
input clk,
input reset,		//SW0
input LB,			//SW1
input LP,			//SW2
input on, 			//SW3
output ready,		//P3
output led_1v,		//N3
output led_2v,		//P1
output led_3v,		//L1
output power_led,	//V19
output battery_led
//output [4:0] c_state,
//output [4:0] active,
//output T	//W18	
);

	wire [27:0] data;
	wire [1:0] sel;
	wire load, cnt_enable;
	wire T;
	

	mux MUX(sel, data);

	counter count(clk, reset, cnt_enable, load, data, , T);

	FSM pmic(
	.clk(clk),
	.reset(reset),
	.on(on),
	.LB(LB),
	.LP(LP),
	.T(T),
	.ready(ready),
	.led_3v(led_3v),
	.led_2v(led_2v),
	.led_1v(led_1v),
	.power_led(power_led),
	.battery_led(battery_led)
	//.c_state(c_state),
	//.active(active)
	);
    
endmodule