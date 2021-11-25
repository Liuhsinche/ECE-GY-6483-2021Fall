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

int main()
{
	DT* ifm=(DT*)sds_alloc(N*R*C*sizeof(DT));

	DT* ofm_sw=(DT*)sds_alloc(M*R*C*sizeof(DT));

	DT* ofm_hw=(DT*)sds_alloc(M*R*C*sizeof(DT));

	DT* wgt   =(DT*)sds_alloc(N*M*K*K*sizeof(DT));

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


	gettimeofday(&start, NULL);
	convolution_hw(ifm,ofm_hw,wgt);
	gettimeofday(&end, NULL);
	printf("convolution_hw %lu us\n",(end.tv_sec-start.tv_sec)*1000000+(end.tv_usec-start.tv_usec));
	check(ofm_sw,ofm_hw);
	return 0;
}
