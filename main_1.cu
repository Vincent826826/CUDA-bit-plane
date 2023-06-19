#include <iostream>
#include <cstdlib> 
#include <stdio.h>
#include <time.h>
#include "parameter.h"
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 2;
const int ThreadNum = 5;
const int N = 10;

__global__ void increment_gpu(int a[],const int b, const int N)
{
    int idx = blockIdx.x*blockDim.x+threadIdx.x;
    if(idx<N)
         a[idx]=a[idx]+b;
}
__global__ void gpu_bit_plane(int *original, int **result)
{
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        int val_cpy = original[i];
        for(int bit = 0; bit < BYTE_SIZE; bit++)
        {
            result[i][bit] = val_cpy & 1;
            val_cpy = val_cpy >> 1;
        }
    }
}
void generate_number(int *original)
{
    
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        original[i] = int(rand()% (1<<BYTE_SIZE) );
    }
}

bool validate(int *original, int **result)
{
    // check the result before and after bit plane
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        int sum = 0;
        for(int bit = 0; bit < BYTE_SIZE; bit++)
        {
            sum += result[i][bit] << bit;
        }
        if(original[i] != sum)return false;
    }
    return true;
}
void print_original(int* original)
{
    for(int i = 0; i < ARRAY_SIZE; i++)
        cout<<original[i]<<" ";
    cout<<endl;
}
void print_result(int** result)
{
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        for(int j = BYTE_SIZE - 1; j >= 0 ; j--)
        {
            // little-endian represntation
            cout<<result[i][j];
        }
        cout<<endl;
    }
    cout<<endl;
}
int main()
{
    int *original =  (int*)calloc(ARRAY_SIZE, sizeof(int));
    int **result = (int**)calloc(ARRAY_SIZE, sizeof(int*));
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        result[i] = (int*)calloc(BYTE_SIZE, sizeof(int));
    }

    generate_number(original);
	
	int a[N];
	int *d_a = 0;
	int i = 0;
	const int b = 10;
	
	cout << "a[N] array before scaling: [";
	for(i=0;i<N;i++)
	{
		a[i] = i;
		cout << a[i] << " ";
	}
	cout << "]" << endl;
	
	cudaMalloc((void**) &d_a,sizeof(int)*N);
	cudaMemcpy(d_a,a,sizeof(int)*N,cudaMemcpyHostToDevice);
	
    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    increment_gpu<<<dimGrid,dimBlock>>>(d_a,b,N);
	cudaDeviceSynchronize();
	
	cudaMemcpy(a,d_a,sizeof(int)*N,cudaMemcpyDeviceToHost);
	
	cout << "a[N] array after scaling: [";
	for(i=0;i<N;i++)
	{
		cout << a[i] << " ";
	}
	cout << "]" << endl;
	
	return 0;
}
