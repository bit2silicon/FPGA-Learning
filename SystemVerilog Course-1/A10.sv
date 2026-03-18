class a10;
  
  bit [7:0] a,b,c;
  
  function new(input bit [7:0] a, input bit [7:0] b, input bit [7:0] c);
    this.a = a;
    this.b = b;
    this.c = c;
  endfunction 
  
endclass

module tb;
  
  a10 t1;
  
  initial begin
    t1 = new(.a(2), .b(4), .c(56));
    $display("a = %0d, b = %0d, c= %0d",t1.a, t1.b, t1.c);
  end
  
endmodule
