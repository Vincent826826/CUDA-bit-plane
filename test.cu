#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
using namespace std;

const int BlockSize = 1;
const int ThreadNum = 3;
const int ARRAY_SIZE = 3;

__global__ void test(int *d_oringinal, int*d_result)
{
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    for(int i = 0; i < 8; i++)
	{
		d_result[8*idx + i] = d_oringinal[idx] + i;
	}

}

int main()
{
    int oringinal[ARRAY_SIZE] = {10, 20, 30};
	int *d_oringinal = 0;
	int *result  = (int*)calloc(8*ARRAY_SIZE, sizeof(int));
	int *d_result = 0;
	int i;
	
	cout << "a[N] array before scaling: [";
	for(i=0;i<ARRAY_SIZE;i++)
	{
		cout << oringinal[i] << " ";
	}
	cout << "]" << endl;
	
	cudaMalloc((void**) &d_oringinal, sizeof(int)*ARRAY_SIZE);
	cudaMemcpy(d_oringinal, oringinal, sizeof(int)*ARRAY_SIZE, cudaMemcpyHostToDevice);
	cudaMalloc((void**) &d_result, sizeof(int)*ARRAY_SIZE*8);
	cudaMemcpy(d_result, result, sizeof(int)*ARRAY_SIZE*8, cudaMemcpyHostToDevice);
	
    dim3 dimBlock(BlockSize);
    dim3 dimGrid(ThreadNum);
    test<<<dimGrid,dimBlock>>>(d_oringinal, d_result);
	cudaDeviceSynchronize();
	
	cudaMemcpy(result, d_result,sizeof(int)*ARRAY_SIZE*8,cudaMemcpyDeviceToHost);
	
	cout << "Result[N] array after scaling:"<<endl; 
    cout<<"[";
	for(i=0; i<ARRAY_SIZE; i++)
	{
		for(int j = 0; j < 8; j ++)
		{
			cout << result[8*i + j]<<",";
		}
        
	}
	cout << "]" << endl;
	
	return 0;
}
