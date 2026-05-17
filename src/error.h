#pragma once

enum ErrorState {
	STATE_OK,
	STATE_FAIL,
};

typedef struct {
	double value;
	ErrorState state;
} ResultDouble;


