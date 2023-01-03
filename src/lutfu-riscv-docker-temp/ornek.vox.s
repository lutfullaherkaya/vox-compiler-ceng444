#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -160
  sd ra, 152(sp)
  sd fp, 144(sp)
  addi fp, sp, 160
            # global a
            # copy .tmp0, 5
  li t0, 5
  sd zero, 0(sp)
  sd t0, 8(sp)
            # copy global_a, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, global_a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global b
            # vector_set global_b, 0, global_a
            # copy .tmp1, 1
  li t0, 1
  sd zero, 16(sp)
  sd t0, 24(sp)
            # vector_set global_b, 1, .tmp1
            # copy .tmp2, asdf
  li t1, 3
  la t2, .L_string1
  sd t1, 32(sp)
  sd t2, 40(sp)
            # vector_set global_b, 2, .tmp2
            # copy .tmp3, True
  li t1, 2
  li t2, 1
  sd t1, 48(sp)
  sd t2, 56(sp)
            # branch_if_false .tmp3, .L_endif1
  ld t0, 56(sp)
  beq t0, zero, .L_endif1
            # vector c, 4
  li t1, 1
  add t2, sp, 96
  sd t1, 64(sp)
  sd t2, 72(sp)
  li t0, 4
  sd t0, 88(sp)
            # copy .tmp4, 1
  li t0, 1
  sd zero, 152(sp)
  sd t0, 160(sp)
            # vector_set c, 0, .tmp4
            # copy .tmp5, 23
  li t0, 23
  sd zero, 168(sp)
  sd t0, 176(sp)
            # vector_set c, 1, .tmp5
            # copy .tmp6, False
  li t1, 2
  li t2, 0
  sd t1, 184(sp)
  sd t2, 192(sp)
            # vector_set c, 2, .tmp6
            # copy .tmp7, asdff
  li t1, 3
  la t2, .L_string2
  sd t1, 200(sp)
  sd t2, 208(sp)
            # vector_set c, 3, .tmp7
            # label .L_endif1
.L_endif1:
            # endfun 
  ld ra, 152(sp)
  ld fp, 144(sp)
  addi sp, sp, 160
  ret

  .data
global_a_type:   .quad 0
global_a_value:  .quad 0

global_b_type:    .quad 1
global_b_value:   .quad global_b_vector
global_b_length:  .quad 3
global_b_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

.L_string1:  .string "asdf"
.L_string2:  .string "asdff"
