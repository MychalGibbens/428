`timescale 1ns/1ps
module adder18(
	input signed [17:0] a,
	input signed [17:0] b,
	output signed [18:0] s
	);
	
	assign s = a + b;
endmodule
