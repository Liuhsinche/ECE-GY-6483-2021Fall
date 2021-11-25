#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
#include <cstring>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>


//#include "sds_lib.h"
#define sds_alloc malloc
#define sds_free free

typedef float DT;

#define N 16
#define M 16
#define OR 56
#define OC 56
#define IR 56
#define IC 56
#define R 56
#define C 56
#define K 3
#define S 1
#define P 1


struct layer
{
	int name;
	int iw, ih, ic, ow, oh, oc;
	int k, s, p;
};

struct DT16
{
	DT data[16];
};

void convolution_sw(DT *ifm, DT *ofm, DT *weight, layer l);

#pragma SDS data zero_copy(in[0:"l.ic*l.iw*l.ih/16"],out[0:"l.oc*l.ow*l.oh/16"],weight[0:"l.oc*l.ic*l.k*l.k/16"])
#pragma SDS data access_pattern(in:SEQUENTIAL, out:SEQUENTIAL, weight:SEQUENTIAL)
void convolution_hw(DT16* in, DT16* out, DT16* weight, layer l);
