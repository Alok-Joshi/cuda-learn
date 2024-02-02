#include <iostream>
#include <unistd.h>
using namespace std;

__global__ void add(int *A, int *B, int *C){
	int index = threadIdx.x;
 	C[index] = A[index] + B[index];
}


void print_vector(int *vec, int N){

	for(int i = 0; i<N; i++){
		cout<<vec[i]<<" ";
	}
	cout<<endl;
}

int main(){

	int const N = 3;
	int A_host[] = {1,2,3};
	int B_host[] = {1,2,3};
	int C_host[] = {0,0,0};

	int *A_device, *B_device, *C_device;

	cudaMalloc(&A_device, N*sizeof(int));
	cudaMalloc(&B_device, N*sizeof(int));
	cudaMalloc(&C_device, N*sizeof(int));

	cudaMemcpy(A_device, A_host, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(B_device, B_host, N*sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(C_device, C_host, N*sizeof(int), cudaMemcpyHostToDevice);

	print_vector(C_host,N);
	add<<<1,N>>>(A_device,B_device,C_device);
	cudaMemcpy(C_host, C_device, N*sizeof(int), cudaMemcpyDeviceToHost);
	print_vector(C_host,N);

}
