#pragma once

#include "math.h"

typedef struct {
	int width;
	int height;
	float *points;
} ArrayFloat;
	
void arrayFloatInit(ArrayFloat *, int, int);
int arrayGetIndex(Vec2, int);
