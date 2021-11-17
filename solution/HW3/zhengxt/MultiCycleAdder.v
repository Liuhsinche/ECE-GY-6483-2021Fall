`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/22 00:02:12
// Design Name: 
// Module Name: Multicycle
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module FA(
input Ci,input A,input B,
output S,output Co
);
assign {Co,S}=A+B+Ci;
endmodule

module HA(
input A,input B,
output S,output Co
);
assign {Co,S}=A+B;
endmodule

module FA4(
input Ci,
input [3:0] A,
input [3:0] B,
output [3:0] S,
output Co
);
wire [3:0] P;
wire [3:0] C;
wire BP;
assign P[0]=A[0] ^ B[0];
assign P[1]=A[1] ^ B[1];
assign P[2]=A[2] ^ B[2];
assign P[3]=A[3] ^ B[3];
assign BP=P[0]&P[1]&P[2]&P[3];
FA FA_0(Ci,A[0],B[0],S[0],C[0]);
FA FA_1(C[0],A[1],B[1],S[1],C[1]);
FA FA_2(C[1],A[2],B[2],S[2],C[2]);
FA FA_3(C[2],A[3],B[3],S[3],C[3]);
assign Co = BP ? Ci:C[3];
endmodule

module FA8(
input clk,
input Ci,
input [7:0] A,
input [7:0] B,
output [7:0] S,
output Co
);

wire Cinte1,Cinte2;
reg Cinte;
reg [3:0] RA;
reg [3:0] RB;
reg [3:0] RS;
wire [3:0] RSS;
FA4 FA4_0(Ci,A[3:0],B[3:0],RSS,Cinte1);
FA4 FA4_1(Cinte2,RA,RB,S[7:4],Co);
assign S[3:0]=RS;
assign Cinte2 = Cinte;
always@(posedge clk)
begin
Cinte<=Cinte1;
RA <= A[7:4];
RB <= B[7:4];
RS <= RSS;
end  
endmodule

module FA17(
input clk,
input Ci,
input [16:0] A,
input [16:0] B,
output [16:0] S,
output Co
);

wire [0:3] Cinte1;
reg Cinte;
reg [3:0] RA1;
reg [3:0] RA2;
reg [3:0] RB1;
reg [3:0] RB2;
reg [3:0] RS1,RS2;
wire [3:0] RSS1,RSS2;
reg RA3,RB3;
FA4 FA4_0(Ci,A[3:0],B[3:0],RSS1,Cinte1[0]);
FA4 FA4_1(Cinte1[0],A[7:4],B[7:4],RSS2,Cinte1[1]);
FA4 FA4_2(Cinte,RA1,RB1,S[11:8],Cinte1[2]);
FA4 FA4_3(Cinte1[2],RA2,RB2,S[15:12],Cinte1[3]);
FA  FA_0(Cinte1[3],RA3,RB3,S[16],Co);
assign S[3:0] = RS1;
assign S[7:4] = RS2;
always@(posedge clk)
begin
Cinte<=Cinte1[1];
RA1 <= A[11:8];
RA2 <= A[15:12];
RB1 <= B[11:8];
RB2 <= B[15:12];
RA3 <= A[16];
RB3 <= B[16];
RS1 <= RSS1;
RS2 <= RSS2;

end
endmodule

module FIR(
input [7:0] din,
input clk,
input rst,
output signed [16:0] dout
);
parameter signed [4:0] h0 = 5'd1;
parameter signed [4:0] h1 = -5'd2;
parameter signed [4:0] h2 = 5'd3;
parameter signed [4:0] h3 = -5'd4;
parameter signed [4:0] h4 = 5'd5;
parameter signed [4:0] h5 = -5'd6;
parameter signed [4:0] h6 = 5'd7;
parameter signed [4:0] h7 = -5'd8;

    reg signed [7:0] x [0:15];
    integer i;
    always@(posedge clk, negedge rst)
    begin:shift
        if(rst == 0)
        begin 
            for(i=0;i<16;i=i+1)
            begin
            x[i] <= 0;
            end
        end 
        else begin
            x[0] <= din;
            for(i=1;i<16;i=i+1)
            begin
            x[i] <= x[i-1];
            end 
            end 
    end

    wire [7:0] x_int [0:7];
    wire [0:7] c_int ;
    wire signed [8:0] x_int1 [0:7];
    wire signed [13:0] x_int2 [0:7];
    wire signed [12:0] x_int3;

    FA8 FA8_1(clk,0,x[0],x[15],x_int[0],c_int[0]);
    FA8 FA8_2(clk,0,x[1],x[14],x_int[1],c_int[1]);
    FA8 FA8_3(clk,0,x[2],x[13],x_int[2],c_int[2]);
    FA8 FA8_4(clk,0,x[3],x[12],x_int[3],c_int[3]);
    FA8 FA8_5(clk,0,x[4],x[11],x_int[4],c_int[4]);
    FA8 FA8_6(clk,0,x[5],x[10],x_int[5],c_int[5]);
    FA8 FA8_7(clk,0,x[6],x[9],x_int[6],c_int[6]);
    FA8 FA8_8(clk,0,x[7],x[8],x_int[7],c_int[7]);
    
    assign x_int1[0] = {c_int[0],x_int[0]};
    assign x_int2[0] = x_int1[0]*h0;
    assign x_int1[1] = {c_int[1],x_int[1]};
    assign x_int2[1] = x_int1[1]*h1;
    assign x_int1[2] = {c_int[2],x_int[2]};
    assign x_int2[2] = x_int1[2]*h2;            
    assign x_int1[3] = {c_int[3],x_int[3]};
    assign x_int2[3] = x_int1[3]*h3;    
    assign x_int1[4] = {c_int[4],x_int[4]};
    assign x_int2[4] = x_int1[4]*h4; 
    assign x_int1[5] = {c_int[5],x_int[5]};
    assign x_int2[5] = x_int1[5]*h5;                 
    assign x_int1[6] = {c_int[6],x_int[6]};
    assign x_int2[6] = x_int1[6]*h6;
    assign x_int1[7] = {c_int[7],x_int[7]};     
    assign x_int2[7] = x_int1[7]*h7;
    
    wire signed [16:0] sum1 [0:3];
    wire signed [16:0] sum2 [0:1];
    wire signed [16:0] sum3;
    wire [0:3] C1;
    wire [0:1] C2;
    wire C3;
    FA17 FA17_1(clk,0,{{3{x_int2[0][13]}},x_int2[0]},{{3{x_int2[1][13]}},x_int2[1]},sum1[0],C1[0]);
    FA17 FA17_2(clk,0,{{3{x_int2[2][13]}},x_int2[2]},{{3{x_int2[3][13]}},x_int2[3]},sum1[1],C1[1]);
    FA17 FA17_3(clk,0,{{3{x_int2[4][13]}},x_int2[4]},{{3{x_int2[5][13]}},x_int2[5]},sum1[2],C1[2]);
    FA17 FA17_4(clk,0,{{3{x_int2[6][13]}},x_int2[6]},{{3{x_int2[7][13]}},x_int2[7]},sum1[3],C1[3]);

    FA17 FA17_5(clk,0,sum1[0],sum1[1],sum2[0],C2[0]);
    FA17 FA17_6(clk,0,sum1[2],sum1[3],sum2[1],C2[1]);

    FA17 FA17_7(clk,0,sum2[0],sum2[1],sum3,C3);
        
    assign dout = sum3;

endmodule

        


