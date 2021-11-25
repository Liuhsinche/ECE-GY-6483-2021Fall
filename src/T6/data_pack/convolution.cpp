#include "convolution.h"

void convolution_sw(DT *ifm, DT *ofm, DT *weight, layer l)
{
    for (int oh = 0; oh < l.oh; oh++)
    {
        for (int ow = 0; ow < l.ow; ow++)
        {
            for (int oc = 0; oc < l.oc; oc++)
            {
                DT odata = 0;
                int ofm_index = oc * l.oh*l.ow + oh * l.ow + ow;
                for (int ic = 0; ic < l.ic; ic++)
                {
                    for(int kh = 0; kh < l.k; kh++)
                    {
                        for (int kw = 0; kw < l.k; kw++)
                        {
                            DT ret;
                            int fw = ow*l.s - l.p + kw;
                            int fh = oh*l.s - l.p + kh;
                            int ifm_index = ic*l.ih*l.iw + fh*l.iw + fw;
                            int wgt_index = oc*l.ic*l.k*l.k + ic*l.k*l.k + kh*l.k + kw;

							if( (fw<0) || (fh<0) || (fw>(l.iw-1)) || (fh>(l.ih-1)))
                                ret=0;
                            else
                                ret = ifm[ifm_index];
                            ret *= weight[wgt_index];
                            odata += ret;
                        }
                    }
                }
                ofm[ofm_index] = odata;
            }
        }
    }
}

static void Load_WBUF(DT16* weight, DT WBUF[N*M][K*K])
{
#pragma HLS INLINE
	DT16 tmp;
	for (int m = 0; m<M; m++)
	{
		for (int k = 0; k<K*K; k++)
		{
#pragma HLS PIPELINE

			tmp = weight[m*K*K + k];
			for(int n = 0; n<N; n++)
			{
				WBUF[m*N+n][k] = tmp.data[n];
			}
		}
	}
}

static void Load_IBUF(DT16* in, DT IBUF[N][IR*IC])
{
#pragma HLS INLINE
	DT16 tmp;

	for (int i = 0; i<R*C; i++)
	{
#pragma HLS PIPELINE
		tmp = in[i];
		for(int n = 0; n<N; n++)
		{
			IBUF[n][i] = tmp.data[n];
		}
	}
}

static void CONV(DT IBUF[N][IR*IC], DT OBUF[M][OR*OC], DT WBUF[N*M][K*K])
{
	for(int kr = 0; kr < K; kr++)
	{
		for (int kc = 0; kc < K; kc++)
		{
			for (int r = 0; r < OR; r++)
			{
convolution:    for (int c = 0; c < OC; c++)
				{
#pragma HLS PIPELINE II=1
					for (int m = 0; m < M; m++)
					{
#pragma HLS UNROLL
						float odata = OBUF[m][r*OC + c];
						for (int n = 0; n < N; n++)
						{
#pragma HLS UNROLL
							float ret;
							int ic = c*S - P + kc;
							int ir = r*S - P + kr;
							if( (ic<0) || (ir<0) || (ic>(IC-1)) || (ir>(IR-1)))
								ret=0;
							else
								ret = IBUF[n][ir*IC + ic];
							ret *= WBUF[m*N+n][kr*K + kc];
							odata += ret;
						}
						OBUF[m][r*OC + c] = odata;
					}
				}
			}
		}
	}
}

static void Export_OBUF(DT16* out, DT OBUF[M][OR*OC])
{
#pragma HLS INLINE
	DT16 tmp;

	for (int i = 0; i<R*C; i++)
	{
#pragma HLS PIPELINE
		for(int m = 0; m<M; m++)
		{
			tmp.data[m] = OBUF[m][i];
		}
		out[i] = tmp;
	}
}

void convolution_hw(DT16* in, DT16* out, DT16* weight, layer l)
{
#pragma HLS INTERFACE m_axi depth=l.ic*l.iw*l.ih/16 port=in	offset=slave bundle=in
#pragma HLS INTERFACE m_axi depth=l.oc*l.ow*l.oh/16 port=out	offset=slave bundle=out
#pragma HLS INTERFACE m_axi depth=l.oc*l.ic*l.k*l.k/16 port=weight	offset=slave bundle=weight

#pragma HLS DATA_PACK variable=in      struct_level
#pragma HLS DATA_PACK variable=out     struct_level
#pragma HLS DATA_PACK variable=weight  struct_level

	DT IBUF[N][IR*IC];
#pragma HLS ARRAY_PARTITION variable=IBUF complete dim=1
	DT OBUF[M][OR*OC];
#pragma HLS ARRAY_PARTITION variable=OBUF complete dim=1
	DT WBUF[N*M][K*K];
#pragma HLS ARRAY_PARTITION variable=WBUF complete dim=1

	Load_WBUF(weight, WBUF);
	Load_IBUF(in, IBUF);
	CONV(IBUF, OBUF, WBUF);
	Export_OBUF(out, OBUF);

}

