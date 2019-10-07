module mac1(
    input clk,
	input [127:0] pixelsIN,		//16x8 = 128 bits
	input [127:0] weightsIN,		//16x8 = 128 bits
	output [19:0] sumOUT		//20 bit output 
	);
	reg [127:0] pixels, weights;
	reg [19:0] sum;
	//wire [19:0] sumOUT;
		
	wire [255:0] p;		//Store 16 16-bit mult results
	wire [135:0] s1;	//Store 8 17-bit addition results
	wire [71:0] s2;		//Store 4 18-bit addition results
	wire [37:0] s3;		//Store 2 19-bit addition results
	
	always@(posedge clk)   begin
	   pixels <= pixelsIN;
	   weights <= weightsIN;
	   sum <= sumOUT;  end
	
	//instantiate multipliers
	//Segmenting pixel input 8 bits at a time as input for multiplier
	//Segmenting weights input 8 bits at a time as input for multiplier
	//Storing the product in 'p' 16 bits at a time, to hold 256 bits, 16 multiplications
	
	genvar i;
	generate    begin
	for(i=0; i<=15; i=i+1)	begin					//Perform 16 multiplications
		mult multName(pixels[(127-8*i):(127-8*i-7)],		//pixels  : 8 bits
			 	weights[(127-8*i):(127-8*i-7)],		//weights : 8 bits
				p[(255-16*i):(255-16*i-15)]); end		//products: 16 bits
	end
	endgenerate
	
	//instantiate adders
	//'p' now holds 16 16-bit products
	//add each of them: 16/2 = 8 additions
	
	genvar k;
	generate   begin
	for(k=0; k<=7; k=k+1)	begin					//Add the products
		adder16 adderName(p[(255-16*2*k):(255-16*2*k-15)],	//16 bits - 1 product
				p[(255-16*(2*k+1)):(255-16*(2*k+1)-15)],//16 bits - 1 product
				s1[(135-17*k):(135-17*k-16)]);	end	//16+16 = 17 bit result
	end
	endgenerate
	
	adder17 adder17_1(s1[135:119], s1[118:102], s2[71:54]);		//17b+17b = 18b
	adder17 adder17_2(s1[101:85], s1[84:68], s2[53:36]);		//17b+17b = 18b
	adder17 adder17_3(s1[67:51], s1[50:34], s2[35:18]);		//17b+17b = 18b
	adder17 adder17_4(s1[33:17], s1[16:0], s2[17:0]);		//17b+17b = 18b
	
	adder18 adder18_5(s2[71:54], s2[53:36], s3[37:19]);		//18b+18b = 19b
	adder18 adder18_6(s2[35:18], s2[17:0], s3[18:0]);		//18b+18b = 19b
	
	adder19 adder19_7(s3[37:19], s3[18:0], sumOUT);	//Final result: 19b+19b = 20b 'sum'
	
endmodule
