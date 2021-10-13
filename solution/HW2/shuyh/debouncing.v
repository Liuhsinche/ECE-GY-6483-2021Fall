`timescale 1ns / 1ps

module debouncing(
input CLK,
input ButtonIn,
output reg ButtonOut
    );
    
parameter SAMPLE_TIME = 8; // Sample time = 10*clk
 
reg [21:0] count_low;  // Calculate the frequence of low level during sample time
reg [21:0] count_high; // Calculate the frequence of high level during sample time
reg key_out_reg;       // register key_out_reg as the temp value of ButtonOut

always @(posedge CLK) // Calculate the frequence of low level during sample time
    begin
        if(ButtonIn == 1'b0)
            count_low <= count_low + 1;
        else
            count_low <= 0;
    end

always @(posedge CLK) // Calculate the frequence of high level during sample time
    begin
        if(ButtonIn == 1'b1)
            count_high <= count_high + 1;
        else
            count_high <= 0;
    end
    
always @(posedge CLK)
    begin
        if(count_high == SAMPLE_TIME)
          key_out_reg <= 1;
        else if(count_low == SAMPLE_TIME)
            key_out_reg <= 0;
    end
    
always @(posedge CLK)
    begin
        ButtonOut <= key_out_reg;
    end
    
endmodule
