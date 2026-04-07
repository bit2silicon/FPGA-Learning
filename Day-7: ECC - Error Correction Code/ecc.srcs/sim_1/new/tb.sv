`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2026 12:11:58 PM
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


module tb;

  // Parameters
  localparam  DATA_WIDTH = 32;
  localparam  CODE_WIDTH = 39;

  //Ports
//  reg [DATA_WIDTH-1:0] data_in;
//  wire [CODE_WIDTH-1:0] enc_out;
  
  wire [DATA_WIDTH-1:0] data_out;
  reg [CODE_WIDTH-1:0] enc_in;
  wire sec_corrected;
  wire ded_error;

  ecc_module # (
    .DATA_WIDTH(DATA_WIDTH),
    .CODE_WIDTH(CODE_WIDTH)
  )
//  ecc_module_inst (
//    .data_in(data_in),
//    .enc_out(enc_out)
//  );
ecc_module_inst (
    .enc_in(enc_in),
    .data_out(data_out),
    .sec_corrected(sec_corrected),
    .ded_error(ded_error)
  );

initial begin
//    data_in=4'b1011;
//    data_in = 32'hA5A5A5A5A5;
    enc_in = 39'h69B4B4DA26;
    #30;
//    data_in=4'b1111;
//    #30;
    $finish;
end

endmodule
