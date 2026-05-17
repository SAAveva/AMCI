#include <stdio.h>

#include "math.h"

void vec2Init(Vec2 *vec, float x, float y) {
	vec->x = x;
	vec->y = y;
}

void vec2Print(Vec2 vec) {
	printf("{ x: %f, y: %f }\n", vec.x, vec.y);
}

void vec3Init(Vec3 *vec, float x, float y, float z) {
	vec->x = x;
	vec->y = y;
	vec->z = z;
}

void vec3Print(Vec3 vec) {
	printf("{ x: %f, y: %f, z: %f }\n", vec.x, vec.y, vec.z);
}

void spaceInit(Space *space, float x_start, float x_end, float y_start, float y_end) {
	space->AxisX.start = x_start;
	space->AxisX.end = x_end;
	space->AxisY.start = y_start;
	space->AxisY.end = y_end;
}

void coordTransform(Vec2 point, Space *A, Space *B, Vec2 *result) {
	float A_sizex = A->AxisX.end - A->AxisX.start;
	float B_sizex = B->AxisX.end - B->AxisX.start;
	float coord_x = (point.x - A->AxisX.start) / A_sizex * B_sizex + B->AxisX.start;

	float A_sizey = A->AxisY.end - A->AxisY.start;
	float B_sizey = B->AxisY.end - B->AxisY.start;
	float coord_y = (point.y - A->AxisY.start) / A_sizey * B_sizey + B->AxisY.start;

	result->x = coord_x;
	result->y = coord_y;
}
