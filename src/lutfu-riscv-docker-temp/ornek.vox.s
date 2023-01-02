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
            # copy .tmp0, Merhaba dünya!
  li t1, 3
  la t2, .L_string1
  sd t1, 0(sp)
  sd t2, 8(sp)
            # arg_vox_lib .tmp0
  addi sp, sp, -16
  ld t0, 16(sp)
  ld t1, 24(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # endfun 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret

  .data
.L_string1:  .string "Merhaba dünya!"
