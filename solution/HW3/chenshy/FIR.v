`include "My_Rom.v"
`include "FA.v"
module FIR(
	input 	    	  [7:0] 	din,
	input 					        clk,
	input 					        rst,
	output	signed 	[16:0] 	dout
	);
	
  reg  		    [15:0] x     [0:7];
  wire signed [8:0]  sum_0 [0:31];
  reg  signed [8:0]  sum_1 [0:31];//保存查表后的卷积数据
  reg  signed [10:0] sum_2 [0:15];
  reg  signed [16:0] h     [0:7];
  wire signed [16:0] s0, s1;
  wire signed [16:0] tin0,tin1,tin2,tin3;
  reg  signed [16:0] t0, t1, t2, t3,reg_s0,reg_s1;
  integer k,l;

  always @(posedge clk or negedge rst)  //----> DA in behavioral style
  if (rst == 1'b0)
    begin//复位操作
  		for (l=0; l<=7; l=l+1) begin   
      		for (k=0; k<=15; k=k+1) begin  
       		x[l][k] <= 0;
      		end
    	end
      for (k=0; k<=31; k=k+1) begin  
          sum_1[k] <= 0;
        end
      for (k=0; k<=15; k=k+1) begin   
          sum_2[k] <= 0;
        end
      for (k=0; k<=7; k=k+1) begin   
          h[k] <= 0;
        end
      //s0 <=0;s1 <=0;out <= 0;
      t0 <=0; t1 <=0; t2 <=0; t3 <=0;reg_s0 <=0;reg_s1 <=0; 
      end//复位操作结束
  else
  begin
    for (l=0; l<=7; l=l+1) begin     // 历史数据移位
      for (k=0; k<=14; k=k+1) begin   
       x[l][k] <= x[l][k+1];
      end
    end
    for (l=0; l<=7; l=l+1) begin   // 读入数据
      x[l][15] <= din[l];          
    end

    for (k=0; k<=31; k=k+1)begin
      sum_1[k] <= sum_0[k];
    end

    for (k=0; k<=15; k=k+1)begin
      sum_2[k] <= sum_1[2*k]+sum_1[2*k+1];
    end

    for (k=0; k<=7; k=k+1)begin
      h[k] <= sum_2[2*k] + sum_2[2*k+1];
    end

    reg_s0 <= s0;reg_s1 <= s1;
    t0 <= tin0;t1 <= tin1;t2 <= tin2;t3 <= tin3;
  end


  My_Rom1 My_Rom11 ( .table_in({x[0][3],x[0][2],x[0][1],x[0][0]}), .table_out(sum_0[0]));
  My_Rom2 My_Rom12 ( .table_in({x[0][7],x[0][6],x[0][5],x[0][4]}), .table_out(sum_0[1]));
  My_Rom3 My_Rom13 ( .table_in({x[0][11],x[0][10],x[0][9],x[0][8]}), .table_out(sum_0[2]));
  My_Rom4 My_Rom14 ( .table_in({x[0][15],x[0][14],x[0][13],x[0][12]}), .table_out(sum_0[3]));

  My_Rom1 My_Rom21 ( .table_in({x[1][3],x[1][2],x[1][1],x[1][0]}), .table_out(sum_0[4]));
  My_Rom2 My_Rom22 ( .table_in({x[1][7],x[1][6],x[1][5],x[1][4]}), .table_out(sum_0[5]));
  My_Rom3 My_Rom23 ( .table_in({x[1][11],x[1][10],x[1][9],x[1][8]}), .table_out(sum_0[6]));
  My_Rom4 My_Rom24 ( .table_in({x[1][15],x[1][14],x[1][13],x[1][12]}), .table_out(sum_0[7]));

  My_Rom1 My_Rom31 ( .table_in({x[2][3],x[2][2],x[2][1],x[2][0]}), .table_out(sum_0[8]));
  My_Rom2 My_Rom32 ( .table_in({x[2][7],x[2][6],x[2][5],x[2][4]}), .table_out(sum_0[9]));
  My_Rom3 My_Rom33 ( .table_in({x[2][11],x[2][10],x[2][9],x[2][8]}), .table_out(sum_0[10]));
  My_Rom4 My_Rom34 ( .table_in({x[2][15],x[2][14],x[2][13],x[2][12]}), .table_out(sum_0[11]));

  My_Rom1 My_Rom41 ( .table_in({x[3][3],x[3][2],x[3][1],x[3][0]}), .table_out(sum_0[12]));
  My_Rom2 My_Rom42 ( .table_in({x[3][7],x[3][6],x[3][5],x[3][4]}), .table_out(sum_0[13]));
  My_Rom3 My_Rom43 ( .table_in({x[3][11],x[3][10],x[3][9],x[3][8]}), .table_out(sum_0[14]));
  My_Rom4 My_Rom44 ( .table_in({x[3][15],x[3][14],x[3][13],x[3][12]}), .table_out(sum_0[15]));

  My_Rom1 My_Rom51 ( .table_in({x[4][3],x[4][2],x[4][1],x[4][0]}), .table_out(sum_0[16]));
  My_Rom2 My_Rom52 ( .table_in({x[4][7],x[4][6],x[4][5],x[4][4]}), .table_out(sum_0[17]));
  My_Rom3 My_Rom53 ( .table_in({x[4][11],x[4][10],x[4][9],x[4][8]}), .table_out(sum_0[18]));
  My_Rom4 My_Rom54 ( .table_in({x[4][15],x[4][14],x[4][13],x[4][12]}), .table_out(sum_0[19]));

  My_Rom1 My_Rom61 ( .table_in({x[5][3],x[5][2],x[5][1],x[5][0]}), .table_out(sum_0[20]));
  My_Rom2 My_Rom62 ( .table_in({x[5][7],x[5][6],x[5][5],x[5][4]}), .table_out(sum_0[21]));
  My_Rom3 My_Rom63 ( .table_in({x[5][11],x[5][10],x[5][9],x[5][8]}), .table_out(sum_0[22]));
  My_Rom4 My_Rom64 ( .table_in({x[5][15],x[5][14],x[5][13],x[5][12]}), .table_out(sum_0[23]));

  My_Rom1 My_Rom71 ( .table_in({x[6][3],x[6][2],x[6][1],x[6][0]}), .table_out(sum_0[24]));
  My_Rom2 My_Rom72 ( .table_in({x[6][7],x[6][6],x[6][5],x[6][4]}), .table_out(sum_0[25]));
  My_Rom3 My_Rom73 ( .table_in({x[6][11],x[6][10],x[6][9],x[6][8]}), .table_out(sum_0[26]));
  My_Rom4 My_Rom74 ( .table_in({x[6][15],x[6][14],x[6][13],x[6][12]}), .table_out(sum_0[27]));

  My_Rom1 My_Rom81 ( .table_in({x[7][3],x[7][2],x[7][1],x[7][0]}), .table_out(sum_0[28]));
  My_Rom2 My_Rom82 ( .table_in({x[7][7],x[7][6],x[7][5],x[7][4]}), .table_out(sum_0[29]));
  My_Rom3 My_Rom83 ( .table_in({x[7][11],x[7][10],x[7][9],x[7][8]}), .table_out(sum_0[30]));
  My_Rom4 My_Rom84 ( .table_in({x[7][15],x[7][14],x[7][13],x[7][12]}), .table_out(sum_0[31]));

  add1p my_add1p (.x(t0),.y(t1 <<< 2),.sum(s0),.clk(clk));
  add1p my_add2p (.x(t2),.y(t3 <<< 2),.sum(s1),.clk(clk));
  add1p my_add3p (.x(reg_s0),.y(reg_s1 <<< 4),.sum(dout),.clk(clk));
  add1p my_add4p (.x(h[0]),.y(h[1] <<< 1),.sum(tin0),.clk(clk));
  add1p my_add5p (.x(h[2]),.y(h[3] <<< 1),.sum(tin1),.clk(clk));
  add1p my_add6p (.x(h[4]),.y(h[5] <<< 1),.sum(tin2),.clk(clk));
  add1p my_add7p (.x(h[6]),.y(h[7] <<< 1),.sum(tin3),.clk(clk));
endmodule



