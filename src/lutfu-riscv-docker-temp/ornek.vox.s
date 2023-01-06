#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -176
  sd ra, 168(sp)
  sd fp, 160(sp)
  addi fp, sp, 176
            # global a
            # copy .tmp0, 4
  li t0, 4
  sd zero, 0(sp)
  sd t0, 8(sp)
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
            # call .tmp1, __vox_mul__
  call __vox_mul__
  addi sp, sp, 0
  sd a0, 16(sp)
  sd a1, 24(sp)
            # copy global_b, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  la t2, b_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global c
            # copy .tmp2, 1
  li t0, 1
  sd zero, 32(sp)
  sd t0, 40(sp)
            # vector_set global_c, 0, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  ld t2, c_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp3, 3
  li t0, 3
  sd zero, 48(sp)
  sd t0, 56(sp)
            # vector_set global_c, 1, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  ld t2, c_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp4, 4
  li t0, 4
  sd zero, 64(sp)
  sd t0, 72(sp)
            # vector_set global_c, 2, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  ld t2, c_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp5, bes
  li t1, 3
  la t2, .L_string1
  sd t1, 80(sp)
  sd t2, 88(sp)
            # vector_set global_c, 3, .tmp5
  ld t0, 80(sp)
  ld t1, 88(sp)
  ld t2, c_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp7, 10
  li t0, 10
  sd zero, 112(sp)
  sd t0, 120(sp)
            # > .tmp6, global_b, .tmp7
  ld t0, 120(sp)
  ld t1, b_value
  slt t2, t0, t1
  li t1, 2
  sd t1, 96(sp)
  sd t2, 104(sp)
            # branch_if_false .tmp6, .L_endif1
  ld t0, 104(sp)
  beq t0, zero, .L_endif1
            # copy .tmp8, b ondan büyüktür
  li t1, 3
  la t2, .L_string2
  sd t1, 128(sp)
  sd t2, 136(sp)
            # arg_count 1
            # arg .tmp8, 0
  ld a0, 128(sp)
  ld a1, 136(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # branch .L_endelse1
  j .L_endelse1
            # label .L_endif1
.L_endif1:
            # copy .tmp9, b ondan küçüktür
  li t1, 3
  la t2, .L_string3
  sd t1, 144(sp)
  sd t2, 152(sp)
            # arg_count 1
            # arg .tmp9, 0
  ld a0, 144(sp)
  ld a1, 152(sp)
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
  ld ra, 168(sp)
  ld fp, 160(sp)
  addi sp, sp, 176
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
