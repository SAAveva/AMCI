#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "image.h"
#include "array.h"
#include "vmath.h"

void imageRGBAInit(ImageRGBA *image, int width, int height) {
	image->width = width;
	image->height = height;
	cudaMallocManaged((void **)&image->pixels, width * height * 4);

	for (int i = 0;i < height;++i) {
		for (int j = 0;j < width;++j) {
			int idx = arrayGetIndex(j, i, width) * 4;
			image->pixels[idx] = 0;
			image->pixels[idx+1] = 0;
			image->pixels[idx+2] = 0;
			image->pixels[idx+3] = 255;
		}
	}
}

void imageRGBAFree(ImageRGBA *image) {
	cudaFree(image->pixels);
}

void imagePrintPixels(ImageRGBA *image) {
	for (int i = 0;i < image->width;++i) {
		for (int j = 0;j < image->height;++j) {
			printf("%d ", image->pixels[j + i * image->width]);
		}
		printf("\n");
	}
}
