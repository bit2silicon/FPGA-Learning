`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2026 03:58:24 PM
// Design Name: 
// Module Name: tb
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

module tb();

  // Parameters

  //Ports
  reg clk;
  reg resetn;
  reg [7:0] DIN;
  wire [7:0] DOUT;

  second_largest  second_largest_inst (
    .clk(clk),
    .resetn(resetn),
    .DIN(DIN),
    .DOUT(DOUT)
  );

always #5  clk = ! clk ;

initial begin
    resetn=0;
    clk=0;
    DIN=8'b0;
    repeat(5) @(posedge clk);
    resetn=1;
    DIN=2;  @(posedge clk);
    DIN=5;  @(posedge clk);
    DIN=1;  @(posedge clk);
    DIN=8;  @(posedge clk);
    DIN=6;  @(posedge clk);
    DIN=5;  @(posedge clk);
    DIN=0;  @(posedge clk);
    
    $finish;
end
endmodule