`timescale 1ns / 1ps
module mux(
input [1:0] sel,
output [39:0] out 
);


reg [39:0] out;

always @(sel) begin
	if(sel == 2'b00) begin	
		out = 1000000000;	end	//100000000	t1 and t3
	else if(sel == 2'b01) begin	
		out = 1000000000;	end	//150000000	t2
	else if(sel == 2'b10) begin	
		out = 1000000000;	end //50000000	t4 and t5
	else	begin
		out = 40'hxxxxxxxxxx;	end
	end
    
endmodule