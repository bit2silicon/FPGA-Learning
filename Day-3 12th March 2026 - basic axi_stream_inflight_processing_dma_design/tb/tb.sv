`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2026 01:49:19 PM
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
    logic clk;
    logic rst_n;
    logic [31:0] s_axis_tdata;
    logic        s_axis_tvalid;
    wire         s_axis_tready;
    logic        s_axis_tlast;
    wire [31:0]  m_axis_tdata;
    wire         m_axis_tvalid;
    wire         m_axis_tlast;
    logic        m_axis_tready;
    
    design_module dut(
        .clk(clk),
        .rst_n(rst_n),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tready(s_axis_tready),
        .s_axis_tlast(s_axis_tlast),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tlast(m_axis_tlast),
        .m_axis_tready(m_axis_tready)
        );
    
    task apply_resetn();
        rst_n = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
    endtask;
    
    task send_data(input [31:0] din, input last);
        
        s_axis_tdata <= din;
        s_axis_tlast <= last;
        s_axis_tvalid <= 1;
        
        @(posedge clk);
        
        while(!(s_axis_tready && s_axis_tvalid)) begin
            $display("WAIING");
            @(posedge clk);
        end
        
//        @(posedge clk);
        s_axis_tvalid <= 0;
        s_axis_tlast  <= 0;
        
    endtask;
    
    always #10 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        s_axis_tdata  <= 0;
        s_axis_tvalid <= 0;
        s_axis_tlast  <= 0;
        m_axis_tready <= 0;
        apply_resetn();
        
        @(posedge clk);
        m_axis_tready = 1;
        
        send_data(32'd1, 0);
        send_data(32'd2, 0);
        send_data(32'd3, 0);
        send_data(32'd4, 1);
        
        repeat(30) @(posedge clk);
        $finish;
    end
    
    initial begin
        #180;
        m_axis_tready = 0;
        
        repeat(5) @(posedge clk);
        m_axis_tready = 1;
    end
    
endmodule
