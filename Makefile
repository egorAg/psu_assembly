CC = gcc
CFLAGS = -Wall -Wextra -Werror

.PHONY: all clean

all: matrix

matrix: matrix.o
	$(CC) $(CFLAGS) -o matrix matrix.o

matrix.o: matrix.s
	$(CC) $(CFLAGS) -c matrix.s

clean:
	rm -f matrix matrix.o
