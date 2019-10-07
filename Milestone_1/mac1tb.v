`timescale 1ns/1ps
module mac1tb();

	parameter half_cycle = 20;
	reg [127:0] data_p [39:0];	//Training with 40 input images
	reg [127:0] data_w [39:0];	//Each of which is 128 bits total (8b x 8b)
	wire [19:0] s;
	
	reg [127:0] p, w;
	reg [7:0] count;
	reg clk;
	wire clk2;
	
	integer outfile;	//Won't change in waveform
	
	assign #2 clk2 = clk;	//delayed clk
	
	mac1 r3(p, w, s);
	
	initial begin
		$readmemh("digits_hex.mem", data_p);
		$readmemh("weights_hex.mem", data_w);
		outfile = $fopen("dick.txt", "w");	//Just a value to recognize output file
		clk = 0;
		count = 0;
		end
		
		always #half_cycle clk = !clk;
		
		//write to file
		always@(posedge clk)	begin
			if(count>0)
				$fdisplay(outfile, "%h", s);	end
				
		always@(posedge clk2) begin
			p = data_p[count];
			w = data_w[count];
			count = count + 1;
			if(count == 41)	begin
				$fclose(outfile);
				$finish;
			end
		end
endmodule
