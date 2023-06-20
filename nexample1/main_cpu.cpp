#include <iostream>
using namespace std;

const int N = 10;

void increment_cpu(int a[],const int b, const int N)
{
	for(int idx=0;idx<N;idx++)
		a[idx]=a[idx]+b;
}

int main()
{
    int a[N];
	int *d_a=0;
	const int b = 10;
	
	cout << "a[N] array before scaling: [";
	for(int i=0;i<N;i++)
	{
		a[i] = i;
		cout << a[i] << " ";
	}
	cout << "]" << endl;
	
	//********* Calculated by CPU ***********//
	increment_cpu(a,b,N);
	

	cout << "a[N] array after scaling: [";
	for(int i=0;i<N;i++)
	{
		cout << a[i] << " ";
	}
	cout << "]" << endl;
	
	return 0;
}
