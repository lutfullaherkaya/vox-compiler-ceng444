#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -88
  sd ra, 80(sp)
  sd s1, 72(sp)
  sd s2, 64(sp)
  sd s3, 56(sp)
  sd s4, 48(sp)
            # copy global_i, 0
  li s1, 0
  li s2, 0
    #backend: spilling i at basic block end
  la t0, i_type
  sd s1, (t0)
  sd s2, 8(t0)
            # branch ".L_for_cond2"
  j .L_for_cond2
            # label ".L_for_body2"
.L_for_body2:
            # arg global_i
  ld a0, i_type
  ld a1, i_value
            # call "__vox_print__"
  call __vox_print__
            # arg global_i
  ld a0, i_type
  ld a1, i_value
            # call .tmp0, "isPrime"
  call isPrime
            # arg .tmp0
  mv s1, a0  #backend: clearing a0 for return val
  mv s2, a1  #backend: clearing a1 for return val
            # call "__vox_print__"
  call __vox_print__
            # add .tmp1, global_i, 1
  ld a0, i_type
  ld a1, i_value
  li a2, 0
  li a3, 1
  call __vox_add__
            # copy global_i, .tmp1
  mv a6, a0
  mv a7, a1
    #backend: spilling i at basic block end
  la t0, i_type
  sd a6, (t0)
  sd a7, 8(t0)
            # label ".L_for_cond2"
.L_for_cond2:
            # < .tmp2, global_i, 15
  ld s1, i_type
  ld s2, i_value
  li s3, 0
  li s4, 15
  li s5, 2
  slt s6, s2, s4
    #backend: spilling i at basic block end
  la t0, i_type
  sd s1, (t0)
  sd s2, 8(t0)
            # branch_if_true .tmp2, ".L_for_body2"
  bne s6, zero, .L_for_body2
            # return 
  ld ra, 80(sp)
  ld s1, 72(sp)
  ld s2, 64(sp)
  ld s3, 56(sp)
  ld s4, 48(sp)
  addi sp, sp, 88
  li a0, 0
  ret

# fun modulo(number, i);
modulo:
  addi sp, sp, -152
  sd ra, 144(sp)
  sd s1, 136(sp)
  sd s2, 128(sp)
  sd s3, 120(sp)
  sd s4, 112(sp)
  sd s5, 104(sp)
  sd s6, 96(sp)
  sd s7, 88(sp)
  sd s8, 80(sp)
            # param number
            # param i
            # div .tmp2, number, i
  mv s1, a0  #backend: clearing a0 for return val
  mv s2, a1  #backend: clearing a1 for return val
  call __vox_div__
            # mul .tmp1, .tmp2, i
  mv s3, a0  #backend: clearing a0 for return val
  mv s4, a1  #backend: clearing a1 for return val
  call __vox_mul__
            # sub .tmp0, number, .tmp1
  mv s5, a0  #backend: clearing a0 for return val
  mv s6, a1  #backend: clearing a1 for return val
  mv s7, a2  #backend: clearing a2 for arg
  mv s8, a3  #backend: clearing a3 for arg
  mv a0, s1
  mv a1, s2
  mv a2, s5
  mv a3, s6
  call __vox_sub__
            # return .tmp0
  ld ra, 144(sp)
  ld s1, 136(sp)
  ld s2, 128(sp)
  ld s3, 120(sp)
  ld s4, 112(sp)
  ld s5, 104(sp)
  ld s6, 96(sp)
  ld s7, 88(sp)
  ld s8, 80(sp)
  addi sp, sp, 152
  ret

# fun isPrime(number);
isPrime:
  addi sp, sp, -232
  sd ra, 224(sp)
  sd s1, 216(sp)
  sd s2, 208(sp)
  sd s3, 200(sp)
  sd s4, 192(sp)
  sd s5, 184(sp)
  sd s6, 176(sp)
  sd s7, 168(sp)
  sd s8, 160(sp)
  sd s9, 152(sp)
  sd s10, 144(sp)
            # param number
            # <= .tmp0, number, True
  li s1, 2
  li s2, 1
  li s3, 2
  slt s4, a1, s2
  sub t0, a1, s2
  seqz t0, t0
  or s4, s4, t0
            # copy isPrime, True
  li s5, 2
  li s6, 1
    #backend: spilling number at basic block end
  sd a0, 0(sp)
  sd a1, 8(sp)
    #backend: spilling isPrime at basic block end
  sd s5, 16(sp)
  sd s6, 24(sp)
            # branch_if_false .tmp0, ".L_endif1"
  beq s4, zero, .L_endif1
            # return False
  li a0, 2
  li a1, 0
  ld ra, 224(sp)
  ld s1, 216(sp)
  ld s2, 208(sp)
  ld s3, 200(sp)
  ld s4, 192(sp)
  ld s5, 184(sp)
  ld s6, 176(sp)
  ld s7, 168(sp)
  ld s8, 160(sp)
  ld s9, 152(sp)
  ld s10, 144(sp)
  addi sp, sp, 232
  ret
            # branch ".L_endelse1"
  j .L_endelse1
            # label ".L_endif1"
.L_endif1:
            # > .tmp1, number, 1
  li s1, 0
  li s2, 1
  ld s3, 0(sp)
  ld s4, 8(sp)
  li s5, 2
  slt s6, s2, s4
    #backend: spilling number at basic block end
  sd s3, 0(sp)
  sd s4, 8(sp)
            # branch_if_false .tmp1, ".L_endif2"
  beq s6, zero, .L_endif2
            # copy i, 2
  li s1, 0
  li s2, 2
    #backend: spilling i at basic block end
  sd s1, 64(sp)
  sd s2, 72(sp)
            # branch ".L_for_cond1"
  j .L_for_cond1
            # label ".L_for_body1"
.L_for_body1:
            # arg number
  ld a0, 0(sp)
  ld a1, 8(sp)
            # arg i
  ld a2, 64(sp)
  ld a3, 72(sp)
            # call .tmp3, "modulo"
  call modulo
            # == .tmp2, .tmp3, 0
  li a6, 0
  li a7, 0
  li a4, 2
  sub t0, a1, a7
  seqz a5, t0
            # branch_if_false .tmp2, ".L_endif3"
  beq a5, zero, .L_endif3
            # copy isPrime, False
  li s1, 2
  li s2, 0
    #backend: spilling isPrime at basic block end
  sd s1, 16(sp)
  sd s2, 24(sp)
            # label ".L_endif3"
.L_endif3:
            # add .tmp4, i, 1
  ld a0, 64(sp)
  ld a1, 72(sp)
  li a2, 0
  li a3, 1
  call __vox_add__
            # copy i, .tmp4
  mv s1, a0
  mv s2, a1
    #backend: spilling i at basic block end
  sd s1, 64(sp)
  sd s2, 72(sp)
            # label ".L_for_cond1"
.L_for_cond1:
            # < .tmp5, i, number
  ld s1, 64(sp)
  ld s2, 72(sp)
  ld s3, 0(sp)
  ld s4, 8(sp)
  li s5, 2
  slt s6, s2, s4
    #backend: spilling i at basic block end
  sd s1, 64(sp)
  sd s2, 72(sp)
    #backend: spilling number at basic block end
  sd s3, 0(sp)
  sd s4, 8(sp)
            # branch_if_true .tmp5, ".L_for_body1"
  bne s6, zero, .L_for_body1
            # label ".L_endif2"
.L_endif2:
            # label ".L_endelse1"
.L_endelse1:
            # return isPrime
  ld a0, 16(sp)
  ld a1, 24(sp)
  ld ra, 224(sp)
  ld s1, 216(sp)
  ld s2, 208(sp)
  ld s3, 200(sp)
  ld s4, 192(sp)
  ld s5, 184(sp)
  ld s6, 176(sp)
  ld s7, 168(sp)
  ld s8, 160(sp)
  ld s9, 152(sp)
  ld s10, 144(sp)
  addi sp, sp, 232
  ret

  .data
i_type:   .quad 0
i_value:  .quad 0

