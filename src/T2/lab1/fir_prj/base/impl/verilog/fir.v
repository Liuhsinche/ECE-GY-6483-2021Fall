// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
// Version: 2019.2
// Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="fir,hls_ip_2019_2,{HLS_INPUT_TYPE=c,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k160t-fbg484-1,HLS_INPUT_CLOCK=3.333000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=2.850000,HLS_SYN_LAT=122,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=3,HLS_SYN_FF=494,HLS_SYN_LUT=224,HLS_VERSION=2019_2}" *)

module fir (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        y,
        y_ap_vld,
        c_address0,
        c_ce0,
        c_q0,
        x
);

parameter    ap_ST_fsm_state1 = 12'd1;
parameter    ap_ST_fsm_state2 = 12'd2;
parameter    ap_ST_fsm_state3 = 12'd4;
parameter    ap_ST_fsm_state4 = 12'd8;
parameter    ap_ST_fsm_state5 = 12'd16;
parameter    ap_ST_fsm_state6 = 12'd32;
parameter    ap_ST_fsm_state7 = 12'd64;
parameter    ap_ST_fsm_state8 = 12'd128;
parameter    ap_ST_fsm_state9 = 12'd256;
parameter    ap_ST_fsm_state10 = 12'd512;
parameter    ap_ST_fsm_state11 = 12'd1024;
parameter    ap_ST_fsm_state12 = 12'd2048;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [31:0] y;
output   y_ap_vld;
output  [3:0] c_address0;
output   c_ce0;
input  [31:0] c_q0;
input  [31:0] x;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg y_ap_vld;
reg c_ce0;

(* fsm_encoding = "none" *) reg   [11:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg   [3:0] shift_reg_address0;
reg    shift_reg_ce0;
reg    shift_reg_we0;
reg   [31:0] shift_reg_d0;
wire   [31:0] shift_reg_q0;
wire  signed [31:0] sext_ln60_fu_133_p1;
reg  signed [31:0] sext_ln60_reg_180;
wire    ap_CS_fsm_state2;
wire   [0:0] icmp_ln61_fu_145_p2;
reg   [0:0] icmp_ln61_reg_189;
wire   [0:0] tmp_fu_137_p3;
wire    ap_CS_fsm_state3;
wire   [4:0] grp_fu_126_p2;
reg   [4:0] i_reg_208;
reg  signed [31:0] c_load_reg_213;
wire    ap_CS_fsm_state4;
wire   [31:0] grp_fu_164_p2;
reg   [31:0] mul_ln68_reg_218;
wire    ap_CS_fsm_state11;
wire   [31:0] acc_fu_169_p2;
wire    ap_CS_fsm_state12;
reg   [31:0] acc_0_reg_91;
wire  signed [4:0] ap_phi_mux_i_0_phi_fu_108_p4;
reg  signed [4:0] i_0_reg_104;
reg  signed [31:0] data_0_reg_116;
wire   [63:0] zext_ln65_fu_151_p1;
wire   [63:0] zext_ln65_1_fu_156_p1;
wire   [63:0] zext_ln68_fu_160_p1;
reg  signed [4:0] grp_fu_126_p0;
wire    ap_CS_fsm_state5;
reg   [11:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 12'd1;
end

fir_shift_reg #(
    .DataWidth( 32 ),
    .AddressRange( 11 ),
    .AddressWidth( 4 ))
shift_reg_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(shift_reg_address0),
    .ce0(shift_reg_ce0),
    .we0(shift_reg_we0),
    .d0(shift_reg_d0),
    .q0(shift_reg_q0)
);

fir_mul_32s_32s_3bkb #(
    .ID( 1 ),
    .NUM_STAGE( 7 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
fir_mul_32s_32s_3bkb_U1(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(c_load_reg_213),
    .din1(data_0_reg_116),
    .ce(1'b1),
    .dout(grp_fu_164_p2)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state12)) begin
        acc_0_reg_91 <= acc_fu_169_p2;
    end else if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        acc_0_reg_91 <= 32'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln61_reg_189 == 1'd0) & (1'b1 == ap_CS_fsm_state3))) begin
        data_0_reg_116 <= shift_reg_q0;
    end else if (((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        data_0_reg_116 <= x;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state12)) begin
        i_0_reg_104 <= i_reg_208;
    end else if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        i_0_reg_104 <= 5'd10;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        c_load_reg_213 <= c_q0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        i_reg_208 <= grp_fu_126_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((tmp_fu_137_p3 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        icmp_ln61_reg_189 <= icmp_ln61_fu_145_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state11)) begin
        mul_ln68_reg_218 <= grp_fu_164_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        sext_ln60_reg_180 <= sext_ln60_fu_133_p1;
    end
end

always @ (*) begin
    if (((tmp_fu_137_p3 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((tmp_fu_137_p3 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        c_ce0 = 1'b1;
    end else begin
        c_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        grp_fu_126_p0 = i_0_reg_104;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_126_p0 = ap_phi_mux_i_0_phi_fu_108_p4;
    end else begin
        grp_fu_126_p0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        shift_reg_address0 = zext_ln65_1_fu_156_p1;
    end else if (((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        shift_reg_address0 = 4'd0;
    end else if (((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2))) begin
        shift_reg_address0 = zext_ln65_fu_151_p1;
    end else begin
        shift_reg_address0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state3) | ((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state2)) | ((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2)))) begin
        shift_reg_ce0 = 1'b1;
    end else begin
        shift_reg_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        shift_reg_d0 = shift_reg_q0;
    end else if (((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        shift_reg_d0 = x;
    end else begin
        shift_reg_d0 = 'bx;
    end
end

always @ (*) begin
    if ((((icmp_ln61_reg_189 == 1'd0) & (1'b1 == ap_CS_fsm_state3)) | ((tmp_fu_137_p3 == 1'd0) & (icmp_ln61_fu_145_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state2)))) begin
        shift_reg_we0 = 1'b1;
    end else begin
        shift_reg_we0 = 1'b0;
    end
end

always @ (*) begin
    if (((tmp_fu_137_p3 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
        y_ap_vld = 1'b1;
    end else begin
        y_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((tmp_fu_137_p3 == 1'd1) & (1'b1 == ap_CS_fsm_state2))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state5;
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state6;
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state7;
        end
        ap_ST_fsm_state7 : begin
            ap_NS_fsm = ap_ST_fsm_state8;
        end
        ap_ST_fsm_state8 : begin
            ap_NS_fsm = ap_ST_fsm_state9;
        end
        ap_ST_fsm_state9 : begin
            ap_NS_fsm = ap_ST_fsm_state10;
        end
        ap_ST_fsm_state10 : begin
            ap_NS_fsm = ap_ST_fsm_state11;
        end
        ap_ST_fsm_state11 : begin
            ap_NS_fsm = ap_ST_fsm_state12;
        end
        ap_ST_fsm_state12 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign acc_fu_169_p2 = (mul_ln68_reg_218 + acc_0_reg_91);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state11 = ap_CS_fsm[32'd10];

assign ap_CS_fsm_state12 = ap_CS_fsm[32'd11];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state3 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign ap_phi_mux_i_0_phi_fu_108_p4 = i_0_reg_104;

assign c_address0 = zext_ln68_fu_160_p1;

assign grp_fu_126_p2 = ($signed(grp_fu_126_p0) + $signed(5'd31));

assign icmp_ln61_fu_145_p2 = ((i_0_reg_104 == 5'd0) ? 1'b1 : 1'b0);

assign sext_ln60_fu_133_p1 = i_0_reg_104;

assign tmp_fu_137_p3 = i_0_reg_104[32'd4];

assign y = acc_0_reg_91;

assign zext_ln65_1_fu_156_p1 = $unsigned(sext_ln60_reg_180);

assign zext_ln65_fu_151_p1 = grp_fu_126_p2;

assign zext_ln68_fu_160_p1 = $unsigned(sext_ln60_reg_180);

endmodule //fir
