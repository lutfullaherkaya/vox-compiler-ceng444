#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -72
  sd ra, 64(sp)
            # global i
            # global j
            # copy global_i, 0
  li t0, 0
  li t1, 0
  la t2, i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # branch .L_for_cond1
  j .L_for_cond1
            # label .L_for_body1
.L_for_body1:
            # arg global_i
  ld a0, i_type
  ld a1, i_value
            # call __vox_print__
  call __vox_print__
            # branch_if_false global_i, .L_endif1
  ld t0, i_value
  beq t0, zero, .L_endif1
            # copy i, 123
  li t0, 0
  li t1, 123
  sd t0, 0(sp)
  sd t1, 8(sp)
            # branch_if_false i, .L_endif2
  ld t0, 8(sp)
  beq t0, zero, .L_endif2
            # copy i-1, 456
  li t0, 0
  li t1, 456
  sd t0, 16(sp)
  sd t1, 24(sp)
            # label .L_endif2
.L_endif2:
            # label .L_endif1
.L_endif1:
            # add .tmp0, global_i, 1
  ld a0, i_type
  ld a1, i_value
  li a2, 0
  li a3, 1
  call __vox_add__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # copy global_i, .tmp0
  ld t0, 32(sp)
  ld t1, 40(sp)
  la t2, i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # label .L_for_cond1
.L_for_cond1:
            # < .tmp1, global_i, 10
  ld t0, i_value
  li t1, 10
  slt t2, t0, t1
  li t1, 2
  sd t1, 48(sp)
  sd t2, 56(sp)
            # branch_if_true .tmp1, .L_for_body1
  ld t0, 56(sp)
  bne t0, zero, .L_for_body1
            # arg global_j
  ld a0, j_type
  ld a1, j_value
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 64(sp)
  addi sp, sp, 72
  li a0, 0
  ret

  .data
i_type:   .quad 0
i_value:  .quad 767676

j_type:   .quad 3
j_value:  .quad .L_string1

.L_string1:  .string "hello world"
