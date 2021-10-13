module FIR_tb();
reg [7:0] din;
reg clk;
reg rst;
wire signed [16:0] dout;
FIR uut_FIR(
.din(din),
.clk(clk),
.rst(rst),
.dout(dout)
);
always #5 clk=~clk;
initial
begin
clk = 0;
rst=1;
din=8'h00;
#40;
rst=0;
#40;
rst=1;
din=8'h01;
#10;
din=8'h00;
#1000;
end
endmodule