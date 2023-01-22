#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # call .tmp0, "x"
  call x
            # arg .tmp0
    #backend: clear first 1 args
  mv a6, a0  #backend: clearing arg a0
  mv a7, a1  #backend: clearing arg a1
  mv a0, a6
  mv a1, a7
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -16
  sd a6, 0(sp)
  sd a7, 8(sp)
  call __vox_print__
  ld a6, 0(sp)
  ld a7, 8(sp)
  addi sp, sp, 16
            # arg global_global
  ld a0, global_type
  ld a1, global_value
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

# fun x();
x:
  addi sp, sp, -104
  sd ra, 96(sp)
  sd s1, 88(sp)
  sd s2, 80(sp)
  sd s3, 72(sp)
  sd s4, 64(sp)
  sd s5, 56(sp)
  sd s6, 48(sp)
  sd s7, 40(sp)
  sd s8, 32(sp)
            # copy local, 6
  li s3, 0
  li s4, 6
  mv s1, s3
  mv s2, s4
            # copy global_global, 12
  li s7, 0
  li s8, 12
  mv s5, s7
  mv s6, s8
            # return global_global
  mv a0, s5
  mv a1, s6
  la t0, global_type  #backend: global spill
  sd s5, (t0)
  sd s6, 8(t0)
  ld ra, 96(sp)
  ld s1, 88(sp)
  ld s2, 80(sp)
  ld s3, 72(sp)
  ld s4, 64(sp)
  ld s5, 56(sp)
  ld s6, 48(sp)
  ld s7, 40(sp)
  ld s8, 32(sp)
  addi sp, sp, 104
  ret

  .data
global_type:   .quad 0
global_value:  .quad 5

