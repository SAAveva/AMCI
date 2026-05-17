#pragma once

typedef struct {
	float x;
	float y;
} Vec2;

typedef struct {
	float x;
	float y;
	float z;
} Vec3;

void vec2Init(Vec2 *, float, float);
void vec2Print(Vec2);

void vec3Init(Vec3 *, float, float, float);
void vec3Print(Vec3);


typedef struct {
	float start;
	float end;
} Axis;

typedef struct {
	Axis AxisX;
	Axis AxisY;
} Space;


void spaceInit(Space *, float, float, float, float);

void coordTransform(Vec2, Space *, Space *, Vec2 *);
