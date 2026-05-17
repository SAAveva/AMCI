#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#include "image.h"

void imageRGBAInit(ImageRGBA *image, int width, int height) {
	image->width = width;
	image->height = height;
	image->pixels = (uint8_t *)malloc(width * height * 4);

	for (int i = 0;i < height;++i) {
		for (int j = 0;j < width;++j) {
			int idx = (i * width + j) * 4;
			image->pixels[idx] = 0;
			image->pixels[idx+1] = 0;
			image->pixels[idx+2] = 0;
			image->pixels[idx+3] = 255;
		}
	}
}

void imagePrintPixels(ImageRGBA *image) {
	for (int i = 0;i < image->width;++i) {
		for (int j = 0;j < image->height;++j) {
			printf("%d ", image->pixels[j + i * image->width]);
		}
		printf("\n");
	}
}

void copyArrayToImage(ArrayFloat *array, ImageRGBA *image) {
	Space A, B;
	spaceInit(&A, 0, array->width, 0, array->height);
	spaceInit(&B, 0, image->width, 0, image->height);

	for (int i = 0;i < image->height;++i) {
		for (int j = 0;j < image->width;++j) {
			Vec2 point, point_t;
			point.x = j;
			point.y = i;
			coordTransform(point, &B, &A, &point_t);
			int arr_idx = arrayGetIndex(point_t, array->width);
			if (array->points[arr_idx] == 1) {
				int idx = arrayGetIndex(point, image->width) * 4;
				image->pixels[idx] = 255;
				image->pixels[idx+1] = 255;
				image->pixels[idx+2] = 255;
				image->pixels[idx+3] = 255;
			}
		}
	}
}
