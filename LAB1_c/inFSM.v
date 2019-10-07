module inFSM(
	input clk, 
	input reset,
	input button,
	output fed
	);
	
	parameter IDLE 	= 2'b00;
	parameter ST0 	= 2'b01;
	parameter ST1 	= 2'b11;
	
	reg [1:0] c_state;
	reg [1:0] n_state;
	
	//logic to determine next state
	always@(*) begin
	case(c_state)
	IDLE:	if(button == 1'b1)
			n_state = ST0;
			else
			n_state = IDLE;
	ST0:	if(button == 1'b0)
			n_state = ST1;
			else 
			n_state = ST0;
	ST1:	n_state = ST0;		//Output state
	default: n_state = IDLE;
	endcase
	end
	//Update state registers
	always@(posedge clk or posedge reset)	begin
	if(reset)
		c_state <= IDLE;
	else
		c_state <= n_state;
	end
	//FSM output
	assign fed = (c_state == ST1)? 1'b1 : 1'b0;
	endmodule