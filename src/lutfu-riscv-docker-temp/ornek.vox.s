#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # arg 2
  li a0, 0
  li a1, 2
            # call .tmp0, "kare"
  call kare
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

# fun kare(a);
kare:
  addi sp, sp, -56
  sd ra, 48(sp)
  sd s1, 40(sp)
  sd s2, 32(sp)
            # param a
            # mul .tmp0, a, a
  mv s1, a0  #backend: clearing a0 for return val
  mv s2, a1  #backend: clearing a1 for return val
  mv a2, s1
  mv a3, s2
  call __vox_mul__
            # return .tmp0
  ld ra, 48(sp)
  ld s1, 40(sp)
  ld s2, 32(sp)
  addi sp, sp, 56
  ret
