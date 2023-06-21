nvcc -c main_3.cu -arch=sm_20
g++ -o main_gpu_3 main_3.o `OcelotConfig -l`
./main_gpu_3
