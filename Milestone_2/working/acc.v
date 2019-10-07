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
	reg [12:0] counter;
	
	wire sel, en;
	wire [21:0] b_ext, sum;
	
	initial begin
	   counter = 0;
	   end	
	//adder_p #(.l(B1)) add22_1(din, muxout, sum); //adder will automatically sign-ext
	acc_adder x1(din, muxout, sum); //(input, input, output)
	acc_ctrl r1(clk, rst, sel, en);	
	
	assign b_ext = {{14{b[7]}}, b}; //Extend from 8 bit to 22 bit
	
	always@(posedge clk)	begin
		if (en && counter>=5)	//if 4 clk cycles have passed
			dout <= sum;
			counter = counter +1;
	end
	
	always@(posedge clk)	begin
		accReg <= sum;
	end
	
	always@(*)	begin
		if(sel) //new data is ready to be accumulated
			muxout = b_ext; 
		else	//keep old value while new value is generated
			muxout = accReg; 
	end
	
	endmodule
		
	
	