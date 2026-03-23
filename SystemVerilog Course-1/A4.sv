// Create a dynamic array capable of storing 7 elements. add a value of multiple of 7 starting from 7 in the array (7, 14, 21 ....49). After 20 nsec Update the size of the dynamic array to 20. Keep existing values of the array as it is and update the rest 13 elements to a multiple of 5 starting from 5. Print Value of the dynamic array after updating all the elements.

// Expected result : 7, 14, 21, 28 ..... 49, 5, 10, 15 ..... 65 .

module tb();

  int a[];

 

  initial begin

    a=new[7];

    foreach(a[i])

      a[i]=7*(i+1);

    a = new[20](a);

    for(int i=0; i<13; i=i+1)

      a[i+7]=5*(i+1);

    $display("a = %0p",a);

  end

endmodule
