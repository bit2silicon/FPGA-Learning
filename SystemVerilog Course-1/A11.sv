
class a11;
  
  bit [3:0] a,b,c;
  
  function new(input bit [3:0] a, input bit [3:0] b, input bit [3:0] c);
    this.a = a;
    this.b = b;
    this.c = c;
  endfunction 
  
  task add_and_display(output bit [3:0] sum);
    sum = a+b+c;
    $display("a = %0d, b = %0d, c = %0d, sum = %0d + %0d + %0d = %0d",a,b,c,a,b,c,sum);
  endtask
  
endclass

module tb;
  
  a11 t1;
  bit [3:0] sum;
  
  initial begin
    t1 = new(.a(1), .b(2), .c(4));
    t1.add_and_display(sum);
    
  end
  
endmodule
