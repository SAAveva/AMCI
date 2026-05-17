#include <SDL2/SDL.h>

#include "ui.h"
#include "image.h"

SDL_Window *window;
SDL_Renderer *renderer;
SDL_Texture *texture;

void UIInit(int width, int height) {
	SDL_Init(SDL_INIT_VIDEO);
	window = SDL_CreateWindow(
		"example",
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		width,
		height,
		0
	);

	renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	texture = SDL_CreateTexture(
		renderer,
		SDL_PIXELFORMAT_RGBA32,
		SDL_TEXTUREACCESS_STREAMING,
		width,
		height	
	);
}

void UIDraw(ImageRGBA *image) {
	SDL_UpdateTexture(texture, NULL, image->pixels, image->width * 4);
}

void UILoop() {
	SDL_Event event;
	int running = 1;
	while (running) {
		while (SDL_PollEvent(&event)) {
			if (event.type == SDL_QUIT) 
				running = 0;
			if (event.type == SDL_KEYDOWN && event.key.keysym.sym == SDLK_q)
				running = 0;
		}


		SDL_RenderClear(renderer);
		SDL_RenderCopy(renderer, texture, NULL, NULL);
		SDL_RenderPresent(renderer);

	}
}

void UIQuit() {
    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
