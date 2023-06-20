#include <iostream>
#include <cstdlib> 
#include <stdio.h>
#include <time.h>
#include "parameter.h"
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 2;
const int ThreadNum = 4;

__global__ void test(int *original, int **result)
{

    int TotalThread = blockDim.x * gridDim.x;
    int stripe = ARRAY_SIZE / TotalThread;
    int head = (blockIdx.x * blockDim.x + threadIdx.x) * stripe;
    int LoopLim = head + stripe;

    for(int i = head; i < LoopLim; i++)
    {
        int val_cpy = original[i];
        for(int bit = 0; bit < BYTE_SIZE; bit++)
        {
            result[i][bit] = val_cpy & 1;
            val_cpy = val_cpy >> 1;
        }
    }
}


int main()
{
    int **result;
    int **d_result;
   
	cudaMalloc((void**) &d_a,sizeof(int)*N);
	cudaMemcpy(d_a,a,sizeof(int)*N,cudaMemcpyHostToDevice);
	
    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    increment_gpu<<<dimGrid,dimBlock>>>(d_a,b,N);
	cudaDeviceSynchronize();
	
	cudaMemcpy(a,d_a,sizeof(int)*N,cudaMemcpyDeviceToHost);
	
	return 0;
}
