#include "vox_lib.h"
  
  .global main
  .text
  .align 2
main:
  addi sp, sp, -184
  sd ra, 176(sp)
            # global a
            # copy .tmp0, 5
  li t0, 5
  sd zero, 0(sp)
  sd t0, 8(sp)
            # copy a, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, global_a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # copy .tmp4, 5
  li t0, 5
  sd zero, 64(sp)
  sd t0, 72(sp)
            # + .tmp3, a, .tmp4
  ld t0, global_a_value
  ld t1, 72(sp)
  add t0, t0, t1
  sd zero, 48(sp)
  sd t0, 56(sp)
            # copy .tmp6, 2
  li t0, 2
  sd zero, 96(sp)
  sd t0, 104(sp)
            # copy .tmp7, 3
  li t0, 3
  sd zero, 112(sp)
  sd t0, 120(sp)
            # / .tmp5, .tmp6, .tmp7
  ld t0, 104(sp)
  ld t1, 120(sp)
  div t0, t0, t1
  sd zero, 80(sp)
  sd t0, 88(sp)
            # + .tmp2, .tmp3, .tmp5
  ld t0, 56(sp)
  ld t1, 88(sp)
  add t0, t0, t1
  sd zero, 32(sp)
  sd t0, 40(sp)
            # copy .tmp9, 0
  li t0, 0
  sd zero, 144(sp)
  sd t0, 152(sp)
            # copy .tmp10, 50515
  li t0, 50515
  sd zero, 160(sp)
  sd t0, 168(sp)
            # - .tmp8, .tmp9, .tmp10
  ld t0, 152(sp)
  ld t1, 168(sp)
  sub t0, t0, t1
  sd zero, 128(sp)
  sd t0, 136(sp)
            # > .tmp1, .tmp2, .tmp8
  ld t0, 136(sp)
  ld t1, 40(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 16(sp)
  sd t2, 24(sp)
            # param .tmp1
  addi sp, sp, -16
  ld t0, 32(sp)
  ld t1, 40(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
  ld ra, 176(sp)
  addi sp, sp, 184
  mv a0, zero
  ret

  .data
global_a_type:  .quad 0
global_a_value: .quad 0

