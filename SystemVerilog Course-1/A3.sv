//Create two arrays of reg type capable of storing 15 elements. Use $urandom function to add 15 values to the array. Print the value of all the elements of the array on a single line.

module tb();

  reg a[15];

  reg b[15];

 

  initial begin

    foreach(a[i]) begin

      a[i]=$urandom();

      b[i]=$urandom();

    end

    $display("%0p %0p",a,b);

  end

endmodule
