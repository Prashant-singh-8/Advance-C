# ASCII Farming Simulator - build with:  make   (then run ./farm)
CC      ?= cc
CFLAGS  ?= -std=c99 -O2 -Wall -Wextra -pedantic
CFLAGS  += -D_POSIX_C_SOURCE=200809L
SRC      = $(wildcard src/*.c)
OBJ      = $(SRC:src/%.c=build/%.o)

farm: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)

build/%.o: src/%.c $(wildcard src/*.h) | build
	$(CC) $(CFLAGS) -c $< -o $@

build:
	mkdir -p build

run: farm
	./farm

clean:
	rm -rf build farm

.PHONY: run clean
