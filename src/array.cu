#include <strings.h>
#include <stdlib.h>

#include "array.h"

void arrayFloatInit(ArrayFloat *array, int width, int height) {
	array->width = width;
	array->height = height;
	array->points = (float *)malloc(width * height * sizeof(float) * 4);
	bzero(array->points, width * height);
}

__device__ __host__ int arrayGetIndex(int row, int column, int width) {
	return column * width + row;
}
