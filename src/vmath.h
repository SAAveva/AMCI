#pragma once

#include <cuda_runtime.h>

typedef struct {
	double x;
	double y;
} Vec2;

typedef struct {
	double x;
	double y;
	double z;
} Vec3;

typedef struct {
	double x;
	double y;
} Vec2D;

void vec2Init(Vec2 *, double, double);
void vec2Print(Vec2);

void vec3Init(Vec3 *, double, double, double);
void vec3Print(Vec3);


typedef struct {
	double start;
	double end;
} Axis;

typedef struct {
	Axis AxisX;
	Axis AxisY;
} Space;


__device__ __host__ void spaceInit(Space *, double, double, double, double);

__device__ __host__ void coordTransform(Vec2, Space *, Space *, Vec2 *);

__device__ __host__ void coordTransformD(Vec2D point, Space *A, Space *B, Vec2D *result);

#define COMPLEX_MUL(A, B, R) {\
	double _real = A.x * B.x - A.y * B.y;\
	double _imag = A.x * B.y + A.y * B.x;\
	R.x = _real;\
	R.y = _imag;\
}

#define COMPLEX_ADD(A, B, R) {\
	R.x = A.x + B.x;\
	R.y = A.y + B.y;\
}

#define COMPLEX_MAG(N, M) {\
	M = N.x * N.x + N.y * N.y;\
}
