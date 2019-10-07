module timer(
	input clk,
	input reset,
	input en,
	output timeOut
	);
	
	reg [31:0] count;
	reg timeOut;
	
	parameter [31:0] timeval = 1000000000;
	
	always@(posedge clk)	begin
		timeOut = 0;
		if (reset)
			count = timeval;
		else begin
			if(en)
				if(count == 0)
					timeOut = 1;
				else
					count = count - 1;
		end
	end
endmodule