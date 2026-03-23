// Create a Class consisting of 3 data members each of unsigned integer type. Initialize them to 45,78, and 90. Use the display function to print the values on the console.



class test;

   int unsigned a;

   int unsigned b;

   int unsigned c;

 

endclass




module tb;

  test t1;

 

  initial begin

    t1 = new();

 

 

  t1.a = 45;

  t1.b = 78;

  t1.c = 90;

 

    $display("mem1 = %0d, mem2 = %0d, mem3 = %0d", t1.a, t1.b, t1.c);

           

  end

 

endmodule
