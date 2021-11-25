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


void convolution_hw(DT *ifm, DT *ofm, DT *weight)
{

    for (int r = 0; r < OR; r++)
    {
        for (int c = 0; c < OC; c++)
        {
            for (int m = 0; m < M; m++)
            {
                float odata = 0;
                int ofm_index = m*OR*OC + r*OC + c;
                for (int n = 0; n < N; n++)
                {
                    for(int kr = 0; kr < K; kr++)
                    {
                        for (int kc = 0; kc < K; kc++)
                        {
                            float ret;
                            int ic = c*S - P + kc;
                            int ir = r*S - P + kr;

							if( (ic<0) || (ir<0) || (ic>(IC-1)) || (ir>(IR-1)))
                                ret=0;
                            else
                                ret = ifm[n*IR*IC + ir*IC + ic];
                            ret *= weight[m*N*K*K + n*K*K + kr*K + kc];
                            odata += ret;
                        }
                    }
                }
                ofm[ofm_index] = odata;
            }
        }
    }
}
