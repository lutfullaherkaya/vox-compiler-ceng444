#include "vox_lib.h"
  
  .global main
  .text
  .align 2
main:
  addi sp, sp, -40
  sd ra, 32(sp)
            # copy .tmp0, 5
  sd zero, 0(sp)
  li t0, 92233720368547758
  sd t0, 8(sp)
            # copy a, .tmp0
  ld t0, 0(sp)
  sd t0, 16(sp)
  ld t0, global_var
  ld t0, 8(sp)
  sd t0, 24(sp)
            # param a
  addi sp, sp, -16
  ld t0, 32(sp)
  sd t0, (sp)
  ld t0, 40(sp)
  sd t0, 8(sp)
            # call __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
  ld ra, 32(sp)
  addi sp, sp, 40
  mv a0, zero
  ret

  .data
global_var: .quad 92233720368547758
