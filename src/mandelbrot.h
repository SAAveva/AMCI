#pragma once

#include "vmath.h"
#include "image.h"

typedef struct {
	short r;
	short g;
	short b;
	short a;
} Color;

typedef struct {
	ImageRGBA		*image;

	double			zoom;
	double			zoom_factor;
	Vec2			translation;
	double			translation_step;

	Space			SPACE_A;
	Space			SPACE_B;

	unsigned short	cuda_block_N;
	unsigned short	cuda_grid_N;
} MBConfig;

void rgbToHsl(double r, double g, double b, double *h, double *s, double *l);
void hslToRgb(double h, double s, double l, double *r, double *g, double *b);
void createPalette(Color, int, Color *);

__device__ int divergance(Vec2D, double);
__global__ void colorPoint(MBConfig *);

void mandelbrot(MBConfig *);
