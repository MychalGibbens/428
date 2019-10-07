`timescale 1ns/1ps
module adder17(
	input signed [16:0] a,
	input signed [16:0] b,
	output signed [17:0] s
	);
	
	assign s = a + b;
endmodule
