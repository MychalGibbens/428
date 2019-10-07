`timescale 1ns/1ps
module acc_adder(
	input signed [19:0] a,
	input signed [21:0] b,
	output signed [21:0] s
	);
	assign s = a + b;
endmodule
