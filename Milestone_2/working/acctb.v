`timescale 1ns/1ps
module acctb();

	parameter hlf_cycle = 30;
	reg [127:0] data_p [39:0];
	reg [127:0] data_w [39:0];
	wire [21:0] dout;
	
	reg [127:0] p, w;
	reg [7:0] b;
	wire [19:0] s;
	
	reg [7:0] count;
	reg clk, rst, rst2;
	wire clk2;
	integer outfile;
	integer outfile2;
	assign #2 clk2 = clk;	//delayed clk
	mac1 r1(clk2, p, w, s);
	acc uut(s, b, clk2, rst, dout);
	
	initial begin
		$readmemh("digits_hex.mem", data_p);
		$readmemh("weights_hex.mem", data_w);
		outfile = $fopen("HERE1.txt","w");
		outfile2 = $fopen("HERE2.txt","w");
		clk = 0;
		count = 0;
		rst = 1;
		rst2 = 1;
		b = 11;
		#145 rst = 0;
		//rst2 = 0;
		end
		
	always #hlf_cycle clk = !clk;
	
	//write acc output to file
	always@(posedge clk)
		if((count > 6)&(count[1:0]==2'b11))
			$fdisplay(outfile, "%h", dout);
			
	//write mac output to file
	always@(posedge clk)
		if(count > 2) //Takes 3 cycles for first adder to get all data
			$fdisplay(outfile2, "%h", s);
			
	always@(posedge clk2)	begin
		p = data_p[count];
		w = data_w[count];
		
		if(!rst)	begin
			count = count + 1;
		
		if(count == 1) begin  //was 4
			#hlf_cycle rst2 = 0; end
		
		if(count == 45)	begin
			$fclose(outfile);
			$fclose(outfile2);
			$finish;
		end
		end
	end
	
endmodule