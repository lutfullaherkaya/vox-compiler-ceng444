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
            # global temp
            # copy .tmp0, 19
  li t0, 19
  sd zero, 0(sp)
  sd t0, 8(sp)
            # arg .tmp0, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call .tmp1, f
  call f
  sd a0, 16(sp)
  sd a1, 24(sp)
            # copy global_temp, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  la t2, global_temp_type
  sd t0, (t2)
  sd t1, 8(t2)
            # endfun 
  ld ra, 40(sp)
  ld fp, 32(sp)
  addi sp, sp, 48
  ret

# fun f(a);
f:
  addi sp, sp, -32
  sd ra, 24(sp)
  sd fp, 16(sp)
  addi fp, sp, 32
            # param a, 0
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg_vox_lib a
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
global_temp_type:  .quad 0
global_temp_value: .quad 0

