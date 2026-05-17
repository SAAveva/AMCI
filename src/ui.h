#pragma once

#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <stdbool.h>

#include "image.h"
#include "vmath.h"
#include "error.h"
#include "mandelbrot.h"

#define INFO_TEXT_BUF_SIZE 256
#define FONT_PATH "/usr/share/fonts/truetype/msttcorefonts/arial.ttf"

typedef struct {
	Vec2			win_size;
	char			win_title[256];
	SDL_Window*		window;
	SDL_Renderer*	renderer;
	SDL_Texture*	texture;

	TTF_Font*		font;
	SDL_Color		font_color;
	unsigned int	font_size;

	bool			info_text_show;
	char			info_text[INFO_TEXT_BUF_SIZE];
	SDL_Texture*	info_text_texture;
	SDL_Rect		info_text_rect;

	bool			running;
	bool			update_view;

	MBConfig		*mb;

} UIState;

ErrorState uiStateInit(UIState *, const char *, int, int);
void uiInit(UIState *);
void uiDraw(UIState *);
void uiLoop(UIState *);
void uiQuit(UIState *);
