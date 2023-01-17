#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # call .tmp0, f
  call f
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun f();
f:
  addi sp, sp, -168
  sd ra, 160(sp)
            # sub .tmp0, 14, 2
  li a0, 0
  li a1, 14
  li a2, 0
  li a3, 2
  call __vox_sub__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # ! .tmp1, True
  li t0, 1
  xori t0, t0, 1
  li t2, 2
  sd t2, 80(sp)
  sd t0, 88(sp)
            # copy bes_x_2_arti_4, 14
  li t0, 0
  li t1, 14
  sd t0, 0(sp)
  sd t1, 8(sp)
            # copy toplam, .tmp0
  ld t0, 32(sp)
  ld t1, 40(sp)
  sd t0, 16(sp)
  sd t1, 24(sp)
            # copy dogru, True
  li t0, 2
  li t1, 1
  sd t0, 48(sp)
  sd t1, 56(sp)
            # copy yanlis, .tmp1
  ld t0, 80(sp)
  ld t1, 88(sp)
  sd t0, 64(sp)
  sd t1, 72(sp)
            # branch_if_true yanlis, .L_short_or1
  ld t0, 72(sp)
  bne t0, zero, .L_short_or1
            # < .tmp3, toplam, bes_x_2_arti_4
  ld t0, 24(sp)
  ld t1, 8(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 112(sp)
  sd t2, 120(sp)
            # branch_if_true .tmp3, .L_short_or1
  ld t0, 120(sp)
  bne t0, zero, .L_short_or1
            # copy .tmp_interblock2, False
  li t0, 2
  li t1, 0
  sd t0, 96(sp)
  sd t1, 104(sp)
            # branch .L_or1
  j .L_or1
            # label .L_short_or1
.L_short_or1:
            # copy .tmp_interblock2, True
  li t0, 2
  li t1, 1
  sd t0, 96(sp)
  sd t1, 104(sp)
            # label .L_or1
.L_or1:
            # branch_if_false .tmp_interblock2, .L_endif1
  ld t0, 104(sp)
  beq t0, zero, .L_endif1
            # branch_if_true dogru, .L_short_or2
  ld t0, 56(sp)
  bne t0, zero, .L_short_or2
            # branch_if_true yanlis, .L_short_or2
  ld t0, 72(sp)
  bne t0, zero, .L_short_or2
            # copy .tmp_interblock4, False
  li t0, 2
  li t1, 0
  sd t0, 128(sp)
  sd t1, 136(sp)
            # branch .L_or2
  j .L_or2
            # label .L_short_or2
.L_short_or2:
            # copy .tmp_interblock4, True
  li t0, 2
  li t1, 1
  sd t0, 128(sp)
  sd t1, 136(sp)
            # label .L_or2
.L_or2:
            # arg .tmp_interblock4
  ld a0, 128(sp)
  ld a1, 136(sp)
            # call __vox_print__
  call __vox_print__
            # branch_if_false dogru, .L_short_and1
  ld t0, 56(sp)
  beq t0, zero, .L_short_and1
            # branch_if_false yanlis, .L_short_and1
  ld t0, 72(sp)
  beq t0, zero, .L_short_and1
            # copy .tmp_interblock5, True
  li t0, 2
  li t1, 1
  sd t0, 144(sp)
  sd t1, 152(sp)
            # branch .L_and1
  j .L_and1
            # label .L_short_and1
.L_short_and1:
            # copy .tmp_interblock5, False
  li t0, 2
  li t1, 0
  sd t0, 144(sp)
  sd t1, 152(sp)
            # label .L_and1
.L_and1:
            # arg .tmp_interblock5
  ld a0, 144(sp)
  ld a1, 152(sp)
            # call __vox_print__
  call __vox_print__
            # branch .L_endelse1
  j .L_endelse1
            # label .L_endif1
.L_endif1:
            # arg toplam
  ld a0, 16(sp)
  ld a1, 24(sp)
            # call __vox_print__
  call __vox_print__
            # label .L_endelse1
.L_endelse1:
            # return 
  ld ra, 160(sp)
  addi sp, sp, 168
  ret
