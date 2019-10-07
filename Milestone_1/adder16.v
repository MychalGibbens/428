`timescale 1ns/1ps
module adder16(
	input signed [15:0] a,
	input signed [15:0] b,
	output signed [16:0] s
	);
	
	assign s = a + b;
endmodule
