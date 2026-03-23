//Write a code to print the values of all the variables after 12 nSec.



module tb();

 

  reg [7:0] a, b;

  integer c, d;

  initial begin

    a=12;

    b=34;

    c=67;

    d=255;

    #12;

    $display("a=%0d,b=%0d,c=%0d,d=%0d",a,b,c,d);

  end

 

endmodule
