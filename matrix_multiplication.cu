#include <iostream>
#include <unistd.h>

using namespace std;

__global__ void mat_mult(int *A, int *B, int *C,  int rowSize){

    int i = threadIdx.x;
    int j = threadIdx.y;

    int index = j + i*rowSize;

    for(int  k = 0; k<rowSize; k++){

        /* C[i][j] = A[i][k] * B[k][j]; */
        int a_index = i + k*rowSize;
        int b_index = k + j*rowSize;
        C[index] += B[b_index]*A[a_index];
    }

}

void print_matrix(int *mat, int N, int M){

    for(int i = 0; i<N; i++){
        for(int j = 0; j<M; j++){
            int index = j + i*M;
            cout<<mat[index]<<" ";
        }
        cout<<endl;
    }
    cout<<endl;

}
int main(){

    int N = 3;
    int M = 3;
    int bytes = M*N*sizeof(int);
    int h_a[N][M] = { {1,2,3}, {1,2,3}, {1,2,3} };
    int h_b[N][M] = { {1,2,3}, {1,2,3}, {1,2,3} };
    int h_c[N][M] =  {0,0,0,0,0,0,0,0,0};


    //memory operations
    int *d_a,*d_b,*d_c;
    cudaMalloc((void**) &d_a, bytes);
    cudaMalloc((void**) &d_b, bytes);
    cudaMalloc((void**) &d_c, bytes);
    cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_c, h_c, bytes,cudaMemcpyHostToDevice);

    //kernel launch
    dim3 grids(1);
    dim3 threads(N, M);
    print_matrix((int*) h_c, N, M);
    mat_mult<<<grids, threads>>>(d_a, d_b, d_c,N);
    cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);
    print_matrix((int*) h_c, N, M);

}
