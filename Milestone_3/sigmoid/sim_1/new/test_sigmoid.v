`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 04:47:54 PM
// Design Name: 
// Module Name: test_sigmoid
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_sigmoid( );

parameter half_cycle = 20;
reg signed [21:0] count;
reg clk;
wire clk2;
wire [7:0] data_out;
integer outfile;
reg ovf;
wire sign;
reg [8:0] data;

assign #2 clk2 = clk;   //delayed clock
Sigmoid_func u1(count, sign, ovf, data);

initial begin
    outfile = $fopen("MEMEME.txt","w");
    //outfile2 = $fopen("sigmoidos.txt","w");
    clk = 0;
    count = 16640; //maybe positive?
    end
    
    always #half_cycle clk = !clk;
    
    //write to file
    always@(posedge clk)    begin
        $fdisplay(outfile, "%h", data_out);
        end
        
     always@(posedge clk2)  begin
        count = count + 32;
     if (count >= 16640)    begin
     $flcose(outfile);
     //$fclose(outfile2);
     $finish;
     end
     end
endmodule
