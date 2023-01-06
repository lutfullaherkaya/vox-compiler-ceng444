#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -208
  sd ra, 200(sp)
  sd fp, 192(sp)
  addi fp, sp, 208
            # global a
            # copy .tmp1, 2
  li t0, 2
  sd zero, 16(sp)
  sd t0, 24(sp)
            # copy .tmp2, 2
  li t0, 2
  sd zero, 32(sp)
  sd t0, 40(sp)
            # arg_count 2
            # arg .tmp1, 0
  ld a0, 16(sp)
  ld a1, 24(sp)
            # arg .tmp2, 1
  ld a2, 32(sp)
  ld a3, 40(sp)
            # call .tmp0, __vox_add__
  call __vox_add__
  addi sp, sp, 0
  sd a0, 0(sp)
  sd a1, 8(sp)
            # copy global_a, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global b
            # arg_count 2
            # arg global_a, 0
  ld a0, a_type
  ld a1, a_value
            # arg global_a, 1
  ld a2, a_type
  ld a3, a_value
            # call .tmp3, __vox_mul__
  call __vox_mul__
  addi sp, sp, 0
  sd a0, 48(sp)
  sd a1, 56(sp)
            # copy global_b, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  la t2, b_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global c
            # copy .tmp4, 1
  li t0, 1
  sd zero, 64(sp)
  sd t0, 72(sp)
            # vector_set global_c, 0, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  ld t2, c_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp5, 3
  li t0, 3
  sd zero, 80(sp)
  sd t0, 88(sp)
            # vector_set global_c, 1, .tmp5
  ld t0, 80(sp)
  ld t1, 88(sp)
  ld t2, c_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp6, 4
  li t0, 4
  sd zero, 96(sp)
  sd t0, 104(sp)
            # vector_set global_c, 2, .tmp6
  ld t0, 96(sp)
  ld t1, 104(sp)
  ld t2, c_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp7, bes
  li t1, 3
  la t2, .L_string1
  sd t1, 112(sp)
  sd t2, 120(sp)
            # vector_set global_c, 3, .tmp7
  ld t0, 112(sp)
  ld t1, 120(sp)
  ld t2, c_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp9, 10
  li t0, 10
  sd zero, 144(sp)
  sd t0, 152(sp)
            # > .tmp8, global_b, .tmp9
  ld t0, 152(sp)
  ld t1, b_value
  slt t2, t0, t1
  li t1, 2
  sd t1, 128(sp)
  sd t2, 136(sp)
            # branch_if_false .tmp8, .L_endif1
  ld t0, 136(sp)
  beq t0, zero, .L_endif1
            # copy .tmp10, b ondan büyüktür
  li t1, 3
  la t2, .L_string2
  sd t1, 160(sp)
  sd t2, 168(sp)
            # arg_count 1
            # arg .tmp10, 0
  ld a0, 160(sp)
  ld a1, 168(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # branch .L_endelse1
  j .L_endelse1
            # label .L_endif1
.L_endif1:
            # copy .tmp11, b ondan küçüktür
  li t1, 3
  la t2, .L_string3
  sd t1, 176(sp)
  sd t2, 184(sp)
            # arg_count 1
            # arg .tmp11, 0
  ld a0, 176(sp)
  ld a1, 184(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # label .L_endelse1
.L_endelse1:
            # arg_count 1
            # arg global_c, 0
  ld a0, c_type
  ld a1, c_value
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # endfun 
  ld ra, 200(sp)
  ld fp, 192(sp)
  addi sp, sp, 208
  ret

  .data
a_type:   .quad 0
a_value:  .quad 0

b_type:   .quad 0
b_value:  .quad 0

c_type:    .quad 1
c_value:   .quad c_vector
c_length:  .quad 4
c_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

.L_string1:  .string "bes"
.L_string2:  .string "b ondan büyüktür"
.L_string3:  .string "b ondan küçüktür"
