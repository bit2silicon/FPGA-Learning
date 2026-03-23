// Create a task that will generate stimulus for addr , wr, and en signal as mentioned in a waveform of the Instruction tab. Assume address is 6-bit wide while en and wr both are 1-bit wide. The stimulus should be sent on a positive edge of 25 MHz clock signal.



module tb();

  bit [5:0] addr;

  bit en, wr;

  reg clk;

 

  always #20 clk = ~clk;

 

  task sendsig(input bit [5:0] address, input bit write, input bit enable);

    @(posedge clk);

    addr = address;

    wr = write;

    en = enable;

  endtask



  initial begin

    $dumpfile("waveform.vcd"); // Specify the VCD file name

    $dumpvars(0, clk, en, wr, addr);

    clk = 0;

    sendsig(12, 1, 1);

    sendsig(14, 1, 1);

    sendsig(23, 0, 1);

    sendsig(48, 0, 1);

    sendsig(56, 0, 0);

    #50;

    $finish;

  end

endmodule
