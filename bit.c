#include<stdio.h>
#include<stdlib.h>
void print_binary(int* arr, int val)
{
    
    for(int i  = 0; i < 8; i++)
    {
        printf("%d", val%2);
        arr[i] = val%2;
        val /= 2;

    }
    printf("\n");
}
int get_target_bit(int8_t byteFlag, int whichBit)
{
    if (whichBit > 0 && whichBit <= 8)
        return (byteFlag & (1<<(whichBit-1)));
    else
        return 0;
}
int main()
{

    printf("%d", (1<<8));
    return 0;
    int a = 215;
    int *result = calloc(8, sizeof(int));
    print_binary(result, a);

    for(int i = 0; i < 8; i++)
    {
        printf("%d",result[i]);
    }
    puts("");


    int sum = 0;
    for(int i = 0; i < 8; i++)
    {
        sum += result[i] << i;
    }
    printf("%d", sum);

}