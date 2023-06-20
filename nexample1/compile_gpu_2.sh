nvcc -c main_2.cu -arch=sm_20
g++ -o main_gpu_2 main_2.o `OcelotConfig -l`
./main_gpu_2
