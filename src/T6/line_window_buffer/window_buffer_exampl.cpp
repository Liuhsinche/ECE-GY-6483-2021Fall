/*
This is an example of using window buffer and line buffer in Depthwise Convolution. 
*/

BDT DOT_MUL(
    ADT A_00, ADT A_01, ADT A_02,
    ADT A_10, ADT A_11, ADT A_12, 
    ADT A_20, ADT A_21, ADT A_22, 
    WDT B_00, WDT B_01, WDT B_02, 
    WDT B_10, WDT B_11, WDT B_12, 
    WDT B_20, WDT B_21, WDT B_22)
{
#pragma HLS INLINE OFF
#pragma HLS LATENCY min=1
    ap_int<14> prod_00 = A_00 * B_00;
    ap_int<14> prod_01 = A_01 * B_01;
    ap_int<14> prod_02 = A_02 * B_02;
    ap_int<14> prod_10 = A_10 * B_10;
    ap_int<14> prod_11 = A_11 * B_11;
    ap_int<14> prod_12 = A_12 * B_12;
    ap_int<14> prod_20 = A_20 * B_20;
    ap_int<14> prod_21 = A_21 * B_21;
    ap_int<14> prod_22 = A_22 * B_22;

    ap_int<15> sum_0 = prod_00 + prod_11;
    ap_int<15> sum_1 = prod_01 + prod_12;
    ap_int<15> sum_2 = prod_02 + prod_20;
    ap_int<15> sum_3 = prod_10 + prod_21;

    ap_int<16> res_0 = sum_0 + sum_1;
    ap_int<16> res_1 = sum_2 + sum_3;
    ap_int<16> res_2 = prod_22;

    ap_int<18> res = res_0 + res_1 + res_2;
    return res > bmax ? BDT(bmax) : res < bmin ? BDT(bmin) : BDT(res);
}

void DWCONV3X3_PL(ADT IFM[32][43][83], BDT OFM[32][43][83], WDT WBUF3x3[32][3][3])
{
#pragma HLS ARRAY_PARTITION variable=OFM dim=1 complete
#pragma HLS ARRAY_PARTITION variable=IFM dim=1 complete
#pragma HLS ARRAY_PARTITION variable=WBUF3x3 dim=0 complete

    ADT window_buffer[32][3][3];
#pragma HLS ARRAY_PARTITION variable=window_buffer complete dim=0
    ADT line_buffer[32][3][43];
#pragma HLS ARRAY_PARTITION variable=line_buffer complete dim=1
#pragma HLS ARRAY_PARTITION variable=line_buffer complete dim=2

    for (int row_in = 0; row_in < 83; row_in++)
    {
        for (int col_in = 0; col_in < 43; col_in++)
        {
        #pragma HLS LOOP_FLATTEN
        #pragma HLS PIPELINE II=1
            for (int c = 0; c < 32; c++)
            {
            #pragma HLS UNROLL
                ADT read_in = IFM[c][col_in][row_in];
                line_buffer[c][row_in % 3][col_in] = read_in;

                window_buffer[c][2][2] = read_in;
                window_buffer[c][1][2] = line_buffer[c][(row_in + 2) % 3][col_in];
                window_buffer[c][0][2] = line_buffer[c][(row_in + 1) % 3][col_in];

                if (row_in >= 2 && col_in >= 2)
                {
                    BDT result = DOT_MUL( 
                        window_buffer[c][0][0], window_buffer[c][0][1], window_buffer[c][0][2], 
                        window_buffer[c][1][0], window_buffer[c][1][1], window_buffer[c][1][2], 
                        window_buffer[c][2][0], window_buffer[c][2][1], window_buffer[c][2][2], 
                        WBUF3x3[c][0][0], WBUF3x3[c][1][0], WBUF3x3[c][2][0], 
                        WBUF3x3[c][0][1], WBUF3x3[c][1][1], WBUF3x3[c][2][1], 
                        WBUF3x3[c][0][2], WBUF3x3[c][1][2], WBUF3x3[c][2][2]);

                    OFM[c][col_in - 1][row_in - 1] = result;
                }
                
                for (int r = 0; r < 3; r++)
                {
                #pragma HLS UNROLL
                    window_buffer[c][r][0] = window_buffer[c][r][1];
                    window_buffer[c][r][1] = window_buffer[c][r][2];
                }
            }
        }
    }
}