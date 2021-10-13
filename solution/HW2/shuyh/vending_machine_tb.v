`timescale 1ns / 1ps

module vending_machine_tb();

reg clk = 1'b0;
reg rst,onedollar,fiftycents,tencents,fivecents;
reg enable;
wire[7:0] money;
wire deliver;

always #10 clk = ~clk;
initial
    begin
        rst = 1'b0;
        onedollar = 1'b0;
        fiftycents = 1'b0;
        tencents = 1'b0;
        fivecents = 1'b0;
        enable = 1'b0;
    #20 enable = 1'b1;
        rst = 1'b1;
    #20 enable = 1'b0;
  #3460 enable = 1'b1;
    #20 enable = 1'b0;
    end
initial
    begin
    #2350 fiftycents = 1'b1;
    #50   fiftycents = 1'b0;
    #100  fiftycents = 1'b1;
    #50   fiftycents = 1'b0;
   
    #100  fivecents = 1'b1;
    #50   fivecents = 1'b0;
    #100  fivecents = 1'b1;
    #50   fivecents = 1'b0;
    #100  fivecents = 1'b1;
    #50   fivecents = 1'b0;
    #100  fivecents = 1'b1;
    #50   fivecents = 1'b0;
    #100  fivecents = 1'b1;
    #50   fivecents = 1'b0;
    #110  fivecents = 1'b1;
    #40   fivecents = 1'b0;
    
    #200  fiftycents = 1'b1;
    #50   fiftycents = 1'b0;
    #100  fiftycents = 1'b1;
    #50   fiftycents = 1'b0;
    
     #100  fivecents = 1'b1;
     #50   fivecents = 1'b0;
     #100  fivecents = 1'b1;
     #50   fivecents = 1'b0;
     #100  fivecents = 1'b1;
     #50   fivecents = 1'b0;
     #100  fivecents = 1'b1;
     #50   fivecents = 1'b0;
     #100  fivecents = 1'b1;
     #50   fivecents = 1'b0;
     #110  fivecents = 1'b1;
     #40   fivecents = 1'b0;
    end
vending_machine uut (.Enable(enable),.CLK(clk),.OneDollar(onedollar),.RST(rst),.FiftyCents(fiftycents),.TenCents(tencents),.FiveCents(fivecents),.Deliver(deliver),.Money(money));
endmodule
