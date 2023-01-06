#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -48
  sd ra, 40(sp)
  sd fp, 32(sp)
  addi fp, sp, 48
            # global a
            # copy .tmp0, False
  li t1, 2
  li t2, 0
  sd t1, 0(sp)
  sd t2, 8(sp)
            # copy global_a, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg_count 0
            # call .tmp1, f
  call f
  sd a0, 16(sp)
  sd a1, 24(sp)
            # arg_count 1
            # arg .tmp1, 0
  ld a0, 16(sp)
  ld a1, 24(sp)
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 40(sp)
  ld fp, 32(sp)
  addi sp, sp, 48
  ret

# fun f();
f:
  addi sp, sp, -16
  sd ra, 8(sp)
  sd fp, 0(sp)
  addi fp, sp, 16
            # endfun 
  ld ra, 8(sp)
  ld fp, 0(sp)
  addi sp, sp, 16
  ret

  .data
a_type:   .quad 0
a_value:  .quad 0

