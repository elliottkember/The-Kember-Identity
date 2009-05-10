#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <cuda_runtime_api.h>
#include "cutil.h"

int deviceQuery() 
{
	int deviceCount;
	cudaGetDeviceCount(&deviceCount);
	if (deviceCount == 0)
		printf("There is no device supporting CUDA\n");
	int dev;
	for (dev = 0; dev < deviceCount; ++dev) {
		cudaDeviceProp deviceProp;
		cudaGetDeviceProperties(&deviceProp, dev);
		if (dev == 0) {
			if (deviceProp.major < 1)
				printf("There is no device supporting CUDA.\n");
			else if (deviceCount == 1)
				printf("There is 1 device supporting CUDA\n");
			else
				printf("There are %d devices supporting CUDA\n", deviceCount);
		}
		printf("\nDevice %d: \"%s\"\n", dev, deviceProp.name);
		printf("  Major revision number:                         %d\n",
			   deviceProp.major);
		printf("  Minor revision number:                         %d\n",
			   deviceProp.minor);
		printf("  Total amount of global memory:                 %d bytes\n",
			   deviceProp.totalGlobalMem);
		printf("  Total amount of constant memory:               %d bytes\n",
			   deviceProp.totalConstMem); 
		printf("  Total amount of shared memory per block:       %d bytes\n",
			   deviceProp.sharedMemPerBlock);
		printf("  Total number of registers available per block: %d\n",
			   deviceProp.regsPerBlock);
		printf("  Warp size:                                     %d\n",
			   deviceProp.warpSize);
		printf("  Maximum number of threads per block:           %d\n",
			   deviceProp.maxThreadsPerBlock);
		printf("  Maximum sizes of each dimension of a block:    %d x %d x %d\n",
			   deviceProp.maxThreadsDim[0],
			   deviceProp.maxThreadsDim[1],
			   deviceProp.maxThreadsDim[2]);
		printf("  Maximum sizes of each dimension of a grid:     %d x %d x %d\n",
			   deviceProp.maxGridSize[0],
			   deviceProp.maxGridSize[1],
			   deviceProp.maxGridSize[2]);
		printf("  Maximum memory pitch:                          %d bytes\n",
			   deviceProp.memPitch);
		printf("  Texture alignment:                             %d bytes\n",
			   deviceProp.textureAlignment);
		printf("  Clock rate:                                    %d kilohertz\n",
			   deviceProp.clockRate);
	}
	printf("\nTest PASSED\n");
	return 0;
}
