#include <iostream>
#include <cstdlib> 
#include <stdio.h>
#include <time.h>
#include "parameter.h"
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 1;
const int ThreadNum = 3;

__global__ void gpu_bit_plane(int *d_oringinal, int*d_result)
{
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    for(int i = 0; i < BYTE_SIZE; i++)
	{
		d_result[BYTE_SIZE*idx + i] = d_oringinal[idx] + i;
	}

}

void generate_number(int *original)
{
    
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        original[i] = int(rand()% (1<<BYTE_SIZE) );
    }
}

int main()
{
    int *original =  (int*)calloc(ARRAY_SIZE, sizeof(int));
	int *d_oringinal = 0;
	int *result  = (int*)calloc(BYTE_SIZE*ARRAY_SIZE, sizeof(int));
	int *d_result = 0;

	generate_number(original);

	// init data
    cout<<endl<<"Init finished"<<endl;
    cout<<"Array size is "<<ARRAY_SIZE<<endl;

	clock_t tStart = clock();
	
	cudaMalloc((void**) &d_oringinal, sizeof(int)*ARRAY_SIZE);
	cudaMemcpy(d_oringinal, original, sizeof(int)*ARRAY_SIZE, cudaMemcpyHostToDevice);
	cudaMalloc((void**) &d_result, sizeof(int)*ARRAY_SIZE*BYTE_SIZE);
	cudaMemcpy(d_result, result, sizeof(int)*ARRAY_SIZE*BYTE_SIZE, cudaMemcpyHostToDevice);
	
    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    gpu_bit_plane<<<dimGrid,dimBlock>>>(d_oringinal, d_result);
	cudaDeviceSynchronize();
	
	cudaMemcpy(result, d_result,sizeof(int)*ARRAY_SIZE*BYTE_SIZE,cudaMemcpyDeviceToHost);
	
	printf("Time taken: %.8fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
	
	return 0;
}
