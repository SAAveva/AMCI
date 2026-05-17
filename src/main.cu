#include <unistd.h>
#include <SDL2/SDL.h>

#include "array.h"
#include "image.h"
#include "vmath.h"
#include "ui.h"
#include "mandelbrot.h"

int main() {
	const int width		= 1200;
	const int height	= 1200;
	const char *title	= "Mandelbrot";

	UIState app_state;
	uiStateInit(&app_state, title, width, height);

	uiInit(&app_state);

	uiLoop(&app_state);

	uiQuit(&app_state);

	return 0;
}
