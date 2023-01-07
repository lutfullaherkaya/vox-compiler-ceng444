#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -96
  sd ra, 88(sp)
  sd fp, 80(sp)
  addi fp, sp, 96
            # global b
            # vector_set global_b, 0, 1
  li t0, 0
  li t1, 1
  ld t2, b_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_b, 1, 2
  li t0, 0
  li t1, 2
  ld t2, b_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_b, 2, 3
  li t0, 0
  li t1, 3
  ld t2, b_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global c
            # vector_get .tmp0, global_b, 2
  ld t1, b_value
  addi t1, t1, 32
  ld t0, 0(t1)
  ld t1, 8(t1)
  sd t0, 0(sp)
  sd t1, 8(sp)
            # copy global_c, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, c_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global d
            # copy global_d, 123
  li t0, 0
  li t1, 123
  la t2, d_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg_count 3
            # arg 1, 0
  li a0, 0
  li a1, 1
            # arg False, 1
  li a2, 2
  li a3, 0
            # arg 0, 2
  li a4, 0
  li a5, 0
            # call .tmp1, f
  call f
  sd a0, 16(sp)
  sd a1, 24(sp)
            # arg_count 1
            # arg .tmp1, 0
  ld a0, 16(sp)
  ld a1, 24(sp)
            # call __vox_print__
  call __vox_print__
            # arg_count 2
            # arg 2, 0
  li a0, 0
  li a1, 2
            # arg 17, 1
  li a2, 0
  li a3, 17
            # call .tmp2, __vox_add__
  call __vox_add__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # vector_set global_b, 1, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  ld t2, b_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # arg_count 2
            # arg global_d, 0
  ld a0, d_type
  ld a1, d_value
            # arg 15, 1
  li a2, 0
  li a3, 15
            # call .tmp3, __vox_add__
  call __vox_add__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # copy global_d, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  la t2, d_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg_count 1
            # arg global_d, 0
  ld a0, d_type
  ld a1, d_value
            # call __vox_print__
  call __vox_print__
            # vector_get .tmp4, global_b, 1
  ld t1, b_value
  addi t1, t1, 16
  ld t0, 0(t1)
  ld t1, 8(t1)
  sd t0, 64(sp)
  sd t1, 72(sp)
            # arg_count 1
            # arg .tmp4, 0
  ld a0, 64(sp)
  ld a1, 72(sp)
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 88(sp)
  ld fp, 80(sp)
  addi sp, sp, 96
  ret

# fun f(a, b, c);
f:
  addi sp, sp, -64
  sd ra, 56(sp)
  sd fp, 48(sp)
  addi fp, sp, 64
            # param a, 0
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param b, 1
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param c, 2
  sd a4, 32(sp)
  sd a5, 40(sp)
            # ret 123
  li a0, 0
  li a1, 123
            # endfun 
  ld ra, 56(sp)
  ld fp, 48(sp)
  addi sp, sp, 64
  ret

  .data
b_type:    .quad 1
b_value:   .quad b_vector
b_length:  .quad 3
b_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

c_type:   .quad 0
c_value:  .quad 0

d_type:   .quad 0
d_value:  .quad 0

