#include <strings.h>
#include <stdlib.h>

#include "array.h"
#include "math.h"

void arrayFloatInit(ArrayFloat *array, int width, int height) {
	array->width = width;
	array->height = height;
	array->points = (float *)malloc(width * height * sizeof(float));
	bzero(array->points, width * height);
}

int arrayGetIndex(Vec2 point, int width) {
	return point.y * width + point.x;
}
