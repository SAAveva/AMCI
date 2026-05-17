#include <stdio.h>

#include "vmath.h"

void vec2Init(Vec2 *vec, double x, double y) {
	vec->x = x;
	vec->y = y;
}

void vec2Print(Vec2 vec) {
	printf("{ x: %f, y: %f }\n", vec.x, vec.y);
}

void vec3Init(Vec3 *vec, double x, double y, double z) {
	vec->x = x;
	vec->y = y;
	vec->z = z;
}

void vec3Print(Vec3 vec) {
	printf("{ x: %f, y: %f, z: %f }\n", vec.x, vec.y, vec.z);
}

__device__ __host__ void spaceInit(Space *space, double x_start, double x_end, double y_start, double y_end) {
	space->AxisX.start = x_start;
	space->AxisX.end = x_end;
	space->AxisY.start = y_start;
	space->AxisY.end = y_end;
}

__device__ __host__ void coordTransform(Vec2 point, Space *A, Space *B, Vec2 *result) {
	double A_sizex = A->AxisX.end - A->AxisX.start;
	double B_sizex = B->AxisX.end - B->AxisX.start;
	double coord_x = (point.x - A->AxisX.start) / A_sizex * B_sizex + B->AxisX.start;

	double A_sizey = A->AxisY.end - A->AxisY.start;
	double B_sizey = B->AxisY.end - B->AxisY.start;
	double coord_y = (point.y - A->AxisY.start) / A_sizey * B_sizey + B->AxisY.start;

	result->x = coord_x;
	result->y = coord_y;
}


__device__ __host__ void coordTransformD(Vec2D point, Space *A, Space *B, Vec2D *result) {
	double A_sizex = A->AxisX.end - A->AxisX.start;
	double B_sizex = B->AxisX.end - B->AxisX.start;
	double coord_x = (point.x - A->AxisX.start) / A_sizex * B_sizex + B->AxisX.start;

	double A_sizey = A->AxisY.end - A->AxisY.start;
	double B_sizey = B->AxisY.end - B->AxisY.start;
	double coord_y = (point.y - A->AxisY.start) / A_sizey * B_sizey + B->AxisY.start;

	result->x = coord_x;
	result->y = coord_y;
}

