#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -56
  sd ra, 48(sp)
            # copy global_i, 0
  li t0, 0
  li t1, 0
  la t2, i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # branch ".L_for_cond2"
  j .L_for_cond2
            # label ".L_for_body2"
.L_for_body2:
            # arg global_i
  ld a0, i_type
  ld a1, i_value
            # call "__vox_print__"
  call __vox_print__
            # arg global_i
  ld a0, i_type
  ld a1, i_value
            # call .tmp0, "isPrime"
  call isPrime
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call "__vox_print__"
  call __vox_print__
            # arg "\n"
  li a0, 3
  la a1, .L_string1
            # call "__vox_print__"
  call __vox_print__
            # add .tmp1, global_i, 1
  ld a0, i_type
  ld a1, i_value
  li a2, 0
  li a3, 1
  call __vox_add__
  sd a0, 16(sp)
  sd a1, 24(sp)
            # copy global_i, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  la t2, i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # label ".L_for_cond2"
.L_for_cond2:
            # < .tmp2, global_i, 15
  ld t0, i_value
  li t1, 15
  slt t2, t0, t1
  li t1, 2
  sd t1, 32(sp)
  sd t2, 40(sp)
            # branch_if_true .tmp2, ".L_for_body2"
  ld t0, 40(sp)
  bne t0, zero, .L_for_body2
            # return 
  ld ra, 48(sp)
  addi sp, sp, 56
  li a0, 0
  ret

# fun modulo(number, i);
modulo:
  addi sp, sp, -88
  sd ra, 80(sp)
            # param number
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param i
  sd a2, 16(sp)
  sd a3, 24(sp)
            # div .tmp2, number, i
  ld a0, 0(sp)
  ld a1, 8(sp)
  ld a2, 16(sp)
  ld a3, 24(sp)
  call __vox_div__
  sd a0, 64(sp)
  sd a1, 72(sp)
            # mul .tmp1, .tmp2, i
  ld a0, 64(sp)
  ld a1, 72(sp)
  ld a2, 16(sp)
  ld a3, 24(sp)
  call __vox_mul__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # sub .tmp0, number, .tmp1
  ld a0, 0(sp)
  ld a1, 8(sp)
  ld a2, 48(sp)
  ld a3, 56(sp)
  call __vox_sub__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # return .tmp0
  ld a0, 32(sp)
  ld a1, 40(sp)
  ld ra, 80(sp)
  addi sp, sp, 88
  ret

# fun isPrime(number);
isPrime:
  addi sp, sp, -152
  sd ra, 144(sp)
            # param number
  sd a0, 0(sp)
  sd a1, 8(sp)
            # <= .tmp0, number, True
  ld t0, 8(sp)
  li t1, 1
  slt t2, t0, t1
  sub t0, t0, t1
  seqz t0, t0
  or t2, t2, t0
  li t1, 2
  sd t1, 32(sp)
  sd t2, 40(sp)
            # copy isPrime, True
  li t0, 2
  li t1, 1
  sd t0, 16(sp)
  sd t1, 24(sp)
            # branch_if_false .tmp0, ".L_endif1"
  ld t0, 40(sp)
  beq t0, zero, .L_endif1
            # return False
  li a0, 2
  li a1, 0
  ld ra, 144(sp)
  addi sp, sp, 152
  ret
            # branch ".L_endelse1"
  j .L_endelse1
            # label ".L_endif1"
.L_endif1:
            # > .tmp1, number, 1
  li t0, 1
  ld t1, 8(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 48(sp)
  sd t2, 56(sp)
            # branch_if_false .tmp1, ".L_endif2"
  ld t0, 56(sp)
  beq t0, zero, .L_endif2
            # copy i, 2
  li t0, 0
  li t1, 2
  sd t0, 64(sp)
  sd t1, 72(sp)
            # branch ".L_for_cond1"
  j .L_for_cond1
            # label ".L_for_body1"
.L_for_body1:
            # arg number
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg i
  ld a2, 64(sp)
  ld a3, 72(sp)
            # call .tmp3, "modulo"
  call modulo
  sd a0, 96(sp)
  sd a1, 104(sp)
            # == .tmp2, .tmp3, 0
  ld t0, 104(sp)
  li t1, 0
  sub t0, t0, t1
  seqz t2, t0
  li t1, 2
  sd t1, 80(sp)
  sd t2, 88(sp)
            # branch_if_false .tmp2, ".L_endif3"
  ld t0, 88(sp)
  beq t0, zero, .L_endif3
            # copy isPrime, False
  li t0, 2
  li t1, 0
  sd t0, 16(sp)
  sd t1, 24(sp)
            # label ".L_endif3"
.L_endif3:
            # add .tmp4, i, 1
  ld a0, 64(sp)
  ld a1, 72(sp)
  li a2, 0
  li a3, 1
  call __vox_add__
  sd a0, 112(sp)
  sd a1, 120(sp)
            # copy i, .tmp4
  ld t0, 112(sp)
  ld t1, 120(sp)
  sd t0, 64(sp)
  sd t1, 72(sp)
            # label ".L_for_cond1"
.L_for_cond1:
            # < .tmp5, i, number
  ld t0, 72(sp)
  ld t1, 8(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 128(sp)
  sd t2, 136(sp)
            # branch_if_true .tmp5, ".L_for_body1"
  ld t0, 136(sp)
  bne t0, zero, .L_for_body1
            # label ".L_endif2"
.L_endif2:
            # label ".L_endelse1"
.L_endelse1:
            # return isPrime
  ld a0, 16(sp)
  ld a1, 24(sp)
  ld ra, 144(sp)
  addi sp, sp, 152
  ret

  .data
i_type:   .quad 0
i_value:  .quad 0

.L_string1:  .string "\n"
