#include "convolution.h"
void generate(DT* ifm, DT* wgt)
{
	for(int i = 0; i < N*R*C; i++)
	{
		ifm[i] = (DT)i/3000.0;
	}
	for(int i = 0; i < N*M*K*K; i++)
	{
		wgt[i] = (DT)i/3000.0;
	}
}

void check(DT* ofm_sw, DT* ofm_hw)
{
	int error = 0;
	for(int i = 0; i < N*R*C; i++)
	{
		if (((ofm_sw[i] - ofm_hw[i]) > 0.01) || ((ofm_sw[i] - ofm_hw[i]) < -0.01))
			error++;
	}
	if(error>0) printf("error count = %d\n", error);
	else printf("correct!\n", error);
}


void fm_DT_2_DT16(DT* in, DT16* out)//m=M/16
{
	for (int i = 0; i < R*C; i++)
	{
		for (int n = 0; n < N; n++)
		{
			out[i].data[n]=in[n*R*C + i];
		}
	}
}

void fm_DT16_2_DT(DT16* in, DT* out)//m=M/16
{
	for (int i = 0; i < R*C; i++)
	{
		for (int m = 0; m < M; m++)
		{
			out[m*R*C + i] = in[i].data[m];
		}
	}
}

void w_DT_2_DT16(DT* in, DT16* out)
{
    for(int m = 0; m < M; m++)
    {
        for (int k = 0; k < K*K; k++)
        {
            for (int n = 0; n < N; n++)
            {
                out[m*K*K + k].data[n] = in[(m*N+n)*K*K + k];
            }
        }
    }
}

int main()
{
	DT* ifm=(DT*)sds_alloc(N*R*C*sizeof(DT));
	DT16* ifm_DT16=(DT16*)sds_alloc(N*R*C*sizeof(DT));

	DT* ofm_sw=(DT*)sds_alloc(M*R*C*sizeof(DT));

	DT* ofm_hw=(DT*)sds_alloc(M*R*C*sizeof(DT));
	DT16* ofm_hw_DT16=(DT16*)sds_alloc(M*R*C*sizeof(DT));

	DT* wgt   =(DT*)sds_alloc(N*M*K*K*sizeof(DT));
	DT16* wgt_DT16   =(DT16*)sds_alloc(N*M*K*K*sizeof(DT));

	timeval start,end;

	layer l;
	l.ic = 16;
	l.ih = 56;
	l.iw = 56;
	l.oc = 16;
	l.oh = 56;
	l.ow = 56;
	l.k = 3;
	l.s = 1;
	l.p = 1;

	printf("This is EE216\n");

	generate(ifm,wgt);
	gettimeofday(&start, NULL);
	convolution_sw(ifm,ofm_sw,wgt,l);
	gettimeofday(&end, NULL);
	printf("convolution_sw %lu us\n",(end.tv_sec-start.tv_sec)*1000000+(end.tv_usec-start.tv_usec));

	fm_DT_2_DT16(ifm,ifm_DT16);
	w_DT_2_DT16(wgt,wgt_DT16);
	gettimeofday(&start, NULL);
	convolution_hw(ifm_DT16,ofm_hw_DT16,wgt_DT16,l);
	gettimeofday(&end, NULL);
	printf("convolution_hw %lu us\n",(end.tv_sec-start.tv_sec)*1000000+(end.tv_usec-start.tv_usec));
	fm_DT16_2_DT(ofm_hw_DT16,ofm_hw);
	check(ofm_sw,ofm_hw);
	return 0;
}
