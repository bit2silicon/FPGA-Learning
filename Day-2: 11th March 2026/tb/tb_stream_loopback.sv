`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2026 02:09:17 PM
// Design Name: 
// Module Name: tb_stream_loopback
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


module tb_stream_loopback();
    
    logic clk;
    logic rst_n;
    logic [31:0] s_axis_tdata;
    logic        s_axis_tvalid;
    logic        s_axis_tlast;
    wire         s_axis_tready;
    wire  [31:0] m_axis_tdata;
    wire         m_axis_tvalid;
    wire         m_axis_tlast;
    logic        m_axis_tready;
    
    ldpc_stream_loopback dut(
            .clk(clk),
            .rst_n(rst_n),
            .s_axis_tdata(s_axis_tdata),
            .s_axis_tvalid(s_axis_tvalid),
            .s_axis_tready(s_axis_tready),
            .m_axis_tdata(m_axis_tdata),
            .m_axis_tvalid(m_axis_tvalid),
            .m_axis_tready(m_axis_tready),
            .m_axis_tlast(m_axis_tlast),
            .s_axis_tlast(s_axis_tlast)
            );
    
    task senddata(input [31:0] data, input last);
        begin
            @(posedge clk);
            s_axis_tvalid <= 1; 
            s_axis_tdata  <= data;
            s_axis_tlast <= last;
            $display("Time = %0t, Before checking saxis_tready",$realtime);
            while(!s_axis_tready) begin
            $display("Time = %0t saxis_tready = 0", $realtime);
            @(posedge clk);  
            end
            $display("Time = %0t, After checking saxis_tready",$realtime);
            
            
            @(posedge clk);
            s_axis_tvalid <= 0;
            s_axis_tlast <= 0;
        end
    endtask    
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        rst_n = 0;
        m_axis_tready = 0;
        s_axis_tvalid = 0;
        
        @(posedge clk);
        repeat(5) @(posedge clk);
        rst_n = 0;
        
        @(posedge clk)
        rst_n = 1;
        
        @(posedge clk);
        m_axis_tready = 1;
        
        senddata(32'd10, 1'b0);
        senddata(32'd5, 1'b0);
        senddata(32'd50, 1'b0); 
        senddata(32'd220, 1'b1);
        
        repeat(50) @(posedge clk);
        $finish;
        
    end
    
    initial begin
        #155;
        m_axis_tready = 0; 
        repeat(5) @(posedge clk);
        m_axis_tready = 1;
        
    end
    
endmodule
