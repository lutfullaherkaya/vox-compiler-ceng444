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
            # global x
            # copy global_x, 5
  li t0, 0
  li t1, 5
  la t2, x_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global a
            # vector_set global_a, 0, 0
  li t0, 0
  li t1, 0
  ld t2, a_value
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_a, 1, False
  li t0, 2
  li t1, 0
  ld t2, a_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_a, 2, global_x
  ld t0, x_type
  ld t1, x_value
  ld t2, a_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_a, 0, 19
  li t0, 0
  li t1, 19
  ld t2, a_value
  sd t0, 0(t2)
  sd t1, 8(t2)
            # arg_count 0
            # call .tmp0, f
  call f
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg_count 1
            # arg .tmp0, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret

# fun f();
f:
  addi sp, sp, -64
  sd ra, 56(sp)
  sd fp, 48(sp)
  addi fp, sp, 64
            # copy a
  sd zero, 0(sp)
  sd zero, 8(sp)
            # copy a, 0
  li t0, 0
  li t1, 0
  sd t0, 0(sp)
  sd t1, 8(sp)
            # branch .L_for_cond1
  j .L_for_cond1
            # label .L_for_body1
.L_for_body1:
            # arg_count 1
            # arg a, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # ret 123
  li a0, 0
  li a1, 123
            # endfun 
  ld ra, 56(sp)
  ld fp, 48(sp)
  addi sp, sp, 64
  ret
            # arg_count 2
            # arg a, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg 1, 1
  li a2, 0
  li a3, 1
            # call .tmp0, __vox_add__
  call __vox_add__
  sd a0, 16(sp)
  sd a1, 24(sp)
            # copy a, .tmp0
  ld t0, 16(sp)
  ld t1, 24(sp)
  sd t0, 0(sp)
  sd t1, 8(sp)
            # label .L_for_cond1
.L_for_cond1:
            # < .tmp1, a, 10
  ld t0, 8(sp)
  li t1, 10
  slt t2, t0, t1
  li t1, 2
  sd t1, 32(sp)
  sd t2, 40(sp)
            # branch_if_true .tmp1, .L_for_body1
  ld t0, 40(sp)
  bne t0, zero, .L_for_body1
            # endfun 
  addi sp, sp, 48
  ret

  .data
x_type:   .quad 0
x_value:  .quad 0

a_type:    .quad 1
a_value:   .quad a_vector
a_length:  .quad 3
a_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

