
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


module MultiCycleAdder(
	input [15:0] A,
	input [15:0] B,
	input ci,
	input clk,
	input rst,
	output reg [15:0] S
	
);
wire [3:0] S3, S4;
wire C1,C2, C3, C4;
wire [3:0] S1, S2;
reg [7:0] S_d;
reg cin, cin_d;
reg [3:0] A1, B1, A2, B2, A3, B3, A4, B4;
reg [3:0] A1_d, B1_d, A2_d, B2_d;

FA4 FA4_0(cin, A1, B1, S1, C1);
FA4 FA4_1(C1, A2, B2, S2, C2);
FA4 FA4_2(cin_d, A1_d, B1_d, S3, C3);
FA4 FA4_3(C3, A2_d, B2_d, S4, C4);
//assign S = {S4, S3, S_d};

always@(posedge clk or negedge rst)
begin
	if (!rst)
		begin
			S <= 0;
			A1 <= 0;
			B1 <= 0;
			A2 <= 0;
			B2 <= 0;
			A3 <= 0;
			B3 <= 0;
			A4 <= 0;
			B4 <= 0;
            A1_d <= 0;
			B1_d <= 0;
			A2_d <= 0;
			B2_d <= 0;
			S_d <= 0;
			cin<= 0;
			cin_d <= 0;
		end
	else
		begin
			A1 <= A[3:0];
			B1 <= B[3:0];
			A2 <= A[7:4];
			B2 <= B[7:4];
			A3 <= A[11:8];
			B3 <= B[11:8];
			A4 <= A[15:12];
			B4 <= B[15:12];
            A1_d <= A3;
			B1_d <= B3;
			A2_d <= A4;
			B2_d <= B4;
			S_d <= {S2, S1};
			cin<= ci;
			cin_d <= C2;
			S<= {S4, S3, S_d};
		end
    end

endmodule	

	
	