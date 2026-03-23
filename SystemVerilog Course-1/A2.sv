//Create an array capable of storing 10 elements of an unsigned integer. Initialize all the 10 elements to a value equal to the square of the index of that element. for e.g. first element has index no. 0 so initialize it to 0, the second element has index no. 1 so initialize it to 1, the third element has index no. 2 so initialize it to 4, and so on. Verify the code by sending values of all the elements on Console.



module tb();

  int unsigned arr[10];

//   int arr[5] = '{5{300}};

//   int arr[5] = '{default: 200};

 

  initial begin

    for(int i=0; i<10; i=i+1) begin

      arr[i]=i*i;

    end

    $display("array = %0p", arr);

  end
