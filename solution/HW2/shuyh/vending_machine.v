`timescale 1ns / 1ps

module vending_machine(
input Enable, input RST, input CLK,
input OneDollar, input FiftyCents, input TenCents, input FiveCents,
output reg Deliver,
output reg [7:0] Money);
   
reg [2:0] Current_State,Next_State;

parameter Price = 8'd125;
parameter INIT  = 3'b001; // Initial State
parameter COUNT = 3'b010; // Count the Coin State
parameter DEL = 3'b100;   // Deliver State
 
always @(posedge CLK)
begin
    if(RST) 
        Current_State <= Next_State;
    else    
        Current_State <= INIT ;
end
  
always @(Current_State or Enable or OneDollar or FiftyCents or TenCents or FiveCents) // If don't put Enable signal into sensetive list, we will get a dirrerent result.
begin
    case (Current_State)
        INIT:
            begin
                Deliver = 0;
                Money = 0;
                if(Enable)  
                    Next_State = COUNT; 
             end
        COUNT:
            begin
                if(Money >= Price)  
                    begin
                        Next_State = DEL;
                    end
                else
                    begin
                        Next_State = COUNT;
                        if(OneDollar)   
                            Money = Money + 100;
                        else if(FiftyCents) 
                            Money = Money + 50;
                        else if(TenCents)   
                            Money = Money + 10;
                        else if(FiveCents)  
                            Money = Money + 5;
                        else;    
                    end    
            end
        DEL:
            begin
                Deliver = 1;
                Next_State = INIT;
            end
    endcase        
end 
   
endmodule
