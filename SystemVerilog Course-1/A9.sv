// Create a function that generate and return 32 values of multiple of 8 (0, 8, 16, 24, 32, 40 .... 248). Store this value in the local array of the testbench top and also print the value of each element of this array on the console.

module tb();

  function automatic void mulsof8(ref int unsigned a[32]);

    for(int i=0; i<=31; i++) begin

      a[i] = 8*i;

    end

  endfunction

 

  int unsigned mul8[32];

  initial begin

    mulsof8(mul8);

    for(int i=0; i<=31; i++) begin

      $display("a[%0d] = %0d",i,mul8[i]);

    end

  end

endmodule
