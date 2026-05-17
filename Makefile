CC = /usr/local/cuda-13.0/bin/nvcc
FLAGS = -lSDL2

SRC = $(wildcard src/*.c)
OBJ = $(patsubst src/%.c, build/%.o, $(SRC))

build/%.o: src/%.c | build
	$(CC) -c $< -o $@

run: ./main
	./build/main

main: $(OBJ)
	$(CC) $(OBJ) -o build/main $(FLAGS)

build:
	mkdir -p build

clean:
	rm build -r

