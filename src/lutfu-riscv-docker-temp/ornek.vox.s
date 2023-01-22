#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -72
  sd ra, 64(sp)
  sd s1, 56(sp)
  sd s2, 48(sp)
  sd s3, 40(sp)
  sd s4, 32(sp)
  sd s5, 24(sp)
  sd s6, 16(sp)
            # < .tmp0, global_dogru, 4
  ld s1, dogru_type
  ld s2, dogru_value
  li s3, 0
  li s4, 4
  li s5, 2
  slt s6, s2, s4
            # arg .tmp0
  mv a0, s5
  mv a1, s6
            # call "__vox_print__"
  la t0, dogru_type  #backend: global spill
  sd s1, (t0)
  sd s2, 8(t0)
  call __vox_print__
            # return 
  ld ra, 64(sp)
  ld s1, 56(sp)
  ld s2, 48(sp)
  ld s3, 40(sp)
  ld s4, 32(sp)
  ld s5, 24(sp)
  ld s6, 16(sp)
  addi sp, sp, 72
  li a0, 0
  ret

# fun printer();
printer:
  addi sp, sp, -8
  sd ra, 0(sp)
            # arg "sa"
  li a0, 3
  la a1, .L_string1
            # call "__vox_print__"
  call __vox_print__
            # return 
  ld ra, 0(sp)
  addi sp, sp, 8
  ret

  .data
dogru_type:   .quad 2
dogru_value:  .quad 1

.L_string1:  .string "sa"
