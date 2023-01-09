#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -32
  sd ra, 24(sp)
  sd fp, 16(sp)
  addi fp, sp, 32
            # arg asdf
  addi sp, sp, -48
  li a0, 3
  la a1, .L_string1
            # arg 1
  li a2, 0
  li a3, 1
            # arg 2
  li a4, 0
  li a5, 2
            # arg 3
  li a6, 0
  li a7, 3
            # arg 4
  li t0, 0
  li t1, 4
  sd t0, 0(sp)
  sd t1, 8(sp)
            # arg 5
  li t0, 0
  li t1, 5
  sd t0, 16(sp)
  sd t1, 24(sp)
            # arg 6
  li t0, 0
  li t1, 6
  sd t0, 32(sp)
  sd t1, 40(sp)
            # call .tmp0, coklu
  call coklu
  addi sp, sp, 48
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret

# fun coklu(a, b, c, d, e, f, g);
coklu:
  addi sp, sp, -128
  sd ra, 120(sp)
  sd fp, 112(sp)
  addi fp, sp, 128
            # param a
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param b
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param c
  sd a4, 32(sp)
  sd a5, 40(sp)
            # param d
  sd a6, 48(sp)
  sd a7, 56(sp)
            # param e
  ld t1, 128(sp)
  ld t2, 136(sp)
  sd t1, 64(sp)
  sd t2, 72(sp)
            # param f
  ld t1, 144(sp)
  ld t2, 152(sp)
  sd t1, 80(sp)
  sd t2, 88(sp)
            # param g
  ld t1, 160(sp)
  ld t2, 168(sp)
  sd t1, 96(sp)
  sd t2, 104(sp)
            # arg a
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # arg b
  ld a0, 16(sp)
  ld a1, 24(sp)
            # call __vox_print__
  call __vox_print__
            # arg c
  ld a0, 32(sp)
  ld a1, 40(sp)
            # call __vox_print__
  call __vox_print__
            # arg d
  ld a0, 48(sp)
  ld a1, 56(sp)
            # call __vox_print__
  call __vox_print__
            # arg e
  ld a0, 64(sp)
  ld a1, 72(sp)
            # call __vox_print__
  call __vox_print__
            # arg f
  ld a0, 80(sp)
  ld a1, 88(sp)
            # call __vox_print__
  call __vox_print__
            # arg g
  ld a0, 96(sp)
  ld a1, 104(sp)
            # call __vox_print__
  call __vox_print__
            # return 0
  li a0, 0
  li a1, 0
  ld ra, 120(sp)
  ld fp, 112(sp)
  addi sp, sp, 128
  ret

  .data
.L_string1:  .string "asdf"
