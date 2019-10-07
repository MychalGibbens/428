`timescale 1ns/1ps
module mult(
	input signed [7:0] a,
	input signed [7:0] b,
	output signed [15:0] s
	);
	
	assign s = a * b;
endmodule
