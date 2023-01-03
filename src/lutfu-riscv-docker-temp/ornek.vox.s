#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -200
  sd ra, 192(sp)
  sd fp, 184(sp)
  addi fp, sp, 200
            # global c
            # copy .tmp0, 1
  li t0, 1
  sd zero, 0(sp)
  sd t0, 8(sp)
            # vector_set global_c, 0, .tmp0
            # copy .tmp1, 2
  li t0, 2
  sd zero, 16(sp)
  sd t0, 24(sp)
            # vector_set global_c, 1, .tmp1
            # copy .tmp2, 3
  li t0, 3
  sd zero, 32(sp)
  sd t0, 40(sp)
            # vector_set global_c, 2, .tmp2
            # arg_vox_lib global_c
  addi sp, sp, -16
  ld t0, global_c_type
  ld t1, global_c_value
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp3, True
  li t1, 2
  li t2, 1
  sd t1, 48(sp)
  sd t2, 56(sp)
            # branch_if_false .tmp3, .L_endif1
  ld t0, 56(sp)
  beq t0, zero, .L_endif1
            # vector c, 3
  li t1, 1
  add t2, sp, 88
  sd t1, 64(sp)
  sd t2, 72(sp)
  li t0, 3
  sd t0, 80(sp)
            # copy .tmp4, 1
  li t0, 1
  sd zero, 136(sp)
  sd t0, 144(sp)
            # vector_set c, 0, .tmp4
            # copy .tmp5, 2
  li t0, 2
  sd zero, 152(sp)
  sd t0, 160(sp)
            # vector_set c, 1, .tmp5
            # copy .tmp6, 3
  li t0, 3
  sd zero, 168(sp)
  sd t0, 176(sp)
            # vector_set c, 2, .tmp6
            # arg_vox_lib c
  addi sp, sp, -16
  ld t0, 80(sp)
  ld t1, 88(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # label .L_endif1
.L_endif1:
            # endfun 
  ld ra, 192(sp)
  ld fp, 184(sp)
  addi sp, sp, 200
  ret

  .data
global_c_type:    .quad 1
global_c_value:   .quad global_c_vector
global_c_length:  .quad 3
global_c_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

