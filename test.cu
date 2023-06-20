#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 4;
const int ThreadNum = 4;
const int N = 4;
__global__ void MatAdd(int *A)
{
   int i = threadIdx.x;
   int j = threadIdx.y;
   printf("A[%d][%d]=%d\n", i, j, A[i * N + j]));
}


int main()
{
	int **a = (int **) malloc (N * sizeof(int *));
	for(int i=0; i < N;i++) 
		a[i]= (int *) malloc (N * sizeof(int));
	int *c_a;
	for (int i = 0; i < N; i++) 
		for(int j = 0; j < N; j++) 
			a[i][j] = 1;
	cudaMalloc((void **)&c_a, N * sizeof(int) * N);
	cudaMemcpy(c_a, a, N * sizeof(int) * N, cudaMemcpyHostToDevice);

    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    MatAdd<<<dimGrid,dimBlock>>>(c_a);

	return 0;
}
