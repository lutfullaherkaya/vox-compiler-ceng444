CC = riscv64-unknown-linux-gnu-gcc
CFLAGS = -march=rv64gcv -static

all: hello_1 hello_2 hello_3 hello_4 hello_5 vector_test

hello_1: hello_1.s
	${CC} ${CFLAGS} hello_1.s -o hello_1
hello_2: hello_2.s
	${CC} ${CFLAGS} hello_2.s -o hello_2
hello_3: hello_3.s
	${CC} ${CFLAGS} hello_3.s -o hello_3
hello_4: hello_4.s
	${CC} ${CFLAGS} hello_4.s -o hello_4
hello_5: hello_5.s hello_helpers.c
	${CC} ${CFLAGS} hello_5.s hello_helpers.c -o hello_5
vector_test: vector_long_sum.s vector_test.c
	${CC} ${CFLAGS} vector_long_sum.s vector_test.c -o vector_test

.PHONY: clean
clean:
	rm -f hello_1 hello_2 hello_3 hello_4 hello_5 vector_test
