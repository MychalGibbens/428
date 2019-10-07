`timescale 1ns/1ps
module adder19(
	input signed [18:0] a,
	input signed [18:0] b,
	output signed [19:0] s
	);
	
	assign s = a + b;
endmodule
