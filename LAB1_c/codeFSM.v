module codeFSM(
	input clk,
	input reset,
	input timeOut,
	input cntOut,
	input Din,
	input Rin,
	input nDin,
	input nRin,
	input anyIN,
	output en,
	output encnt,
	output [6:0] led
	);
	
	parameter IDLE	= 3'b000;
	parameter D1 	= 3'b001;
	parameter D2 	= 3'b010;
	parameter R3 	= 3'b011;
	parameter E1 	= 3'b100;
	parameter E2 	= 3'b101;
	parameter E3 	= 3'b110;
	
	reg [2:0] curr_state, next_state;
	reg [6:0] led;
	reg en;
	reg encnt;
	
	always@(posedge clk)	begin
		if(reset)
			curr_state <= IDLE;
		else
			if (timeOut | cntOut)
				curr_state <= E3;
			else
				curr_state <= next_state;
		end
		
		always@(*) begin
		case(curr_state)
		IDLE: begin
			led <= 7'b1000000; en <= 0; encnt <= 0;	//0
			if(Din)
				next_state <= D1;
			else begin
				if(nDin)
					next_state <= E1;
				else 
					next_state <= IDLE;
			end
		end
		D1: begin
			led <= 7'b1111001; en <= 1; encnt <= 0;	//1
			if (Din)
				next_state <= D2;
			else begin
				if(nDin)
					next_state <= E2;
				else
					next_state <= D1;
			end
		end
		D2: begin
			led <= 7'b0100100; en <= 1; encnt <= 0;	//2
			if (Rin)
				next_state <= R3;
			else begin
				if(nRin)
					next_state <= E3;
				else
					next_state <= D2;
			end
		end
		R3: begin
			led <= 7'b0010000; en <= 0; encnt <= 0;	//3
			next_state <= R3;
		end
		E1: begin
			led <= 7'b0011001; en <= 1; encnt <= 1	//4
			if (anyIN)
				next_state <= E2;
			else
				next_state <= E1;
			end
		E2: begin
			led <= 7'b0010010; en <= 1; encnt <= 0;	//5
			if(anyIN)
				next_state <= E3;
			else
				next_state <= E2;
			end
		E3: begin
			led <= 7'b0000010; en <= 1; encnt <= 1;	//6
			if(cntOut)
				next_state <= E3;
			else
				next_state <= IDLE;
			end
		default: next_state <= IDLE;
		endcase
		end
endmodule
			
		