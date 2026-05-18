#include <math.h>

#include "vmath.h"
#include "image.h"
#include "mandelbrot.h"

__device__ bool check_periodicity(double x, double y) {
    double q = (x - 0.25) * (x - 0.25) + y * y;
    if (q * (q + (x - 0.25)) < 0.25 * y * y) {
        return true;
    }
    if ((x + 1.0) * (x + 1.0) + y * y < 0.0625) {
        return true; 
    }
    return false;
}

__device__ int divergance(Vec2D point, double *mag_sq) {
	if (check_periodicity(point.x, point.y)) {
		return -1;
	}

    int max_iter = 1000;
    Vec2D z;
    z.x = 0;
    z.y = 0;

    for (int iter = 0; iter < max_iter; iter++) {
        COMPLEX_MUL(z, z, z);
        COMPLEX_ADD(z, point, z);
        
        COMPLEX_MAG(z, *mag_sq); 
        
        if (*mag_sq >= 65536) {
            return iter;
        }
    }
    return -1;
}

__global__ void colorPoint(MBConfig *config) {
	int global_idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (global_idx >= config->image->width * config->image->height)
		return;

	Vec2D p;
	p.x = global_idx % config->image->width * config->zoom + config->translation.x;
	p.y = global_idx / config->image->width * config->zoom + config->translation.y;

	Vec2D point;
	coordTransformD(p, &config->SPACE_B, &config->SPACE_A, &point);

	if (point.x > config->SPACE_A.AxisX.end || point.y > config->SPACE_A.AxisY.end)
		return;

	int idx = global_idx * 4;

	double mag;
	int div_amount	= divergance(point, &mag);

	if (div_amount >= 0) {
		double smooth_i = (double)div_amount - 0.5 * log2(log2(mag)) + 1.0;
		if (smooth_i < 0) smooth_i = 0;

		if (smooth_i < 0.0 || isnan(smooth_i)) {
			smooth_i = 0.0;
		}
		double frequency = 0.005; 
		double t = smooth_i * frequency;

		unsigned char r = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.00))));
		unsigned char g = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.33))));
		unsigned char b = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.67))));

		config->image->pixels[idx]   = r;
		config->image->pixels[idx+1] = g;
		config->image->pixels[idx+2] = b;
		config->image->pixels[idx+3] = 0xff;
	}
	else {
		config->image->pixels[idx] = 0;
		config->image->pixels[idx+1] = 0;
		config->image->pixels[idx+2] = 0;
		config->image->pixels[idx+3] = 255;
	}
}

void mandelbrot(MBConfig *config) {
	colorPoint<<<config->cuda_grid_N, config->cuda_block_N>>>(config);
	cudaDeviceSynchronize();
}
