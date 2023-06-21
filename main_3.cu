#include <iostream>
#include <cstdlib> 
#include <stdio.h>
#include <time.h>
#include "parameter.h"
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 2;
const int ThreadNum = 8;

// change the way of getting target bit
__device__ int get_target_bit(int byteFlag, int whichBit)
{
    if (whichBit >= 0 && whichBit < 8)
        return (byteFlag & (1<<whichBit)) >> whichBit;
    else
        return 0;
}

__global__ void gpu_bit_plane(int *d_original, int*d_result)
{

    int idx = blockIdx.x*blockDim.x + threadIdx.x;
	int start_idx = int(idx / 8);
	int bit = idx % 8;
	// Idx 0~7 start from 0
	// Idx 8~15 start from 1
	for(int i = start_idx; i < ARRAY_SIZE; i+=2)
	{
		d_result[i * BYTE_SIZE + bit] = get_target_bit(d_original[i], bit);
	}
}

void generate_number(int *original)
{
    
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        original[i] = int(rand()% (1<<BYTE_SIZE) );
    }
}

void print_original(int* original)
{
	cout<<"Original = "<<endl;
    for(int i = 0; i < ARRAY_SIZE; i++)
        cout<<original[i]<<" ";
    cout<<endl;
}

void print_result1D(int* result)
{
	cout<<"Result = "<<endl;
	for(int i = 0; i < ARRAY_SIZE; i++)
	{
		cout<<"["<<i<<"] : ";
		int sum = 0;
		for(int bit = BYTE_SIZE - 1; bit >= 0; bit--)
		{
			cout<<result[ i * BYTE_SIZE + bit];
			sum += result[i * BYTE_SIZE + bit] << bit;
		}
		cout<<" = "<<sum<<endl;
	}
	cout<<endl;
}

bool validate(int *original, int *result)
{
    // check the result before and after bit plane
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        int sum = 0;
        for(int bit = 0; bit < BYTE_SIZE; bit++)
        {
            sum += result[i * BYTE_SIZE + bit] << bit;
        }
        if(original[i] != sum)
		{
			cout<<"["<<i<<"]"<<" is incorrect!"<<endl;
			return false;
		}
    }
    return true;
}

int main()
{
    int *original =  (int*)calloc(ARRAY_SIZE, sizeof(int));
	int *d_original = 0;
	int *result  = (int*)calloc(BYTE_SIZE*ARRAY_SIZE, sizeof(int));
	int *d_result = 0;

	generate_number(original);

	// init data
    cout<<endl<<"Init finished"<<endl;
    cout<<"Array size is "<<ARRAY_SIZE<<endl;

	clock_t tStart = clock();
	
	cudaMalloc((void**) &d_original, sizeof(int)*ARRAY_SIZE);
	cudaMemcpy(d_original, original, sizeof(int)*ARRAY_SIZE, cudaMemcpyHostToDevice);
	cudaMalloc((void**) &d_result, sizeof(int)*ARRAY_SIZE*BYTE_SIZE);
	cudaMemcpy(d_result, result, sizeof(int)*ARRAY_SIZE*BYTE_SIZE, cudaMemcpyHostToDevice);
	
    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    gpu_bit_plane<<<dimGrid,dimBlock>>>(d_original, d_result);
	cudaDeviceSynchronize();
	
	cudaMemcpy(result, d_result,sizeof(int)*ARRAY_SIZE*BYTE_SIZE,cudaMemcpyDeviceToHost);

	printf("Time taken: %.8fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);
	
	print_original(original);
	print_result1D(result);

	cout<<"Compare result is ";
    if(validate(original, result))
        cout<<"correct"<<endl;
    else
        cout<<"incorrect"<<endl;

	return 0;
}
