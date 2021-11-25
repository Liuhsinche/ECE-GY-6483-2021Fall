/*******************************************************************************
Vendor: Xilinx 
Associated Filename: matrixmul.cpp
Purpose: Vivado HLS tutorial example 
Device: All 
Revision History: March 1, 2013 - initial release
                                                
*******************************************************************************
Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.

This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer asresultes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/
#include "matrixmul.h"

#include "ap_int.h"
#include "hls_stream.h"

typedef hls::stream<ap_int<8> > wire;
typedef hls::stream<ap_int<18> > wire_result;

void MAC(const ap_int<8> A0, const ap_int<8> A1, const ap_int<8> B, ap_int<48> C, ap_int<48> &D, ap_int<3> &fix)
{
#pragma HLS INLINE

   D = ((ap_int<27>(A0) << 18) + ap_int<27>(A1)) * ap_int<18>(B) + C;

   ap_uint<3> sign_bits_d = D.range(17, 15);
   ap_uint<3> sign_bits_c = C.range(17, 15);

   fix += (sign_bits_d.and_reduce() & !sign_bits_c.or_reduce());
   fix -= (!sign_bits_d.or_reduce() & sign_bits_c.and_reduce());
}

void PE(wire &a0_in, wire &a0_out, wire &a1_in, wire &a1_out, wire &b_in, wire &b_out, wire_result &c0, wire_result &c1)
{
#pragma HLS INLINE off
   ap_int<8> a0_pe, a1_pe;
   ap_int<8> b_pe;

   ap_int<3> fix = 0;

   ap_int<48> c_pe = 0;
   ap_int<48> d_pe;

Loop_in_PE:
   for (int counter = 0; counter < MAT_A_COLS; counter++)
   {
#pragma HLS PIPELINE II=1 rewind
      a0_in.read(a0_pe);
      a1_in.read(a1_pe);
      b_in.read(b_pe);

      MAC(a0_pe, a1_pe, b_pe, c_pe, d_pe, fix);

      c_pe = d_pe;

      a0_out.write(a0_pe);
      a1_out.write(a1_pe);
      b_out.write(b_pe);
   }

   c0.write(ap_int<18>(c_pe.range(35, 18)) + fix);
   c1.write(ap_int<18>(c_pe.range(17, 0)));
}

void PE_array(wire input_a[PE_SIZE], wire input_b[PE_SIZE], wire_result output_c[PE_SIZE][PE_SIZE])
{
#pragma HLS DATAFLOW disable_start_propagation
#pragma HLS interface ap_ctrl_none port = return

   wire Inter_PE_A[PE_SIZE][PE_SIZE + 1];
   wire Inter_PE_B[PE_SIZE / 2 + 1][PE_SIZE];

read_into_PE:
   for (int counter = 0; counter < MAT_A_COLS; counter++)
   {
#pragma HLS PIPELINE II=1 rewind
      for (int place = 0; place < PE_SIZE; place++)
      {
#pragma HLS UNROLL
         Inter_PE_A[place][0].write(input_a[place].read());
         Inter_PE_B[0][place].write(input_b[place].read());
      }
   }

   for (int place_r = 0; place_r < PE_SIZE; place_r += 2)
   {
#pragma HLS UNROLL
      for (int place_c = 0; place_c < PE_SIZE; place_c++)
      {
#pragma HLS UNROLL
         PE(Inter_PE_A[place_r + 0][place_c + 0],
            Inter_PE_A[place_r + 0][place_c + 1],
            Inter_PE_A[place_r + 1][place_c + 0],
            Inter_PE_A[place_r + 1][place_c + 1],
            Inter_PE_B[place_r / 2 + 0][place_c + 0],
            Inter_PE_B[place_r / 2 + 1][place_c + 0],
            output_c[place_r + 0][place_c], 
            output_c[place_r + 1][place_c]);
      }
   }

read_frome_PE:
   for (int counter = 0; counter < MAT_A_COLS; counter++)
   {
#pragma HLS PIPELINE II=1 rewind
      for (int place = 0; place < PE_SIZE; place++)
      {
#pragma HLS UNROLL
         Inter_PE_A[place][PE_SIZE].read();
         Inter_PE_B[PE_SIZE / 2][place].read();
      }
   }
}

void read_input(
    mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
    mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
    wire input_a[PE_SIZE],
    wire input_b[PE_SIZE])
{
#pragma HLS ARRAY_PARTITION variable=a cyclic factor=PE_SIZE dim=1
#pragma HLS ARRAY_PARTITION variable=b cyclic factor=PE_SIZE dim=2

   for (int r = 0; r < MAT_A_ROWS; r += PE_SIZE)
   {
      for (int c = 0; c < MAT_B_COLS; c += PE_SIZE)
      {
         for (int k = 0; k < MAT_A_COLS; k++)
         {
#pragma HLS LOOP_FLATTEN
#pragma HLS PIPELINE II=1 rewind
            for (int place = 0; place < PE_SIZE; place++)
            {
#pragma HLS UNROLL
               input_a[place].write(a[r + place][k]);
               input_b[place].write(b[k][c + place]);
            }
         }
      }
   }
}

void write_output(
    wire_result output_c[PE_SIZE][PE_SIZE],
    result_t res[MAT_A_ROWS][MAT_B_COLS])
{
#pragma HLS ARRAY_PARTITION variable=res cyclic factor=PE_SIZE dim=0

   for (int r = 0; r < MAT_A_ROWS; r += PE_SIZE)
   {
      for (int c = 0; c < MAT_B_COLS; c += PE_SIZE)
      {
#pragma HLS LOOP_FLATTEN
#pragma HLS PIPELINE II=1 rewind
         for (int place_r = 0; place_r < PE_SIZE; place_r++)
         {
#pragma HLS UNROLL
            for (int place_c = 0; place_c < PE_SIZE; place_c++)
            {
#pragma HLS UNROLL
               res[r + place_r][c + place_c] = output_c[place_r][place_c].read().to_int();
            }
         }
      }
   }
}

void call_PE_array(wire input_a[PE_SIZE], wire input_b[PE_SIZE], wire_result output_c[PE_SIZE][PE_SIZE])
{
   for (int r = 0; r < MAT_A_ROWS / PE_SIZE; r++)
   {
      for (int c = 0; c < MAT_B_COLS / PE_SIZE; c++)
      {
#pragma HLS LOOP_FLATTEN
#pragma HLS DATAFLOW disable_start_propagation
         PE_array(input_a, input_b, output_c);
      }
   }
}

void matrixmul(
    mat_a_t a[MAT_A_ROWS][MAT_A_COLS],
    mat_b_t b[MAT_B_ROWS][MAT_B_COLS],
    result_t res[MAT_A_ROWS][MAT_B_COLS])
{
#pragma HLS DATAFLOW
   
   wire input_a[PE_SIZE];
   wire input_b[PE_SIZE];
   wire_result output_c[PE_SIZE][PE_SIZE];

   read_input(a, b, input_a, input_b);
   call_PE_array(input_a, input_b, output_c);
   write_output(output_c, res);
}
