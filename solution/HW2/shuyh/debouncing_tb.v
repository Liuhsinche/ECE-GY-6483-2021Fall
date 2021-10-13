`timescale 1ns / 1ps

module debouncing_tb();

reg clk = 1'b0;
reg button_in = 1'b0;
wire button_out;

always #5 clk = ~clk;
initial
    begin
        #400 button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        
        #400 button_in = 1'b0;
       
        #2   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;
        #3   button_in = 1'b1;
        #3   button_in = 1'b0;  
    end
    
    debouncing uut (.ButtonIn(button_in),.ButtonOut(button_out),.CLK(clk));
    
endmodule
