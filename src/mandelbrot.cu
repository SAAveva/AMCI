#include <stdio.h>
#include <math.h>

#include "vmath.h"
#include "image.h"
#include "mandelbrot.h"

__device__ int divergance(Vec2D point, double *mag_sq) {
    int max_iter = 10000;
    Vec2D z;
    z.x = 0;
    z.y = 0;

    for (int iter = 0; iter < max_iter; iter++) {
        COMPLEX_MUL(z, z, z);
        COMPLEX_ADD(z, point, z);
        
        // Assuming your macro does: *mag_sq = (z.x * z.x) + (z.y * z.y);
        COMPLEX_MAG(z, *mag_sq); 
        
        // 65536.0 is an escape radius of 256 (256 * 256 = 65536)
        if (*mag_sq >= 65536) {
            return iter; // Returns 0, 1, 2... up to 999
        }
    }
    return -1; // Point is trapped inside the set
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

		// 3. Ultra-smooth Cosine Palette Generation
		// Formula: Color = A + B * cos(2 * PI * (C * t + D))
		// This specific configuration gives an incredibly beautiful, bright neon psychedelic profile:
		unsigned char r = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.00))));
		unsigned char g = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.33))));
		unsigned char b = (unsigned char)(255.0 * (0.5 + 0.5 * cos(6.28318 * (1.0 * t + 0.67))));

		// 4. Write directly to your texture
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
