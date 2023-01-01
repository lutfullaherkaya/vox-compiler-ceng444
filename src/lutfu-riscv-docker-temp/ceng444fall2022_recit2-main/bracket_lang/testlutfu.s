#include "lib_bracket.h"

  .global main
  .text
  .align 2
main:
  addi sp, sp, -8
  sd ra, 0(sp)
            # PARAM 5
  addi sp, sp, -16
  sd zero, (sp)
  li t0, 5
  sd t0, 8(sp)
            # CALL __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
  ld ra, 0(sp)
  addi sp, sp, 8
  mv a0, zero
  ret
