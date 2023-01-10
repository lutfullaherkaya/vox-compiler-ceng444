#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # arg 1
  li a0, 0
  li a1, 1
            # arg 2
  li a2, 0
  li a3, 2
            # arg 3
  li a4, 0
  li a5, 3
            # call .tmp0, f
  call f
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun f(x, y, z);
f:
  addi sp, sp, -80
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
  addi sp, sp, 80
  ret

# fun g(a, b, c);
g:
  addi sp, sp, -80
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
  addi sp, sp, 80
  ret
