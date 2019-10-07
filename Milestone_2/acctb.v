`timescale 1ns/1ps
module acctb();
	parameter half_cycle = 20;
	
	reg [127:0] data_p [39:0];
	reg [127:0] data_w [39:0];
	wire [21:0] dout;
	
	reg [127:0] p, w;
	reg [7:0] b;
	
	reg [7:0] count;
	reg clk, rst, rst2;
	wire clk2;
	integer outfile;
	integer outfile2;
	assign #2 clk2 = clk;	//delayed clk
	mac3_acc uut(clk2, rst2, p, w, b, dout);
	
	initial begin
		$readmemb("digits_hex.txt", data_p);
		$readmemb("weights_hex.txt", data_w);
		outfile = $fopen("simout.txt","w");
		outfile2 = $fopen("macout.txt","w");
		clk = 0;
		count = 0;
		rst1 = 1;
		rst2 = 1;
		b = 11;
		#145 rst1 = 0;
		end
		
	always #half_cylce clk = !clk;
	
	//write acc output to file
	always@(posedge clk)
		if((count > 7)&(count[1:0]==2'b00))
			$fdisplay(outfile, "%h", dout);
			
	//write mac output to file
	always@(posedge clk)
		if(count > 3)
			$fdisplay(outfile2, "%h", uut.sumOUT);
			
	always@(posedge clk2)	begin
		p = data_p[count];
		w = data_w[count];
		
		if(!rst)	begin
			count = count + 1;
		
		if(count == 4)
			#half_cylce rst2 = 0;
		
		if(count == 45)	begin
			$fclose(outfile);
			$fclose(outfile2);
			$finish
		end
		end
	end
	
endmodule