module My_Rom1
 (input  [3:0] table_in,  
  output reg [8:0] table_out); 

// This is the DA CASE table for
// the 15 coefficients: 1, -2, 3, -4  

  always @(table_in)
  begin
    case (table_in)
      0 :     table_out =  0;
      1 :     table_out =  1;
      2 :     table_out =  -2;
      3 :     table_out =  -1;
      4 :     table_out =  3;
      5 :     table_out =  4;
      6 :     table_out =  1;
      7 :     table_out =  2;
      8 :     table_out =  -4;
      9 :     table_out =  -3;
      10:     table_out =  -6;
      11:     table_out =  -5;
      12:     table_out =  -1;
      13:     table_out =  0;
      14:     table_out =  -3;
      15:     table_out =  -2;
      default : ;
    endcase
  end
endmodule

module My_Rom2
 (input  [3:0] table_in,  
  output reg [8:0] table_out); 

// This is the DA CASE table for
// the 15 coefficients: 5, -6, 7, -8  

  always @(table_in)
  begin
    case (table_in)
      0 :     table_out =  0;
      1 :     table_out =  5;
      2 :     table_out =  -6;
      3 :     table_out =  -1;
      4 :     table_out =  7;
      5 :     table_out =  12;
      6 :     table_out =  1;
      7 :     table_out =  6;
      8 :     table_out =  -8;
      9 :     table_out =  -3;
      10:     table_out =  -14;
      11:     table_out =  -9;
      12:     table_out =  -1;
      13:     table_out =  4;
      14:     table_out =  -7;
      15:     table_out =  -2;
      default : ;
    endcase
  end
endmodule

module My_Rom3
 (input  [3:0] table_in,  
  output reg [8:0] table_out); 

// This is the DA CASE table for
// the 15 coefficients: -8 ,7, -6, 5 

  always @(table_in)
  begin
    case (table_in)
      0 :     table_out =  0;
      1 :     table_out =  -8;
      2 :     table_out =  7;
      3 :     table_out =  -1;
      4 :     table_out =  -6;
      5 :     table_out =  -14;
      6 :     table_out =  1;
      7 :     table_out =  -7;
      8 :     table_out =  5;
      9 :     table_out =  -3;
      10:     table_out =  12;
      11:     table_out =  4;
      12:     table_out =  -1;
      13:     table_out =  -9;
      14:     table_out =  6;
      15:     table_out =  -2;
      default : ;
    endcase
  end
endmodule

module My_Rom4
 (input  [3:0] table_in,  
  output reg [8:0] table_out); 

// This is the DA CASE table for
// the 15 coefficients: -4, 3, -2, 1

  always @(table_in)
  begin
    case (table_in)
      0 :     table_out =  0;
      1 :     table_out =  -4;
      2 :     table_out =  3;
      3 :     table_out =  -1;
      4 :     table_out =  -2;
      5 :     table_out =  -6;
      6 :     table_out =  1;
      7 :     table_out =  -3;
      8 :     table_out =  1;
      9 :     table_out =  -3;
      10:     table_out =  4;
      11:     table_out =  0;
      12:     table_out =  -1;
      13:     table_out =  -5;
      14:     table_out =  2;
      15:     table_out =  -2;
      default : ;
    endcase
  end
endmodule
