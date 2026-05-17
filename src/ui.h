#pragma once

#include <SDL2/SDL.h>

#include "image.h"

void UIInit(int, int);
void UIDraw(ImageRGBA *);
void UILoop(void);
void UIQuit(void);
