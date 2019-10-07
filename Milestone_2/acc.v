`timescale 1ns/1ps
module acc(
	input [19:0] din,
	input [7:0] b,
	input clk,
	input rst,
	output [21:0] dout
	);
	//parameter B1 = 22;
	
	reg [21:0] accReg, muxout;
	reg [21:0] dout;
	
	wire sel, en;
	wire [21:0] b_ext, sum;
	
	//adder_p #(.l(B1)) add22_1(din, muxout, sum); //adder will automatically sign-ext
	acc_adder x1(din, muxout, sum);
	acc_ctrl r1(clk, rst, sel, en);	
	
	assign b_ext = {{14{b[7]}}, b}; //Extend from 8 bit to 22 bit
	
	always@(posedge clk)	begin
		if (en)
			dout <= sum;
	end
	
	always@(posedge clk)	begin
		accRef <= sum;
	end
	
	always@(*)	begin
		if(sel)
			muxout = b_ext;
		else
			muxout = accReg;
	end
	
	endmodule
		
	
	