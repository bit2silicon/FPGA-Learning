`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2026 04:14:32 PM
// Design Name: 
// Module Name: design_module
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


module design_module(
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] s_axis_tdata,
    input  logic        s_axis_tvalid,
    output logic        s_axis_tready,
    input  logic        s_axis_tlast,
    output logic [31:0] m_axis_tdata,
    output logic        m_axis_tvalid,
    output logic        m_axis_tlast,
    input  logic        m_axis_tready
    );
    
    wire [31:0] dout;
    add_2 plus2(s_axis_tdata,dout);
    
    logic stlast;
    assign s_axis_tready = !m_axis_tvalid || m_axis_tready;
    assign m_axis_tlast  = m_axis_tvalid & stlast;
    
    always_ff@(posedge clk)
        begin 
            if(!rst_n) begin
                stlast <= 0;
            end
        else begin
            if(s_axis_tlast) begin
                stlast <= 1;
            end
            else if (m_axis_tlast && s_axis_tready) begin
                stlast <= s_axis_tlast;
            end
        end
    end
    
    always_ff@(posedge clk)
        begin
            if(!rst_n) begin
                m_axis_tvalid <= 0;
            end
        else begin
            if(s_axis_tready) begin
                m_axis_tvalid <= s_axis_tvalid;
                if(s_axis_tvalid)
                m_axis_tdata  <= dout;
            end
        end
    end
    
endmodule
