#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -256
  sd ra, 248(sp)
  sd fp, 240(sp)
  addi fp, sp, 256
            # global a
            # copy .tmp0, 1
  li t0, 1
  sd zero, 0(sp)
  sd t0, 8(sp)
            # vector_set global_a, 0, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  ld t2, global_a_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp1, 2
  li t0, 2
  sd zero, 16(sp)
  sd t0, 24(sp)
            # vector_set global_a, 1, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  ld t2, global_a_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp2, 3
  li t0, 3
  sd zero, 32(sp)
  sd t0, 40(sp)
            # vector_set global_a, 2, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  ld t2, global_a_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp3, 4
  li t0, 4
  sd zero, 48(sp)
  sd t0, 56(sp)
            # vector_set global_a, 3, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  ld t2, global_a_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp4, 5
  li t0, 5
  sd zero, 64(sp)
  sd t0, 72(sp)
            # vector_set global_a, 4, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  ld t2, global_a_value
  addi t2, t2, 64
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global b
            # copy .tmp5, 5
  li t0, 5
  sd zero, 80(sp)
  sd t0, 88(sp)
            # vector_set global_b, 0, .tmp5
  ld t0, 80(sp)
  ld t1, 88(sp)
  ld t2, global_b_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp6, 6
  li t0, 6
  sd zero, 96(sp)
  sd t0, 104(sp)
            # vector_set global_b, 1, .tmp6
  ld t0, 96(sp)
  ld t1, 104(sp)
  ld t2, global_b_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp7, 7
  li t0, 7
  sd zero, 112(sp)
  sd t0, 120(sp)
            # vector_set global_b, 2, .tmp7
  ld t0, 112(sp)
  ld t1, 120(sp)
  ld t2, global_b_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp8, 8
  li t0, 8
  sd zero, 128(sp)
  sd t0, 136(sp)
            # vector_set global_b, 3, .tmp8
  ld t0, 128(sp)
  ld t1, 136(sp)
  ld t2, global_b_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp9, 9
  li t0, 9
  sd zero, 144(sp)
  sd t0, 152(sp)
            # vector_set global_b, 4, .tmp9
  ld t0, 144(sp)
  ld t1, 152(sp)
  ld t2, global_b_value
  addi t2, t2, 64
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global c
            # copy .tmp10, 3
  li t0, 3
  sd zero, 160(sp)
  sd t0, 168(sp)
            # copy global_c, .tmp10
  ld t0, 160(sp)
  ld t1, 168(sp)
  la t2, global_c_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp11, __vox_add__
  call __vox_add__
  addi sp, sp, 0
  sd a0, 176(sp)
  sd a1, 184(sp)
            # arg_count 1
            # arg .tmp11, 0
  ld a0, 176(sp)
  ld a1, 184(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_c, 0
  ld a0, global_c_type
  ld a1, global_c_value
            # arg global_a, 1
  ld a2, global_a_type
  ld a3, global_a_value
            # call .tmp12, __vox_add__
  call __vox_add__
  addi sp, sp, 0
  sd a0, 192(sp)
  sd a1, 200(sp)
            # arg_count 1
            # arg .tmp12, 0
  ld a0, 192(sp)
  ld a1, 200(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg global_c, 1
  ld a2, global_c_type
  ld a3, global_c_value
            # call .tmp13, __vox_add__
  call __vox_add__
  addi sp, sp, 0
  sd a0, 208(sp)
  sd a1, 216(sp)
            # arg_count 1
            # arg .tmp13, 0
  ld a0, 208(sp)
  ld a1, 216(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 1
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # call .tmp14, len
  call len
  addi sp, sp, 0
  sd a0, 224(sp)
  sd a1, 232(sp)
            # arg_count 1
            # arg .tmp14, 0
  ld a0, 224(sp)
  ld a1, 232(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # endfun 
  ld ra, 248(sp)
  ld fp, 240(sp)
  addi sp, sp, 256
  ret

  .data
global_a_type:    .quad 1
global_a_value:   .quad global_a_vector
global_a_length:  .quad 5
global_a_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_b_type:    .quad 1
global_b_value:   .quad global_b_vector
global_b_length:  .quad 5
global_b_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_c_type:   .quad 0
global_c_value:  .quad 0

