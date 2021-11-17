`timescale 1ns / 1ps
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

wire[15:0] s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14;
reg[7:0] din_mem [0:15];
wire[15:0]  d0=s0;
wire[15:0]  d1=-(s1)<<1;
wire[15:0]  d2=(s2<<1)+(s2);
wire[15:0]  d3=-(s3)<<2;
wire[15:0]  d4=((s4)<<2)+(s4);
wire[15:0]  d5=-((s5)<<2)-((s5)<<1);
wire[15:0]  d6=((s6)<<3)-(s6);
wire[15:0]  d7=-(s7)<<3;
MultiCycleAdder A0({8'b0,din_mem[0]},{8'b0,din_mem[15]},0,clk,rst,s0);
MultiCycleAdder A1({8'b0,din_mem[1]},{8'b0,din_mem[14]},0,clk,rst,s1);
MultiCycleAdder A2({8'b0,din_mem[2]},{8'b0,din_mem[13]},0,clk,rst,s2);
MultiCycleAdder A3({8'b0,din_mem[3]},{8'b0,din_mem[12]},0,clk,rst,s3);
MultiCycleAdder A4({8'b0,din_mem[4]},{8'b0,din_mem[11]},0,clk,rst,s4);
MultiCycleAdder A5({8'b0,din_mem[5]},{8'b0,din_mem[10]},0,clk,rst,s5);
MultiCycleAdder A6({8'b0,din_mem[6]},{8'b0,din_mem[9]},0,clk,rst,s6);
MultiCycleAdder A7({8'b0,din_mem[7]},{8'b0,din_mem[8]},0,clk,rst,s7);
MultiCycleAdder A8(d0,d1,0,clk,rst,s8);
MultiCycleAdder A9(d2,d3,0,clk,rst,s9);
MultiCycleAdder A10(d4,d5,0,clk,rst,s10);
MultiCycleAdder A11(d6,d7,0,clk,rst,s11);
MultiCycleAdder A12(s8,s9,0,clk,rst,s12);
MultiCycleAdder A13(s10,s11,0,clk,rst,s13);
MultiCycleAdder A14(s12,s13,0,clk,rst,s14);
assign dout={s14[15],s14};
//assign dout=s14;
integer i;
always@(posedge clk, negedge rst) begin
    if(~rst)
 begin
        for(i=0;i<=15;i=i+1)
            din_mem[i] <= 0;
        
    end
    else
 begin
        din_mem[0] <= din;
        for(i=1;i<=15;i=i+1)
            din_mem[i] <= din_mem[i-1];
    end
end    
endmodule
