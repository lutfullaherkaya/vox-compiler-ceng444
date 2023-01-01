#!/usr/bin/env bash
./bracket.py ${1}
riscv64-unknown-linux-gnu-gcc -march=rv64gcv -static ${1%.br}.s lib_bracket.c lib_br_vector.s -o ${1%.br}
