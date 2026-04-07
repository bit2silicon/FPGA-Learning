`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 05:05:29 PM
// Design Name: 
// Module Name: ecc_module
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

// codeword[0] = p_1              ------ 1
// codeword[1] = p_2              ------ 2
// codeword[2] = din_0 -> din[31] ------ 3
// codeword[3] = p_4              ------ 4
// codeword[4] = din_1 -> din[30] ------ 5
// codeword[5] = din_2 -> din[29] ------ 6
// codeword[6] = din_3 -> din[28] ------ 7
// codeword[7] = p_8              ------ 8
// codeword[8] = din_4 -> din[27] ------ 9
// codeword[9] = din_5 -> din[26] ------ 10
// codeword[10] = din_6 -> din[25] ------ 11
// codeword[11] = din_7 -> din[24] ------ 12
// codeword[12] = din_8 -> din[23] ------ 13
// codeword[13] = din_9 -> din[22] ------ 14
// codeword[14] = din_10 -> din[21] ------ 15
// codeword[15] = p_16              ------ 16
// codeword[16] = din_11 -> din[20] ------ 17
// codeword[17] = din_12 -> din[19] ------ 18
// codeword[18] = din_13 -> din[18] ------ 19
// codeword[19] = din_14 -> din[17] ------ 20
// codeword[20] = din_15 -> din[16] ------ 21
// codeword[21] = din_16 -> din[15] ------ 22
// codeword[22] = din_17 -> din[14] ------ 23
// codeword[23] = din_18 -> din[13] ------ 24
// codeword[24] = din_19 -> din[12] ------ 25
// codeword[25] = din_20 -> din[11] ------ 26
// codeword[26] = din_21 -> din[10] ------ 27
// codeword[27] = din_22 -> din[9] ------ 28
// codeword[28] = din_23 -> din[8] ------ 29
// codeword[29] = din_24 -> din[7] ------ 30
// codeword[30] = din_25 -> din[6] ------ 31
// codeword[31] = p_32              ------ 32
// codeword[32] = din_26 -> din[5] ------ 33
// codeword[33] = din_27 -> din[4] ------ 34
// codeword[34] = din_28 -> din[3] ------ 35
// codeword[35] = din_29 -> din[2] ------ 36
// codeword[36] = din_30 -> din[1] ------ 37
// codeword[37] = din_31 -> din[0] ------ 38
// codeword[38] = p_39              ------ 39


module ecc_module#(
    parameter DATA_WIDTH = 32,
    parameter NUM_PARITY = 6,
    parameter CODE_WIDTH = 39 // 32-bit data + 6 hamming + 1 overall parity
)(
    // Encoder side
//    input  wire [DATA_WIDTH-1:0] data_in,
//    output wire [CODE_WIDTH-1:0] enc_out
    
//    // Decoder side
    input  wire [CODE_WIDTH-1:0] enc_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  sec_corrected,
    output wire                  ded_error
    );
    
//    encoder #(
//            .DATA_WIDTH(DATA_WIDTH),
//            .CODE_WIDTH(CODE_WIDTH),
//            .NUM_PARITY(NUM_PARITY)
//            )
//            enc(
//            data_in,
//            enc_out
//    );
    reg [CODE_WIDTH-1:0] enc_error;
    
    always@(*) begin
        enc_error = enc_in;
        enc_error[10]=~enc_in[10];
        enc_error[20]=~enc_in[20];
    end
    decoder #(
            .DATA_WIDTH(DATA_WIDTH),
            .CODE_WIDTH(CODE_WIDTH),
            .NUM_PARITY(NUM_PARITY)
            )
            dec(
            .enc_in(enc_error),
            .data_out(data_out),
            .sec_corrected(sec_corrected),
            .ded_error(ded_error)
    );
            
    
endmodule
