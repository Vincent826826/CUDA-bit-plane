#include <iostream>
#include <cstdlib>
#include <stdio.h> 
#include <time.h>
#include "parameter.h"
using namespace std;

// change the way of getting target bit
inline int get_target_bit(int byteFlag, int whichBit)
{
    if (whichBit >= 0 && whichBit < 8)
        return (byteFlag & (1<<whichBit)) >> whichBit;
    else
        return 0;
}
void cpu_bit_plane(int *original, int **result)
{
    for(int i = 0; i < ARRAY_SIZE; i++)
    {
        for(int bit = 0; bit < BYTE_SIZE; bit++)
        {
            result[i][bit] = get_target_bit(original[i], bit);
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
            cout<<result[i][j]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;
}
int main()
{
    int *original =  (int*)calloc(ARRAY_SIZE, sizeof(int));
    int **result = (int**)calloc(ARRAY_SIZE, sizeof(int*));
    for(int i = 0; i < N; i++)
    {
        result[i] = (int*)calloc(BYTE_SIZE, sizeof(int));
    }

    generate_number(original);

    // init data
    cout<<endl<<"Init finished"<<endl;
    cout<<"Array size is "<<ARRAY_SIZE<<endl;
    
    clock_t tStart = clock();
    
    cpu_bit_plane(original, result);

    printf("Time taken: %.8fs\n", (double)(clock() - tStart)/CLOCKS_PER_SEC);

    // print_original(original);
    // print_result(result);
    
    cout<<"Compare result is ";
    if(validate(original, result))
        cout<<"correct"<<endl;
    else
        cout<<"incorrect"<<endl;

    return 0;
}

