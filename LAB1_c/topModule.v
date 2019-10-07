module topModule(
	input reset,
	input U,
	input L,
	input R,
	input D,
	input clk,
	output[6:0] SSG_D,
	output [2:0] SSG_EN
	);
	
	wire Ue, Le, Re, De;
	wire Din, nDin, Rin, nRin, anyIN;
	wire en, timeOut;
	wire encnt, cntOut;
	
	inFSM ufsm (clk, reset, U, Ue);
	inFSM lfsm (clk, reset, L, Le);
	inFSM rfsm (clk, reset, R, Re);
	inFSM dFSM (clk, reset, D, De);
	
	assign Din = De & !(Ue | Le | Re);
	assign nDin = !De & (Ue | Le | Re);
	assign Rin = Re & !(Ue | Le | De);
	assign nRin = !Re & (Ue | Le | De);
	assign anyIN = (Ue | Le | Re | De);
	
	codeFSM codecheck (clk, reset timeOut, cntOut, Din, Rin, nDin, nRin, anyIN, en, encnt, SSG_D);
	timer checktime (clk, reset, en, timeOut);
	counter cnt (clk, reset, encnt, cntOut);
	
	assign SSF_EN = 3'b111; //disable the other three led's
endmodule