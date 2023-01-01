#include "lib_bracket.h"

  .global main
  .text
  .align 2
main:
  addi sp, sp, -232
  sd ra, 224(sp)
            # PARAM 5
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 5
  sd t0, 8(sp)
            # PARAM -4
  addi sp, sp, -16
  sd zero, (sp)
  li t0, -4
  sd t0, 8(sp)
            # PARAM 3
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 3
  sd t0, 8(sp)
            # PARAM 2
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 2
  sd t0, 8(sp)
            # CALL tmp0, __br_initvector__, 4
  mv a1, sp
  li a0, 4
  call __br_initvector__
  addi sp, sp, 64
  sd a0, 32(sp)
  sd a1, 40(sp)
            # COPY a, tmp0
  ld t0, 32(sp)
  sd t0, 48(sp)
  ld t0, 40(sp)
  sd t0, 56(sp)
            # PARAM a
  addi sp, sp, -16
  ld t0, 64(sp)
  sd t0, (sp)
  ld t0, 72(sp)
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # PARAM 500
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 500
  sd t0, 8(sp)
            # PARAM 400
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 400
  sd t0, 8(sp)
            # CALL tmp1, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 144(sp)
  sd a1, 152(sp)
            # COPY b, tmp1
  ld t0, 144(sp)
  sd t0, 16(sp)
  ld t0, 152(sp)
  sd t0, 24(sp)
            # PARAM b
  addi sp, sp, -16
  ld t0, 32(sp)
  sd t0, (sp)
  ld t0, 40(sp)
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # PARAM b
  addi sp, sp, -16
  ld t0, 32(sp)
  sd t0, (sp)
  ld t0, 40(sp)
  sd t0, 8(sp)
            # PARAM a
  addi sp, sp, -16
  ld t0, 80(sp)
  sd t0, (sp)
  ld t0, 88(sp)
  sd t0, 8(sp)
            # CALL tmp2, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 64(sp)
  sd a1, 72(sp)
            # PARAM tmp2
  addi sp, sp, -16
  ld t0, 80(sp)
  sd t0, (sp)
  ld t0, 88(sp)
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # PARAM -40
  addi sp, sp, -16
  sd zero, (sp)
  li t0, -40
  sd t0, 8(sp)
            # PARAM 50
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 50
  sd t0, 8(sp)
            # PARAM 0
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 0
  sd t0, 8(sp)
            # PARAM 10
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 10
  sd t0, 8(sp)
            # CALL tmp3, __br_initvector__, 4
  mv a1, sp
  li a0, 4
  call __br_initvector__
  addi sp, sp, 64
  sd a0, 192(sp)
  sd a1, 200(sp)
            # COPY c, tmp3
  ld t0, 192(sp)
  sd t0, 160(sp)
  ld t0, 200(sp)
  sd t0, 168(sp)
            # PARAM 1
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 1
  sd t0, 8(sp)
            # PARAM c
  addi sp, sp, -16
  ld t0, 192(sp)
  sd t0, (sp)
  ld t0, 200(sp)
  sd t0, 8(sp)
            # CALL tmp4, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 128(sp)
  sd a1, 136(sp)
            # PARAM a
  addi sp, sp, -16
  ld t0, 64(sp)
  sd t0, (sp)
  ld t0, 72(sp)
  sd t0, 8(sp)
            # PARAM tmp4
  addi sp, sp, -16
  ld t0, 160(sp)
  sd t0, (sp)
  ld t0, 168(sp)
  sd t0, 8(sp)
            # CALL tmp5, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 96(sp)
  sd a1, 104(sp)
            # COPY d, tmp5
  ld t0, 96(sp)
  sd t0, 208(sp)
  ld t0, 104(sp)
  sd t0, 216(sp)
            # PARAM d
  addi sp, sp, -16
  ld t0, 224(sp)
  sd t0, (sp)
  ld t0, 232(sp)
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # PARAM 7
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 7
  sd t0, 8(sp)
            # PARAM 6
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 6
  sd t0, 8(sp)
            # PARAM 5
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 5
  sd t0, 8(sp)
            # CALL tmp6, __br_initvector__, 3
  mv a1, sp
  li a0, 3
  call __br_initvector__
  addi sp, sp, 48
  sd a0, 80(sp)
  sd a1, 88(sp)
            # COPY e, tmp6
  ld t0, 80(sp)
  sd t0, 0(sp)
  ld t0, 88(sp)
  sd t0, 8(sp)
            # PARAM -2
  addi sp, sp, -16
  sd zero, (sp)
  li t0, -2
  sd t0, 8(sp)
            # PARAM d
  addi sp, sp, -16
  ld t0, 240(sp)
  sd t0, (sp)
  ld t0, 248(sp)
  sd t0, 8(sp)
            # CALL tmp7, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 176(sp)
  sd a1, 184(sp)
            # PARAM e
  addi sp, sp, -16
  ld t0, 16(sp)
  sd t0, (sp)
  ld t0, 24(sp)
  sd t0, 8(sp)
            # PARAM tmp7
  addi sp, sp, -16
  ld t0, 208(sp)
  sd t0, (sp)
  ld t0, 216(sp)
  sd t0, 8(sp)
            # CALL tmp8, __br_add__, 2
  mv a1, sp
  li a0, 2
  call __br_add__
  addi sp, sp, 32
  sd a0, 112(sp)
  sd a1, 120(sp)
            # PARAM tmp8
  addi sp, sp, -16
  ld t0, 128(sp)
  sd t0, (sp)
  ld t0, 136(sp)
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
  ld ra, 224(sp)
  addi sp, sp, 232
  mv a0, zero
  ret
