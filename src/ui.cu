#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <time.h>

#include "ui.h"
#include "image.h"
#include "mandelbrot.h"
#include "error.h"

void uiInfoTextUpdate(UIState *state) {
	SDL_Surface *text_surface	= TTF_RenderText_Blended(state->font, state->info_text, state->font_color);
	state->info_text_texture	= SDL_CreateTextureFromSurface(state->renderer, text_surface);
	state->info_text_rect.x		= 20;
	state->info_text_rect.y		= 20;
	state->info_text_rect.w		= text_surface->w;
	state->info_text_rect.h		= text_surface->h;

	SDL_FreeSurface(text_surface);
}

void uiInfoTextCleanup(UIState *state) {
}

ErrorState uiStateInit(UIState *state, const char *win_title, int width, int height) {
	state->win_size.x		= width;
	state->win_size.y		= height;
	strncpy(state->win_title, win_title, strlen(win_title));

	state->window			= NULL;
	state->renderer			= NULL;
	state->texture			= NULL;

	state->font				= NULL;
	state->font_color		= {255, 255, 255, 255};

	state->info_text_show	= true;
	bzero(state->info_text, INFO_TEXT_BUF_SIZE);

	cudaMallocManaged((void **)&state->mb, sizeof(MBConfig));

	cudaMallocManaged((void **)&state->mb->image, sizeof(ImageRGBA));
	imageRGBAInit(state->mb->image, width, height);

	state->mb->zoom			= 1;
	state->mb->zoom_factor		= .95;
	state->mb->translation.x	= 0;
	state->mb->translation.y	= 0;
	state->mb->translation_step	= 20;

	state->mb->cuda_block_N		= 1024;
	state->mb->cuda_grid_N		= width * height / state->mb->cuda_block_N + 1;

	state->running			= true;
	state->update_view		= true;

	double real_start		= -2;
	double real_end			= 1;
	double imag_start		= -2;
	double imag_end			= 2;

	cudaMallocManaged((void **)&state->mb->SPACE_A, sizeof(Space));
	cudaMallocManaged((void **)&state->mb->SPACE_B, sizeof(Space));

	spaceInit(&state->mb->SPACE_A, real_start, real_end, imag_start, imag_end);
	spaceInit(&state->mb->SPACE_B, 0, width, 0, height);

	return STATE_OK;
}

void uiInit(UIState *state) {
	SDL_Init(SDL_INIT_VIDEO);
	TTF_Init();

	state->font	= TTF_OpenFont(FONT_PATH, 32);

	if (state->font == NULL) {
		fprintf(stderr, "TTF_OpenFont Error: %s\n", TTF_GetError());
		return;
	}

	state->window = SDL_CreateWindow(
		state->win_title,
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		state->win_size.x,
		state->win_size.y,
		0
	);

	state->renderer = SDL_CreateRenderer(state->window, -1, SDL_RENDERER_ACCELERATED);
	state->texture	= SDL_CreateTexture(
		state->renderer,
		SDL_PIXELFORMAT_RGBA32,
		SDL_TEXTUREACCESS_STREAMING,
		state->win_size.x,
		state->win_size.y
	);
}

void uiDraw(UIState *state) {
}

void uiLoop(UIState *state) {
	SDL_Event event;

	while (state->running) {
		SDL_WaitEventTimeout(&event, 1);
		const Uint8 *key_states		= SDL_GetKeyboardState(NULL);
		SDL_Keymod mod_state		= SDL_GetModState();

		if (key_states[SDL_SCANCODE_Z] && (mod_state & KMOD_SHIFT) ) {
			state->mb->zoom /= state->mb->zoom_factor;
			state->update_view = 1;
		}
		else if (key_states[SDL_SCANCODE_Z]) {
			state->mb->zoom *= state->mb->zoom_factor;
			state->update_view = 1;
		}
		if (key_states[SDL_SCANCODE_UP]) {
			state->mb->translation.y -= state->mb->translation_step * state->mb->zoom;
			state->update_view = 1;
		}
		if (key_states[SDL_SCANCODE_RIGHT]) {
			state->mb->translation.x += state->mb->translation_step * state->mb->zoom;
			state->update_view = 1;
		}
		if (key_states[SDL_SCANCODE_LEFT]) {
			state->mb->translation.x -= state->mb->translation_step * state->mb->zoom;
			state->update_view = 1;
		}
		if (key_states[SDL_SCANCODE_DOWN]) {
			state->mb->translation.y += state->mb->translation_step * state->mb->zoom;
			state->update_view = 1;
		}

		if (event.type == SDL_QUIT) {
			state->running = 0;
		}

		if (event.type == SDL_WINDOWEVENT && 
			event.window.event == SDL_WINDOWEVENT_RESTORED
			|| event.window.event == SDL_WINDOWEVENT_FOCUS_GAINED) {
			state->update_view = 1;
		}
		if (event.type == SDL_KEYDOWN) {
			if (event.key.keysym.sym == SDLK_q) {
				state->running = 0;
			}
		}


		if (state->update_view) {
			struct timespec ts;
			timespec_get(&ts, TIME_UTC);
			printf("%ld. \r", ts.tv_nsec);
			fflush(stdout);

			mandelbrot(state->mb);

			SDL_UpdateTexture(
				state->texture, 
				NULL,
				state->mb->image->pixels, 
				state->mb->image->width * 4
			);

			SDL_RenderClear(state->renderer);
			SDL_RenderCopy(state->renderer, state->texture, NULL, NULL);

			if (state->info_text_show) {
				snprintf(
					state->info_text, 
					sizeof(state->info_text), 
					"Zoom: %.2e", state->mb->zoom
				);

				uiInfoTextUpdate(state);
				SDL_RenderCopy(state->renderer, state->info_text_texture, NULL, &state->info_text_rect);
			}

			SDL_RenderPresent(state->renderer);

			if (state->info_text_show) {
				uiInfoTextCleanup(state);
			}
			state->update_view = false;

		}
	}
}

void uiQuit(UIState *state) {
	SDL_DestroyTexture(state->info_text_texture);
	TTF_CloseFont(state->font);
	imageRGBAFree(state->mb->image);
	cudaFree(&state->mb->image);
	cudaFree(&state->mb->SPACE_A);
	cudaFree(&state->mb->SPACE_B);
	cudaFree(state->mb);

    SDL_DestroyTexture(state->texture);
    SDL_DestroyRenderer(state->renderer);
    SDL_DestroyWindow(state->window);
    SDL_Quit();
}
