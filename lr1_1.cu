//Вариант 20.	Задать 1024 числа и выдать чётное/ нечётное
#include "stdio.h"

__global__ void kernel(int n, int* array_odd, int* array_even) 
{
    long long i = blockDim.x * blockIdx.x + threadIdx.x;
    long long offset = blockDim.x * gridDim.x;
    int c_even = 0;
    int c_odd = 0;
    for (; i < n; i += offset)
    {
        if (i % 2 == 0)
        {
            array_odd[c_odd] = i;
            c_odd++;
        }
        else
        {
            array_even[c_even] = i;
            c_even++;
        }
    }
}


int main() {
    float time;
    int n = 1024;
    int blocks = 1, threads = 2;

    int* c_array_odd = (int*)malloc(n/2 * sizeof(int));
    int* c_array_even = (int*)malloc(n/2 * sizeof(int));
    int* cu_array_odd;
    int* cu_array_even;
    cudaMalloc(&cu_array_odd, sizeof(int) * n/2);
    cudaMalloc(&cu_array_even, sizeof(int) * n/2);
    cudaMemcpy(cu_array_odd, c_array_odd, sizeof(int) * n/2, cudaMemcpyHostToDevice); // from CPU to GPU
    cudaMemcpy(cu_array_even, c_array_even, sizeof(int) * n/2, cudaMemcpyHostToDevice); // from CPU to GPU

    cudaEvent_t start, end;
    cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventRecord(start);

    kernel<<<blocks,threads>>>(n, cu_array_even, cu_array_odd);
    cudaEventRecord(end);
    cudaEventSynchronize(end);
    cudaEventElapsedTime(&time, start, end);
    cudaEventDestroy(start);
    cudaEventDestroy(end);
 
    printf("kernel = <<<%d, %d>>>, time = %f\n", blocks, threads, time);

    cudaMemcpy(c_array_odd, cu_array_odd, sizeof(int) * n/2, cudaMemcpyDeviceToHost); // From GPU to CPU
    cudaMemcpy(c_array_even, cu_array_even, sizeof(int) * n/2, cudaMemcpyDeviceToHost); // From GPU to CPU
    cudaFree(cu_array_odd);
    cudaFree(cu_array_even);

    printf("Even numbers:\n");
    for (int i = 0; i < n/2; i++) {
		printf("%d ", c_array_even[i]);
	}

    printf("\n Odd numbers:\n");
    for (int i = 0; i < n/2; i++) {
		printf("%d ", c_array_odd[i]);
	}
    printf("\n");


    free(c_array_odd);
    free(c_array_even);

    system ( "PAUSE" );
    return 0;
}