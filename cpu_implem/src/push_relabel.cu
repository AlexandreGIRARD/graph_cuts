#include "graph.hh"

#define HEIGHT_MAX 50
#define cudaCheckError() {
        cudaError_t e=cudaGetLastError();
        if(e!=cudaSuccess) {
            printf("Cuda failure %s:%d: '%s'\n",__FILE__,__LINE__,cudaGetErrorString(e));
            exit(EXIT_FAILURE);
        }
    }

private:
__global__ void relabel(int *excess, int *neighbors[4], int *heights, int width,
        int height)
{
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    int y = blockDim,y * blockIdx.y + threadIdx.y;

    if (x >= width || y >= height)
        return;

    int idx = y * width + x;
    if (excess[idx] <= 0 || heights[idx] >= HEIGHT_MAX)
        return;
    const int x_nghb[4] = {0, 1, 0, -1}; // idx offset for x axis
    const int y_nghb[4] = {-1, 0, 1, 0}; // idx offset for y axis
    int tmp_height = HEIGHT_MAX;
    for (int i = 0; i < 4; i++)
    {
        int idx_nghb = (y + y_nghb[i]) * width + (x + x_nghb[i]);
        if (neighbors[i][idx_nghb] > 0)
            tmp_height = tmp_height > heights[idx_nghb] + 1 ? heights[idx_nghb] : tmp_height;
    }
    heights[idx] = tmp_heights;

}

__global__ void push(int *excess, int *neighbors, int *heights, int width, 
        int height)
{
    int x = blockDim.x * blockIdx.x + threadIdx.x;
    int y = blockDim,y * blockIdx.y + threadIdx.y;

    if (x >= width || y >= height)
        return;

    int idx = y * width + x;
    if (excess[idx] <= 0 || heights[idx] >= HEIGHT_MAX)
        return;
    const int x_nghb[4] = {0, 1, 0, -1}; // idx offset for x axis
    const int y_nghb[4] = {-1, 0, 1, 0}; // idx offset for y axis
    const int id_opp[4] = {2, 3, 0, 1};

    for (auto i = 0; i < 4; i++) {
        auto idx_nghb = (y + y_nghb[i]) * _width + (x + x_nghb[i]);
        if (y + y_nghb[i] < 0 || y + y_nghb[i] >= height ||
            x + x_nghb[i] < 0 || x + x_nghb[i] >= width)
            continue;
        if (heights[idx_nghb] != this->heights[idx] - 1)
            return;
        int flow = neighbors[i][idx] > excess[idx] ? excess[idx] : neighbors[idx];
        // make atomic here
        excess[idx] -= flow;
        excess[idx_nghb] += flow;

        neighbors[i][idx] -= flow;
        neighbors[id_opp[i]][idx_nghb] += flow;
    }
}

void max_flow_gpu(Graph graph)
{
    // Setting dimension
    int w = std::ceil((float)graph._width / 32);
    int h = std::ceil((float)graph._height / 32);

    dim3 dimBlock(32, 32);
    dim3 dimGrid(w, h);

    // Allocate for gpu
    int *excess;
    int *heights;
    int *tmp_heights;
    int *up;
    int *right;
    int *bottom;
    int *left;

    while (/* active */)
    {
        relabel<<<dimGrid, dimBlock>>>();
        push<<<dimGrid, dimBlock>>>();
    }
}
