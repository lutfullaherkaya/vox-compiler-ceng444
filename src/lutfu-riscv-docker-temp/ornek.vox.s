#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -136
  sd ra, 128(sp)
  sd s1, 120(sp)
  sd s2, 112(sp)
  sd s3, 104(sp)
  sd s4, 96(sp)
  sd s9, 88(sp)
  sd s10, 80(sp)
  sd s7, 72(sp)
  sd s8, 64(sp)
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
            # arg 1
  addi sp, sp, -32
  li a0, 0
  li a1, 1
            # arg 2
  li a2, 0
  li a3, 2
            # arg 3
  li a4, 0
  li a5, 3
            # arg 4
  li a6, 0
  li a7, 4
            # arg 5
  li s1, 0
  li s2, 5
  sd s1, 0(sp)
  sd s2, 8(sp)
            # arg 6
  li s3, 0
  li s4, 6
  sd s3, 16(sp)
  sd s4, 24(sp)
            # call .tmp3, "deneme"
  call deneme
  addi sp, sp, 32
            # arg .tmp3
  mv s3, a0  #backend: clearing a0 for return val
  mv s4, a1  #backend: clearing a1 for return val
            # call "__vox_print__"
  call __vox_print__
            # return 
  ld ra, 128(sp)
  ld s1, 120(sp)
  ld s2, 112(sp)
  ld s3, 104(sp)
  ld s4, 96(sp)
  ld s9, 88(sp)
  ld s10, 80(sp)
  ld s7, 72(sp)
  ld s8, 64(sp)
  addi sp, sp, 136
  li a0, 0
  ret

# fun deneme(a, b, c, d, e, f);
deneme:
  addi sp, sp, -384
            # param a
            # param b
            # param c
            # param d
            # param e
  ld s1, 384(sp)
  ld s2, 392(sp)
            # param f
  ld s3, 400(sp)
  ld s4, 408(sp)
            # copy x1, 5
  li s5, 0
  li s6, 5
            # copy x2, 5
  li s7, 0
  li s8, 5
            # copy x3, 5
  li s9, 0
  li s10, 5
            # copy x4, 5
  li t3, 0
  li t4, 5
            # copy x5, 5
  li t5, 0
  li t6, 5
            # copy x6, 5
    #backend: spilling e
  sd s1, 64(sp)
  sd s2, 72(sp)
  li s1, 0
  li s2, 5
            # copy x7, 5
    #backend: spilling f
  sd s3, 80(sp)
  sd s4, 88(sp)
  li s3, 0
  li s4, 5
            # copy x8, 5
    #backend: spilling x1
  sd s5, 96(sp)
  sd s6, 104(sp)
  li s5, 0
  li s6, 5
            # copy x9, 5
    #backend: spilling x2
  sd s7, 112(sp)
  sd s8, 120(sp)
  li s7, 0
  li s8, 5
            # copy x10, 5
    #backend: spilling x3
  sd s9, 128(sp)
  sd s10, 136(sp)
  li s9, 0
  li s10, 5
            # copy x11, 5
    #backend: spilling x4
  sd t3, 144(sp)
  sd t4, 152(sp)
  li t3, 0
  li t4, 5
            # copy x12, 5
    #backend: spilling x5
  sd t5, 160(sp)
  sd t6, 168(sp)
  li t5, 0
  li t6, 5
            # copy x13, 5
    #backend: spilling x6
  sd s1, 176(sp)
  sd s2, 184(sp)
  li s1, 0
  li s2, 5
            # copy x14, 5
    #backend: spilling x7
  sd s3, 192(sp)
  sd s4, 200(sp)
  li s3, 0
  li s4, 5
            # copy x15, 5
    #backend: spilling x8
  sd s5, 208(sp)
  sd s6, 216(sp)
  li s5, 0
  li s6, 5
            # copy x16, 5
    #backend: spilling x9
  sd s7, 224(sp)
  sd s8, 232(sp)
  li s7, 0
  li s8, 5
            # copy x17, 5
    #backend: spilling x10
  sd s9, 240(sp)
  sd s10, 248(sp)
  li s9, 0
  li s10, 5
            # copy x18, 5
    #backend: spilling x11
  sd t3, 256(sp)
  sd t4, 264(sp)
  li t3, 0
  li t4, 5
            # return e
  ld a0, 64(sp)
  ld a1, 72(sp)
  addi sp, sp, 384
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

