nvcc -c test.cu -arch=sm_20
g++ -o test_gpu test.o `OcelotConfig -l`
./test_gpu
