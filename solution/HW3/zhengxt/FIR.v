`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/21 19:56:18
// Design Name: 
// Module Name: FIR
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


module FIR(
input [7:0] din,
input clk,
input rst,
output reg signed [16:0] dout
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

    always@(posedge clk, negedge rst)
    begin:convolution
        if(rst == 0)
            dout <= 0;
        else begin
            dout <= (x[0]+x[15])*h0+(x[1]+x[14])*h1+(x[2]+x[13])*h2
            +(x[3]+x[12])*h3+(x[4]+x[11])*h4+(x[5]+x[10])*h5+(x[6]+x[9])*h6
            +(x[7]+x[8])*h7;
        end
    end
endmodule

