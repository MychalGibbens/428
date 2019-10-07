`timescale 1ns / 1ps
module counter(
input clk,
input reset,
input cnt_enable,
input load,
input [27:0] data,
output [27:0] out,
output T
);

	reg [27:0] out;

	always @(posedge clk) begin
	if(reset)	begin
		out <= 0;	end
	else if(load)	begin
		out <= data;	end
	else if(cnt_enable)	begin	
		out <= out - 1;	end
	end
	
	assign T = (~|out);
endmodule