module mac1(
	input [127:0] pixels,		
	input [127:0] weights,		
	output [19:0] sumOUT		
	);
	parameter L1 = 17;
	parameter L2 = 18;
	parameter L3 = 19;
	
	reg [127:0] pix;		
	reg [127:0] wts;
	reg [19:0] sumOUT;
	wire [19:0] sum;
	
	reg [255:0] pr;
	wire [255:0] p;
	wire [135:0] s1;
	wire [71:0] s2;
	wire [37:0] s3;
	
	/*wire [19:0] pipe1;
	wire [19:0] pipe2;
	wire [19:0] pipe3;*/
	
	always@(posedge clk)	begin	
		pix <= pixels;		//Pipeline the inputs
		wts <= weights;		//Pipeline the weights
		pr <= p;			//Pipeline the products
		sumOUT <= sum;		//Pipeline the output
	end
	
	genvar i;
	generate
	for(i=0; i<=15; i=i+1)						
		mult multName(pix[(127-8*i):(127-8*i-7)],		
			 	wts[(127-8*i):(127-8*i-7)],		
				p[(255-16*i):(255-16*i-15)]);		
	endgenerate
	
	genvar k;
	generate
	for(k=0; k<=7; k=k+1)						
		adder adderName(pr[(255-16*2*k):(255-16*2*k-15)],	
				pr[(255-16*(2*k+1)):(255-16*(2*k-1)-15)],
				s1[(135-17*k):(135-17*k-16)]);		
	endgenerate
	
/*always@(posedge clk)	begin	//Prevent from outputting garbage
		pipe1 <= sum;		
		pipe2 <= pipe1;		
		pipe3 <= pipe2;			
		sumOUT <= pipe3;		
	end*/
	
	/*adder17 adder17_1(s1[135:119], s1[118:102], s2[71:54]);		
	adder17 adder17_2(s1[101:85], s1[84:68], s2[53:36]);		
	adder17 adder17_3(s1[67:51], s1[50:34], s2[35:18]);		
	adder17 adder17_4(s1[33:17], s1[16:0], s2[17:0]);		
	
	adder18 adder18_5(s2[71:54], s2[53:36], s3[37:19]);		
	adder18 adder18_6(s2[35:18], s2[17:0], s3[18:0]);		
	
	adder19 adder19_7(s3[37:19], s3[18:0], sum);*/	
	
	adder_p #(.l(L1)) add17_1(s1[135:119], s1[118:102], s2[71:54]);		
	adder_p #(.l(L1)) add17_2(s1[101:85], s1[84:68], s2[53:36]);		
	adder_p #(.l(L1)) add17_3(s1[67:51], s1[50:34], s2[35:18]);		
	adder_p #(.l(L1)) add17_4(s1[33:17], s1[16:0], s2[17:0]);		
	
	adder_p #(.l(L2)) add18_5(s2[71:54], s2[53:36], s3[37:19]);		
	adder_p #(.l(L2)) add18_6(s2[35:18], s2[17:0], s3[18:0]);		
	
	adder_p #(.l(L3)) add19_7(s3[37:19], s3[18:0], sum);
endmodule
