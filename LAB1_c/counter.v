module counter(
	input clk,
	input reset,
	input en,
	output cntOut
	);
	
	reg [7:0] count;
	reg cntOut;
	
	parameter [7:0] cntval = 3;
	
	always@(posedge clk)	begin
		if(reset)	begin
			count = cntval;
			cntOut = 0;
		end
		else begin	
			if(count == 0)
				cntOut = 1;
			else
				if(en) begin
				cntOut = 0;
				count = count - 1;
				end
				else	begin
					cntOut = 0;
				end
		end
	end
endmodule
				
		