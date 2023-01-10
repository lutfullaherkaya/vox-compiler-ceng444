#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -176
  sd ra, 168(sp)
            # global a
            # global b
            # copy global_b, global_a
  ld t0, a_type
  ld t1, a_value
  la t2, b_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global ab
            # vector c, 3
  li t1, 1
  add t2, sp, 24
  sd t1, 0(sp)
  sd t2, 8(sp)
  li t0, 3
  sd t0, 16(sp)
            # vector_set c, 0, 1
  ld t2, 8(sp)
  li t0, 0
  li t1, 1
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set c, 1, 2
  ld t2, 8(sp)
  addi t2, t2, 16
  li t0, 0
  li t1, 2
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set c, 2, 3
  ld t2, 8(sp)
  addi t2, t2, 32
  li t0, 0
  li t1, 3
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy global_ab, 53
  li t0, 0
  li t1, 53
  la t2, ab_type
  sd t0, (t2)
  sd t1, 8(t2)
            # add .tmp0, global_ab, 231
  ld a0, ab_type
  ld a1, ab_value
  li a2, 0
  li a3, 231
  call __vox_add__
  sd a0, 72(sp)
  sd a1, 80(sp)
            # copy global_ab, .tmp0
  ld t0, 72(sp)
  ld t1, 80(sp)
  la t2, ab_type
  sd t0, (t2)
  sd t1, 8(t2)
            # mul .tmp5, global_ab, c
  ld a0, ab_type
  ld a1, ab_value
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_mul__
  sd a0, 152(sp)
  sd a1, 160(sp)
            # mul .tmp4, .tmp5, c
  ld a0, 152(sp)
  ld a1, 160(sp)
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_mul__
  sd a0, 136(sp)
  sd a1, 144(sp)
            # mul .tmp3, .tmp4, c
  ld a0, 136(sp)
  ld a1, 144(sp)
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_mul__
  sd a0, 120(sp)
  sd a1, 128(sp)
            # mul .tmp2, .tmp3, c
  ld a0, 120(sp)
  ld a1, 128(sp)
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_mul__
  sd a0, 104(sp)
  sd a1, 112(sp)
            # mul .tmp1, .tmp2, global_ab
  ld a0, 104(sp)
  ld a1, 112(sp)
  ld a2, ab_type
  ld a3, ab_value
  call __vox_mul__
  sd a0, 88(sp)
  sd a1, 96(sp)
            # arg .tmp1
  ld a0, 88(sp)
  ld a1, 96(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 168(sp)
  addi sp, sp, 176
  li a0, 0
  ret

# fun x(ab);
x:
  addi sp, sp, -32
            # param ab
  sd a0, 0(sp)
  sd a1, 8(sp)
            # copy a, 6
  li t0, 0
  li t1, 6
  sd t0, 16(sp)
  sd t1, 24(sp)
            # return 
  addi sp, sp, 32
  ret

# fun main.fake();
main.fake:
            # return 0
  li a0, 0
  li a1, 0
  ret

# fun y(ab);
y:
  addi sp, sp, -48
            # param ab
  sd a0, 0(sp)
  sd a1, 8(sp)
            # copy a, 7
  li t0, 0
  li t1, 7
  sd t0, 16(sp)
  sd t1, 24(sp)
            # branch_if_false a, .L_endif1
  ld t0, 24(sp)
  beq t0, zero, .L_endif1
            # copy a-1, 8
  li t0, 0
  li t1, 8
  sd t0, 32(sp)
  sd t1, 40(sp)
            # label .L_endif1
.L_endif1:
            # return 
  addi sp, sp, 48
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

ab_type:   .quad 0
ab_value:  .quad 55

