// Create a Fixed-size array capable of storing 20 elements. Add random values to all the 20 elements by using $urandom function. Now add all the elements of the fixed-size array to the Queue in such a way that the first element of the Fixed-size array should be the last element of the Queue. Print all the elements of both fixed-size array and Queue on Console.

module tb();

  int unsigned a[20];

  int unsigned b[$];

 

  initial begin

    foreach(a[i])

      a[i]=$urandom();

   

    for(int i=19; i>=0; i=i-1)

      b.push_back(a[i]);

   

    $display("a = %0p",a);

    $display("b = %0p",b);

  end

endmodule
