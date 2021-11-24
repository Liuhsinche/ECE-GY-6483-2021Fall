#include <stdio.h>
#include <string.h>
#include "vadd.h"

void vadd(int *a, int *b, int *o, int size)
{
#pragma HLS INTERFACE m_axi depth=2048 port=a offset=slave
#pragma HLS INTERFACE m_axi depth=2048 port=b offset=slave
#pragma HLS INTERFACE m_axi depth=2048 port=o offset=slave
#pragma HLS INTERFACE s_axilite register port=size
#pragma HLS INTERFACE s_axilite register port=return

	int A[DATA_SIZE];
	int B[DATA_SIZE];
	int O[DATA_SIZE];
	for(int i = 0; i < size; i++)
	{
#pragma HLS PIPELINE
		A[i] = a[i];
	}
	for(int i = 0; i < size; i++)
	{
#pragma HLS PIPELINE
		B[i] = b[i];
	}
    vadd: for(int i = 0; i < size; i++) {
#pragma HLS PIPELINE
        O[i] = A[i] + B[i];
    }
	for(int i = 0; i < size; i++)
	{
#pragma HLS PIPELINE
		o[i] = O[i];
	}
}
