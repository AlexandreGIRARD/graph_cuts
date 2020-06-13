# Graph Cut with CUDA

This is my project for my CUDA courses.

It's purpose was to implement the max-flow/min-cut algorithm known as Push-Relabel in order to segment images.

It's implemented in CXX17 and CUDA.

The program take two images in order to work:
- The main image to segment
- The seed image with background (red) and foreground (blue) labels

![Result images](result.jpg?raw=true "Title")

## Installation
Clone the repository
```shell
git clone git@github.com:AlexandreGIRARD/graph_cuts.git
cd graph_cuts
mkdir build
cd build
cmake ..
```

## Usage
The images should be at **.jpg** format.
```shell
./graph_cut [-cg] <img> <seeds_img>
```
`-c` for CPU  `-g` for GPU
## Benchmark
The benchmarcking is made with [Google Benchmark](https://github.com/google/benchmark)
```shell
./bench
```
## Testsuite
The testsuite compare the results obtained with the the ground truth given by my teacher. It used the mean dice score over the 15 given images in `segmentation_dataset`.

Actually the mean dice score over the 15 images is 0.91 using the GPU implementation
```shell
make test
```
