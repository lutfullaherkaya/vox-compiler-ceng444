#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -128
  sd ra, 120(sp)
            # global i
            # copy global_i, 0
  sd s1, 112(sp)  #b: callee save s1
  sd s2, 104(sp)  #b: callee save s2
  sd s3, 96(sp)  #b: callee save s3
  sd s4, 88(sp)  #b: callee save s4
  li s3, 0
  li s4, 0
  mv s1, s3
  mv s2, s4
            # branch .L_for_cond1
  j .L_for_cond1
            # label .L_for_body1
.L_for_body1:
            # arg global_i
    #b: clear first 1 args
  mv a0, s1
  mv a1, s2
            # call __vox_print__
  la t0, i_type  #b: global spill
  sd s1, (t0)
  sd s2, 8(t0)
  call __vox_print__
            # arg global_i
    #b: clear first 2 args
  ld a0, i_type
  ld a1, i_value
            # arg 1
  li a2, 0
  li a3, 1
            # call .tmp0, __vox_add__
  call __vox_add__
            # copy global_i, .tmp0
  sd s5, 80(sp)  #b: callee save s5
  sd s6, 72(sp)  #b: callee save s6
  mv s5, a0
  mv s6, a1
            # label .L_for_cond1
.L_for_cond1:
            # < .tmp1, global_i, 5
  sd s7, 64(sp)  #b: callee save s7
  sd s8, 56(sp)  #b: callee save s8
  li s7, 0
  li s8, 5
  sd s9, 48(sp)  #b: callee save s9
  sd s10, 40(sp)  #b: callee save s10
  li s9, 2
  slt s10, s6, s8
            # branch_if_true .tmp1, .L_for_body1
  bne s10, zero, .L_for_body1
            # return 
  la t0, i_type  #b: global spill
  sd s5, (t0)
  sd s6, 8(t0)
  ld ra, 120(sp)
    #b: callee load ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10']
  ld s1, 112(sp)
  ld s2, 104(sp)
  ld s3, 96(sp)
  ld s4, 88(sp)
  ld s5, 80(sp)
  ld s6, 72(sp)
  ld s7, 64(sp)
  ld s8, 56(sp)
  ld s9, 48(sp)
  ld s10, 40(sp)
  addi sp, sp, 128
  li a0, 0
  ret

  .data
i_type:   .quad 0
i_value:  .quad 0

