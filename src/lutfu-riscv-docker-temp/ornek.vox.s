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
            # arg 4
  li a0, 0
  li a1, 4
            # call .tmp0, faktoriyel
  call faktoriyel
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret

# fun faktoriyel(n);
faktoriyel:
  addi sp, sp, -96
  sd ra, 88(sp)
  sd fp, 80(sp)
  addi fp, sp, 96
            # param n
  sd a0, 0(sp)
  sd a1, 8(sp)
            # <= .tmp0, n, 1
  ld t0, 8(sp)
  li t1, 1
  slt t2, t0, t1
  sub t0, t0, t1
  seqz t0, t0
  or t2, t2, t0
  li t1, 2
  sd t1, 16(sp)
  sd t2, 24(sp)
            # branch_if_false .tmp0, .L_endif1
  ld t0, 24(sp)
  beq t0, zero, .L_endif1
            # return 1
  li a0, 0
  li a1, 1
  ld ra, 88(sp)
  ld fp, 80(sp)
  addi sp, sp, 96
  ret
            # branch .L_endelse1
  j .L_endelse1
            # label .L_endif1
.L_endif1:
            # arg n
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg 1
  li a2, 0
  li a3, 1
            # call .tmp2, __vox_sub__
  call __vox_sub__
  sd a0, 48(sp)
  sd a1, 56(sp)
            # arg .tmp2
  ld a0, 48(sp)
  ld a1, 56(sp)
            # call .tmp3, faktoriyel
  call faktoriyel
  sd a0, 64(sp)
  sd a1, 72(sp)
            # arg n
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg .tmp3
  ld a2, 64(sp)
  ld a3, 72(sp)
            # call .tmp1, __vox_mul__
  call __vox_mul__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # return .tmp1
  ld a0, 32(sp)
  ld a1, 40(sp)
  ld ra, 88(sp)
  ld fp, 80(sp)
  addi sp, sp, 96
  ret
            # label .L_endelse1
.L_endelse1:
            # return 
  ld ra, 88(sp)
  ld fp, 80(sp)
  addi sp, sp, 96
  ret
