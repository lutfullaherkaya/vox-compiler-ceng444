#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -72
  sd ra, 64(sp)
            # arg 1
  li a0, 0
  li a1, 1
            # arg 2
  li a2, 0
  li a3, 2
            # arg 3
  li a4, 0
  li a5, 3
            # call .tmp0, g
  call g
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg 1
  li a0, 0
  li a1, 1
            # arg 2
  li a2, 0
  li a3, 2
            # arg 3
  li a4, 0
  li a5, 3
            # call .tmp1, g
  call g
  sd a0, 16(sp)
  sd a1, 24(sp)
            # arg 1
  li a0, 0
  li a1, 1
            # arg 2
  li a2, 0
  li a3, 2
            # arg 3
  li a4, 0
  li a5, 3
            # call .tmp2, g
  call g
  sd a0, 32(sp)
  sd a1, 40(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg .tmp1
  ld a2, 16(sp)
  ld a3, 24(sp)
            # arg .tmp2
  ld a4, 32(sp)
  ld a5, 40(sp)
            # call .tmp3, f
  call f
  sd a0, 48(sp)
  sd a1, 56(sp)
            # arg .tmp3
  ld a0, 48(sp)
  ld a1, 56(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 64(sp)
  addi sp, sp, 72
  li a0, 0
  ret

# fun f(x, y, z);
f:
  addi sp, sp, -88
  sd ra, 80(sp)
            # param x
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param y
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param z
  sd a4, 32(sp)
  sd a5, 40(sp)
            # add .tmp1, x, y
  ld a0, 0(sp)
  ld a1, 8(sp)
  ld a2, 16(sp)
  ld a3, 24(sp)
  call __vox_add__
  sd a0, 64(sp)
  sd a1, 72(sp)
            # add .tmp0, .tmp1, z
  ld a0, 64(sp)
  ld a1, 72(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  call __vox_add__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # return .tmp0
  ld a0, 48(sp)
  ld a1, 56(sp)
  ld ra, 80(sp)
  addi sp, sp, 88
  ret

# fun g(a, b, c);
g:
  addi sp, sp, -88
  sd ra, 80(sp)
            # param a
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param b
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param c
  sd a4, 32(sp)
  sd a5, 40(sp)
            # mul .tmp1, a, b
  ld a0, 0(sp)
  ld a1, 8(sp)
  ld a2, 16(sp)
  ld a3, 24(sp)
  call __vox_mul__
  sd a0, 64(sp)
  sd a1, 72(sp)
            # mul .tmp0, .tmp1, c
  ld a0, 64(sp)
  ld a1, 72(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  call __vox_mul__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # return .tmp0
  ld a0, 48(sp)
  ld a1, 56(sp)
  ld ra, 80(sp)
  addi sp, sp, 88
  ret
