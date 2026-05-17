#include <stdio.h>

#include "vmath.h"

void coordTransformTest() {
	/* Not a real test yet.. */
	Space A, B;
	spaceInit(&A, 0, 100, 0, 100);
	spaceInit(&B, -1, 1, -1, 1);

	Vec2 point, point_r, point_r2;
	point.x = 50;
	point.y = 75;

	coordTransform(point, &A, &B, &point_r);

	printf("Point: ");
	vec2Print(point);
	vec2Print(point_r);

	point.x = .5;
	point.y = .25;
	coordTransform(point, &B, &A, &point_r2);
	

	printf("Point: ");
	vec2Print(point);
	vec2Print(point_r2);
}
