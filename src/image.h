#pragma once

#include <stdint.h>

#include "array.h"

typedef struct {
	int width;
	int height;
	uint8_t *pixels;
} ImageRGBA;

void imageRGBAInit(ImageRGBA *, int, int);
void imageRGBAFree(ImageRGBA *);
void imagePrintPixels(ImageRGBA *);
