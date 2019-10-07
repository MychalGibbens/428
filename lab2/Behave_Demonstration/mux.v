`timescale 1ns / 1ps
module mux(
input [1:0] sel,
output [27:0] out 
);


reg [27:0] out;

always @(sel) begin
	if(sel == 2'b00) begin	
		out = 4;	end	//100000000	t1 and t3
	else if(sel == 2'b01) begin	
		out = 5;	end	//150000000	t2
	else if(sel == 2'b10) begin	
		out = 2;	end //50000000	t4 and t5
	else	begin
		out = 28'hxxxxxxx;	end
	end
    
endmodule