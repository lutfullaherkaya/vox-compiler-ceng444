#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # arg 2
  li a0, 0
  li a1, 2
            # call .tmp0, "f"
  call f
  sd a0, 0(sp)
  sd a1, 8(sp)
            # copy global_j, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, j_type
  sd t0, (t2)
  sd t1, 8(t2)
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun f(a);
f:
  addi sp, sp, -72
  sd ra, 64(sp)
            # param a
  sd a0, 0(sp)
  sd a1, 8(sp)
            # mul .tmp0, a, a
  ld a0, 0(sp)
  ld a1, 8(sp)
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_mul__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # arg .tmp0
  ld a0, 48(sp)
  ld a1, 56(sp)
            # call "__vox_print__"
  call __vox_print__
            # copy x, 5
  li t0, 0
  li t1, 5
  sd t0, 16(sp)
  sd t1, 24(sp)
            # copy y, "str"
  li t0, 3
  la t1, .L_string1
  sd t0, 32(sp)
  sd t1, 40(sp)
            # return 
  ld ra, 64(sp)
  addi sp, sp, 72
  ret

  .data
j_type:   .quad 0
j_value:  .quad 0

.L_string1:  .string "str"
