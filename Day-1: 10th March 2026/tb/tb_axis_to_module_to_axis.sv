`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2026 04:48:30 PM
// Design Name: 
// Module Name: tb_axis_to_module
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


module tb_axis_to_module();

  wire [31:0] m_axis_0_tdata;
  reg m_axis_0_tready;
  wire m_axis_0_tvalid;
  reg top_s_axis_aclk;
  reg top_s_axis_aresetn;
  reg [31:0]top_s_axis_tdata;
  wire top_s_axis_tready;
  reg top_s_axis_tvalid;
  
    design_1_wrapper dut_design1wrap
       (.m_axis_0_tdata(m_axis_0_tdata),
        .m_axis_0_tready(m_axis_0_tready),
        .m_axis_0_tvalid(m_axis_0_tvalid),
        .top_s_axis_aclk(top_s_axis_aclk),
        .top_s_axis_aresetn(top_s_axis_aresetn),
        .top_s_axis_tdata(top_s_axis_tdata),
        .top_s_axis_tready(top_s_axis_tready),
        .top_s_axis_tvalid(top_s_axis_tvalid));
        
    task senddata(input [31:0] data);
        begin
            @(posedge top_s_axis_aclk);
            top_s_axis_tvalid <= 1; 
            top_s_axis_tdata  <= data;
            $display("Time = %0t, Before checking saxis_tready",$realtime);
            while(!top_s_axis_tready) begin
            $display("Time = %0t saxis_tready = 0", $realtime);
            @(posedge top_s_axis_aclk);  
            end
            $display("Time = %0t, After checking saxis_tready",$realtime);
            
            
            @(posedge top_s_axis_aclk);
            top_s_axis_tvalid <= 0;
        end
    endtask    
    
    always #5 top_s_axis_aclk = ~top_s_axis_aclk;
    
    initial begin
        top_s_axis_aclk = 0;
        top_s_axis_aresetn = 0;
        m_axis_0_tready = 0;
        top_s_axis_tvalid = 0;
        
        @(posedge top_s_axis_aclk);
        repeat(5) @(posedge top_s_axis_aclk);
        top_s_axis_aresetn = 0;
        
        @(posedge top_s_axis_aclk)
        top_s_axis_aresetn = 1;
        
        @(posedge top_s_axis_aclk);
        m_axis_0_tready = 1;
        
        senddata(32'd10);
        senddata(32'd5);
        senddata(32'd50); 
        senddata(32'd220);
        senddata(32'd10);
        senddata(32'd5);
        senddata(32'd50); 
        senddata(32'd220);
        senddata(32'd10);
        senddata(32'd5);
        senddata(32'd50); 
        senddata(32'd220);
        
        repeat(30) @(posedge top_s_axis_aclk);
        $finish;
        
    end
    
//    initial begin
//        #100;
//        m_axis_0_tready = 0; 
//        repeat(10) @(posedge top_s_axis_aclk);
//        m_axis_0_tready = 1;
//    end
    
endmodule
