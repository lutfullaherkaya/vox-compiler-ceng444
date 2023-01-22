#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
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
  sd s9, 24(sp)
  sd s10, 16(sp)
            # arg 1
  addi sp, sp, -144
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
            # arg 7
  li s5, 0
  li s6, 7
  sd s5, 32(sp)
  sd s6, 40(sp)
            # arg 8
  li s7, 0
  li s8, 8
  sd s7, 48(sp)
  sd s8, 56(sp)
            # arg 9
  li s9, 0
  li s10, 9
  sd s9, 64(sp)
  sd s10, 72(sp)
            # arg 10
  li t3, 0
  li t4, 10
  sd t3, 80(sp)
  sd t4, 88(sp)
            # arg 11
  li t5, 0
  li t6, 11
  sd t5, 96(sp)
  sd t6, 104(sp)
            # arg 12
  li s1, 0
  li s2, 12
  sd s1, 112(sp)
  sd s2, 120(sp)
            # arg 13
  li s3, 0
  li s4, 13
  sd s3, 128(sp)
  sd s4, 136(sp)
            # call .tmp0, "a"
  call a
  addi sp, sp, 144
            # copy global_temp, .tmp0
  mv s3, a0
  mv s4, a1
            # return 
  la t0, temp_type  #backend: global spill
  sd s3, (t0)
  sd s4, 8(t0)
  ld ra, 96(sp)
  ld s1, 88(sp)
  ld s2, 80(sp)
  ld s3, 72(sp)
  ld s4, 64(sp)
  ld s5, 56(sp)
  ld s6, 48(sp)
  ld s7, 40(sp)
  ld s8, 32(sp)
  ld s9, 24(sp)
  ld s10, 16(sp)
  addi sp, sp, 104
  li a0, 0
  ret

# fun a(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
a:
  addi sp, sp, -296
  sd ra, 288(sp)
  sd s1, 280(sp)
  sd s2, 272(sp)
  sd s3, 264(sp)
  sd s4, 256(sp)
  sd s5, 248(sp)
  sd s6, 240(sp)
  sd s7, 232(sp)
  sd s8, 224(sp)
  sd s9, 216(sp)
  sd s10, 208(sp)
            # param p1
            # param p2
            # param p3
            # param p4
            # param p5
  ld s1, 296(sp)
  ld s2, 304(sp)
            # param p6
  ld s3, 312(sp)
  ld s4, 320(sp)
            # param p7
  ld s5, 328(sp)
  ld s6, 336(sp)
            # param p8
  ld s7, 344(sp)
  ld s8, 352(sp)
            # param p9
  ld s9, 360(sp)
  ld s10, 368(sp)
            # param p10
  ld t3, 376(sp)
  ld t4, 384(sp)
            # param p11
  ld t5, 392(sp)
  ld t6, 400(sp)
            # param p12
    #backend: spilling p5
  sd s1, 64(sp)
  sd s2, 72(sp)
  ld s1, 408(sp)
  ld s2, 416(sp)
            # param p13
    #backend: spilling p6
  sd s3, 80(sp)
  sd s4, 88(sp)
  ld s3, 424(sp)
  ld s4, 432(sp)
            # arg p1
    #backend: spilling p7
  sd s5, 96(sp)
  sd s6, 104(sp)
  mv s5, a0  #backend: clearing a0 for return val
  mv s6, a1  #backend: clearing a1 for return val
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a2, 0(sp)
  sd a3, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd t3, 48(sp)
  sd t4, 56(sp)
  sd t5, 64(sp)
  sd t6, 72(sp)
  call __vox_print__
  ld a2, 0(sp)
  ld a3, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld t3, 48(sp)
  ld t4, 56(sp)
  ld t5, 64(sp)
  ld t6, 72(sp)
  addi sp, sp, 80
            # arg p2
  mv a0, a2
  mv a1, a3
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a4, 0(sp)
  sd a5, 8(sp)
  sd a6, 16(sp)
  sd a7, 24(sp)
  sd t3, 32(sp)
  sd t4, 40(sp)
  sd t5, 48(sp)
  sd t6, 56(sp)
  sd a2, 64(sp)
  sd a3, 72(sp)
  call __vox_print__
  ld a4, 0(sp)
  ld a5, 8(sp)
  ld a6, 16(sp)
  ld a7, 24(sp)
  ld t3, 32(sp)
  ld t4, 40(sp)
  ld t5, 48(sp)
  ld t6, 56(sp)
  ld a2, 64(sp)
  ld a3, 72(sp)
  addi sp, sp, 80
            # arg p3
  mv a0, a4
  mv a1, a5
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a6, 0(sp)
  sd a7, 8(sp)
  sd t3, 16(sp)
  sd t4, 24(sp)
  sd t5, 32(sp)
  sd t6, 40(sp)
  sd a2, 48(sp)
  sd a3, 56(sp)
  sd a4, 64(sp)
  sd a5, 72(sp)
  call __vox_print__
  ld a6, 0(sp)
  ld a7, 8(sp)
  ld t3, 16(sp)
  ld t4, 24(sp)
  ld t5, 32(sp)
  ld t6, 40(sp)
  ld a2, 48(sp)
  ld a3, 56(sp)
  ld a4, 64(sp)
  ld a5, 72(sp)
  addi sp, sp, 80
            # arg p4
  mv a0, a6
  mv a1, a7
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p5
  ld a0, 64(sp)
  ld a1, 72(sp)
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p6
  ld a0, 80(sp)
  ld a1, 88(sp)
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p7
  ld a0, 96(sp)
  ld a1, 104(sp)
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p8
  mv a0, s7
  mv a1, s8
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p9
  mv a0, s9
  mv a1, s10
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a2, 32(sp)
  sd a3, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  sd a6, 64(sp)
  sd a7, 72(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a2, 32(sp)
  ld a3, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  ld a6, 64(sp)
  ld a7, 72(sp)
  addi sp, sp, 80
            # arg p10
  mv a0, t3
  mv a1, t4
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd t5, 0(sp)
  sd t6, 8(sp)
  sd a2, 16(sp)
  sd a3, 24(sp)
  sd a4, 32(sp)
  sd a5, 40(sp)
  sd a6, 48(sp)
  sd a7, 56(sp)
  sd t3, 64(sp)
  sd t4, 72(sp)
  call __vox_print__
  ld t5, 0(sp)
  ld t6, 8(sp)
  ld a2, 16(sp)
  ld a3, 24(sp)
  ld a4, 32(sp)
  ld a5, 40(sp)
  ld a6, 48(sp)
  ld a7, 56(sp)
  ld t3, 64(sp)
  ld t4, 72(sp)
  addi sp, sp, 80
            # arg p11
  mv a0, t5
  mv a1, t6
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a2, 0(sp)
  sd a3, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd t3, 48(sp)
  sd t4, 56(sp)
  sd t5, 64(sp)
  sd t6, 72(sp)
  call __vox_print__
  ld a2, 0(sp)
  ld a3, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld t3, 48(sp)
  ld t4, 56(sp)
  ld t5, 64(sp)
  ld t6, 72(sp)
  addi sp, sp, 80
            # arg p12
  mv a0, s1
  mv a1, s2
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a2, 0(sp)
  sd a3, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd t3, 48(sp)
  sd t4, 56(sp)
  sd t5, 64(sp)
  sd t6, 72(sp)
  call __vox_print__
  ld a2, 0(sp)
  ld a3, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld t3, 48(sp)
  ld t4, 56(sp)
  ld t5, 64(sp)
  ld t6, 72(sp)
  addi sp, sp, 80
            # arg p13
  mv a0, s3
  mv a1, s4
            # call "__vox_print__"
    #backend: saving caller saved regs
  addi sp, sp, -80
  sd a2, 0(sp)
  sd a3, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd t3, 48(sp)
  sd t4, 56(sp)
  sd t5, 64(sp)
  sd t6, 72(sp)
  call __vox_print__
  ld a2, 0(sp)
  ld a3, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld t3, 48(sp)
  ld t4, 56(sp)
  ld t5, 64(sp)
  ld t6, 72(sp)
  addi sp, sp, 80
            # return 
  ld ra, 288(sp)
  ld s1, 280(sp)
  ld s2, 272(sp)
  ld s3, 264(sp)
  ld s4, 256(sp)
  ld s5, 248(sp)
  ld s6, 240(sp)
  ld s7, 232(sp)
  ld s8, 224(sp)
  ld s9, 216(sp)
  ld s10, 208(sp)
  addi sp, sp, 296
  ret

  .data
temp_type:   .quad 0
temp_value:  .quad 0

