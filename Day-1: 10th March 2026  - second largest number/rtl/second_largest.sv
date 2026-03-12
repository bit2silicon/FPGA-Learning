`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2026 03:57:40 PM
// Design Name: 
// Module Name: second_largest
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


module second_largest(clk, resetn, DIN, DOUT);
    input clk;
    input resetn;
    input  [7:0] DIN;
    output [7:0] DOUT;

reg [7:0] largest, second_largest;



assign DOUT = second_largest;

always@(posedge clk) begin
    if(!resetn) begin
        largest <= 8'b0;
        second_largest <= 8'b0;

    end
    else begin
        if(DIN >= largest) begin
            second_largest<=largest;
            largest<=DIN;
        end
        else if(largest > DIN && DIN >= second_largest) begin
            second_largest<=DIN;
        end
    end
end

endmodule
