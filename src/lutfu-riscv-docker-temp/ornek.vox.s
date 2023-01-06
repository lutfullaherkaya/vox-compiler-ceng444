#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -16
  sd ra, 8(sp)
  sd fp, 0(sp)
  addi fp, sp, 16
            # endfun 
  ld ra, 8(sp)
  ld fp, 0(sp)
  addi sp, sp, 16
  ret

# fun f();
f:
  addi sp, sp, -32
  sd ra, 24(sp)
  sd fp, 16(sp)
  addi fp, sp, 32
            # copy .tmp0, 4
  li t0, 4
  sd zero, 0(sp)
  sd t0, 8(sp)
            # ret .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # endfun 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret
