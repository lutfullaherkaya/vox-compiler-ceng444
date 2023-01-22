#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # call .tmp0, "f"
  call f
            # arg .tmp0
  mv a6, a0  #backend: clearing a0 for return val
  mv a7, a1  #backend: clearing a1 for return val
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -16
  sd a6, 0(sp)
  sd a7, 8(sp)
  call __vox_print__
  ld a6, 0(sp)
  ld a7, 8(sp)
  addi sp, sp, 16
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun f();
f:
            # return global_a
  ld a0, a_type
  ld a1, a_value
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

