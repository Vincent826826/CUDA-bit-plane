nvcc -c main_4.cu -arch=sm_20
g++ -o main_gpu_4 main_4.o `OcelotConfig -l`
./main_gpu_4
