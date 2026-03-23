// Create a function that will perform the multiplication of the two unsigned integer variables. Compare values return by function with the expected result and if both values match send "Test Passed" to Console else send "Test Failed".



module tb();

 

  function int unsigned mul(int unsigned ain, bin);

    return ain*bin;

  endfunction

 

  int unsigned a = 10;

  int unsigned b = 20;

  int unsigned res = 0;

  int unsigned expected_res = a*b;

 

  initial begin

    res = mul(a,b);

    if(res == expected_res)

      $display("Test Passed");

    else

      $display("Test Failed");

  end



endmodule
