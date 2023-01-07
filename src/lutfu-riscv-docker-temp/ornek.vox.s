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
            # arg_count 0
            # call .tmp0, f
  call f
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg_count 1
            # arg .tmp0, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 24(sp)
  ld fp, 16(sp)
  addi sp, sp, 32
  ret

# fun f();
f:
  addi sp, sp, -80
  sd ra, 72(sp)
  sd fp, 64(sp)
  addi fp, sp, 80
            # copy bes_x_2_arti_4, 14
  li t0, 0
  li t1, 14
  sd t0, 0(sp)
  sd t1, 8(sp)
            # copy toplam, 12
  li t0, 0
  li t1, 12
  sd t0, 16(sp)
  sd t1, 24(sp)
            # copy dogru, True
  li t0, 2
  li t1, 1
  sd t0, 32(sp)
  sd t1, 40(sp)
            # copy yanlis, False
  li t0, 2
  li t1, 0
  sd t0, 48(sp)
  sd t1, 56(sp)
            # arg_count 1
            # arg True, 0
  li a0, 2
  li a1, 1
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 72(sp)
  ld fp, 64(sp)
  addi sp, sp, 80
  ret
