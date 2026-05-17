#pragma once

#include <cuda_runtime.h>

typedef struct {
	int width;
	int height;
	float *points;
} ArrayFloat;
	
void arrayFloatInit(ArrayFloat *, int, int);
__device__  __host__ int arrayGetIndex(int, int, int);
