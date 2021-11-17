//流水线加法实现
module add1p   
#(parameter WIDTH   = 17, // Total bit width
            WIDTH1  = 9,  // Bit width of LSBs 
            WIDTH2  = 8)  // Bit width of MSBs
 (input  [WIDTH-1:0] x, y,  // Inputs
  output [WIDTH-1:0] sum,  // Result
  input              clk); // Clock

  reg [WIDTH1-1:0] l1, l2, s1; // LSBs of inputs
  reg [WIDTH1:0] r1;           // LSBs of inputs
  reg [WIDTH2-1:0] l3, l4, r2, s2; // MSBs of input
      
  always @(posedge clk) begin
    // Split in MSBs and LSBs and store in registers
    // Split LSBs from input x,y
    l1[WIDTH1-1:0] <= x[WIDTH1-1:0];
    l2[WIDTH1-1:0] <= y[WIDTH1-1:0];
    // Split MSBs from input x,y
    l3[WIDTH2-1:0] <= x[WIDTH2-1+WIDTH1:WIDTH1];
    l4[WIDTH2-1:0] <= y[WIDTH2-1+WIDTH1:WIDTH1];
/************* First stage of the adder  *****************/
     r1 <= {1'b0, l1} + {1'b0, l2};
     r2 <= l3 + l4;
/************** Second stage of the adder ****************/
     s1 <= r1[WIDTH1-1:0];
  // Add MSBs (x+y) and carry from LSBs
     s2 <= r1[WIDTH1] + r2;
  end

 // Build a single output word of WIDTH = WIDTH1 + WIDTH2
  assign sum = {s2, s1};      

endmodule
