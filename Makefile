CC = /usr/local/cuda-13.0/bin/nvcc
FLAGS = -lSDL2 -lSDL2_ttf -lm -lcudadevrt
CFLAGS = -rdc=true

SRC = $(wildcard src/*.cu)
OBJ = $(patsubst src/%.cu, build/%.o, $(SRC))

build/%.o: src/%.cu | build
	$(CC) $(CFLAGS) -c $< -o $@

run: ./main
	./build/main

main: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o build/main $(FLAGS)

build:
	mkdir -p build

clean:
	rm build -r

