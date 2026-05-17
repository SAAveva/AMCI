#include <unistd.h>
#include <SDL2/SDL.h>

#include "array.h"
#include "image.h"
#include "math.h"
#include "ui.h"

/*__global__ void vec3Add(Vec3 *A, Vec3 *B, Vec3 *C) {
	if (threadIdx.x == 0) {
		C->x = A->x + B->x;
		C->y = A->y + B->y; C->z = A->z + B->z;
	}
}*/


void drawArray(ArrayFloat *array) {
	float coords[] = {-.5, .5, .5, .5, .5, -.5, -.5, -.5};
	Space A, B;
	spaceInit(&A, -1, 1, -1, 1);
	spaceInit(&B, 0, (float)array->width, 0, (float)array->height);

	for (int i = 0;i < sizeof(coords)/sizeof(float);i += 2) {
		Vec2 point, point_t;
		point.x = coords[i];
		point.y = coords[i+1];

		coordTransform(point, &A, &B, &point_t);
		int idx = arrayGetIndex(point_t, array->width);
		array->points[idx] = 1;
	}
}

int main() {
	const int width = 800;
	const int height = 800;

	UIInit(width, height);
	ArrayFloat array;
	arrayFloatInit(&array, 1000, 1000);
	drawArray(&array);

	ImageRGBA image;
	imageRGBAInit(&image, width, height);

	copyArrayToImage(&array, &image);

	UIDraw(&image);

	UILoop();
	UIQuit();

	return 0;
}
void cuda(){

/*
	cudaError_t err;
	err = cudaMallocManaged(&A, sizeof(vec3));

	err = cudaMallocManaged(&B, sizeof(vec3));

	err = cudaMallocManaged(&C, sizeof(vec3));
*/ /*
	A = (Vec3 *)malloc(sizeof(vec3));
	B = (Vec3 *)malloc(sizeof(vec3));
	C = (Vec3 *)malloc(sizeof(vec3));

	vec3_new(A, 1, 2, 3);
	vec3_new(B, 1, 0, -4);
	vec3_new(C, 0, 0 , 0);

	vec3Add<<<1, 1>>>(A, B, C);
	cudaDeviceSynchronize();

	vecPrint(C);
*/
}
