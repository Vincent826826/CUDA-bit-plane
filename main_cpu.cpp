#include <iostream>
#include <cstdlib> 
#include "parameter.h"
using namespace std;
void cpu_bit_plane(int *original, int **result)
{
    for(int i = 0; i < N; i++)
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
    
    for(int i = 0; i < N; i++)
    {
        original[i] = int(rand()% (1<<BYTE_SIZE) );
    }
}

bool validate(int *original, int **result)
{
    // check the result before and after bit plane
    for(int i = 0; i < N; i++)
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
    for(int i = 0; i < N; i++)
        cout<<original[i]<<" ";
    cout<<endl;
}
void print_result(int** result)
{
    for(int i = 0; i < N; i++)
    {
        for(int j = 7; j >= 0 ; j--)
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
    int *original =  (int*)calloc(N, sizeof(int));
    int **result = (int**)calloc(N, sizeof(int*));
    for(int i = 0; i < N; i++)
    {
        result[i] = (int*)calloc(BYTE_SIZE, sizeof(int));
    }

    generate_number(original);

    // init data
    cout<<endl<<"Init finished"<<endl;
    
    
    cpu_bit_plane(original, result);

    print_original(original);
    print_result(result);
    
    if(validate(original, result))
        cout<<"Correct"<<endl;
    else
        cout<<"Incorrect"<<endl;

    return 0;
}

