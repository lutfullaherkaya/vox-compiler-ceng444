#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -112
  sd ra, 104(sp)
            # global a
            # global b
            # copy global_b, global_a
  ld s1, a_type
  ld s2, a_value
            # arg global_b
    #b: clear first 1 args
  sd s1, 96(sp)  #b: callee save s1
  sd s2, 88(sp)  #b: callee save s2
  mv a0, s1
  mv a1, s2
            # call __vox_print__
  la t0, a_type  #b: global spill
  sd s1, (t0)
  sd s2, 8(t0)
  la t0, b_type  #b: global spill
  sd s1, (t0)
  sd s2, 8(t0)
  call __vox_print__
            # arg global_a
    #b: clear first 1 args
  ld a0, a_type
  ld a1, a_value
            # call __vox_print__
  call __vox_print__
            # arg 1
    #b: clear first 6 args
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
  li s3, 0
  li s4, 5
  sd s3, 0(sp)
  sd s4, 8(sp)
            # arg 6
  li s3, 0
  li s4, 6
  sd s3, 16(sp)
  sd s4, 24(sp)
            # call .tmp0, cok_parali
  call cok_parali
  addi sp, sp, 32
            # arg .tmp0
    #b: clear first 1 args
  mv s1, a0  #b: clearing arg a0
  mv s2, a1  #b: clearing arg a1
  mv a0, s1
  mv a1, s2
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 104(sp)
    #b: callee load ['s1', 's2']
  ld s1, 96(sp)
  ld s2, 88(sp)
  addi sp, sp, 112
  li a0, 0
  ret

# fun cok_parali(a1, a2, a3, a4, a5, a6);
cok_parali:
  addi sp, sp, -352
  sd ra, 344(sp)
            # param a1
            # param a2
            # param a3
            # param a4
            # param a5
  sd s1, 336(sp)  #b: callee save s1
  sd s2, 328(sp)  #b: callee save s2
  ld s1, 352(sp)
  ld s2, 360(sp)
            # param a6
  sd s3, 320(sp)  #b: callee save s3
  sd s4, 312(sp)  #b: callee save s4
  ld s3, 368(sp)
  ld s4, 376(sp)
            # copy x, a1
            # copy y, a2
            # copy z, a3
            # copy t, a4
            # arg x
    #b: clear first 2 args
  mv s5, a0  #b: clearing arg a0
  mv s6, a1  #b: clearing arg a1
  mv s7, a2  #b: clearing arg a2
  mv s8, a3  #b: clearing arg a3
  sd s5, 304(sp)  #b: callee save s5
  sd s6, 296(sp)  #b: callee save s6
  mv a0, s5
  mv a1, s6
            # arg y
  sd s7, 288(sp)  #b: callee save s7
  sd s8, 280(sp)  #b: callee save s8
  mv a2, s7
  mv a3, s8
            # call .tmp2, __vox_add__
  addi sp, sp, -32
  sd a4, 0(sp)
  sd a5, 8(sp)
  sd a6, 16(sp)
  sd a7, 24(sp)
  call __vox_add__
  ld a4, 0(sp)
  ld a5, 8(sp)
  ld a6, 16(sp)
  ld a7, 24(sp)
  addi sp, sp, 32
            # arg .tmp2
    #b: clear first 2 args
  mv t5, a0  #b: clearing arg a0
  mv t6, a1  #b: clearing arg a1
  mv a0, t5
  mv a1, t6
            # arg z
  mv a2, a4
  mv a3, a5
            # call .tmp1, __vox_add__
  addi sp, sp, -48
  sd a6, 0(sp)
  sd a7, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a4, 32(sp)
  sd a5, 40(sp)
  call __vox_add__
  ld a6, 0(sp)
  ld a7, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a4, 32(sp)
  ld a5, 40(sp)
  addi sp, sp, 48
            # arg .tmp1
    #b: clear first 2 args
  mv s9, a0  #b: clearing arg a0
  mv s10, a1  #b: clearing arg a1
  sd s9, 272(sp)  #b: callee save s9
  sd s10, 264(sp)  #b: callee save s10
  mv a0, s9
  mv a1, s10
            # arg t
  mv a2, a6
  mv a3, a7
            # call .tmp0, __vox_add__
  addi sp, sp, -48
  sd t5, 0(sp)
  sd t6, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  call __vox_add__
  ld t5, 0(sp)
  ld t6, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  addi sp, sp, 48
            # arg .tmp0
    #b: clear first 1 args
  mv a2, a0  #b: clearing arg a0
  mv a3, a1  #b: clearing arg a1
  mv a0, a2
  mv a1, a3
            # call __vox_print__
  addi sp, sp, -64
  sd t5, 0(sp)
  sd t6, 8(sp)
  sd a4, 16(sp)
  sd a5, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd a2, 48(sp)
  sd a3, 56(sp)
  call __vox_print__
  ld t5, 0(sp)
  ld t6, 8(sp)
  ld a4, 16(sp)
  ld a5, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld a2, 48(sp)
  ld a3, 56(sp)
  addi sp, sp, 64
            # arg x
    #b: clear first 2 args
  mv t3, a2  #b: clearing arg a2
  mv t4, a3  #b: clearing arg a3
  mv a0, s5
  mv a1, s6
            # arg y
  mv a2, s7
  mv a3, s8
            # call .tmp5, __vox_add__
  addi sp, sp, -64
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a4, 32(sp)
  sd a5, 40(sp)
  sd a6, 48(sp)
  sd a7, 56(sp)
  call __vox_add__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a4, 32(sp)
  ld a5, 40(sp)
  ld a6, 48(sp)
  ld a7, 56(sp)
  addi sp, sp, 64
            # arg .tmp5
    #b: clear first 2 args
    #b: spilling .tmp0
  sd t3, 160(sp)
  sd t4, 168(sp)
  mv t3, a0  #b: clearing arg a0
  mv t4, a1  #b: clearing arg a1
  mv a0, t3
  mv a1, t4
            # arg z
  mv a2, a4
  mv a3, a5
            # call .tmp4, __vox_add__
  addi sp, sp, -64
  sd t5, 0(sp)
  sd t6, 8(sp)
  sd a6, 16(sp)
  sd a7, 24(sp)
  sd t3, 32(sp)
  sd t4, 40(sp)
  sd a4, 48(sp)
  sd a5, 56(sp)
  call __vox_add__
  ld t5, 0(sp)
  ld t6, 8(sp)
  ld a6, 16(sp)
  ld a7, 24(sp)
  ld t3, 32(sp)
  ld t4, 40(sp)
  ld a4, 48(sp)
  ld a5, 56(sp)
  addi sp, sp, 64
            # arg .tmp4
    #b: clear first 2 args
    #b: spilling a5
  sd s1, 64(sp)
  sd s2, 72(sp)
  mv s1, a0  #b: clearing arg a0
  mv s2, a1  #b: clearing arg a1
  mv a0, s1
  mv a1, s2
            # arg t
  mv a2, a6
  mv a3, a7
            # call .tmp3, __vox_add__
  addi sp, sp, -64
  sd t5, 0(sp)
  sd t6, 8(sp)
  sd t3, 16(sp)
  sd t4, 24(sp)
  sd a4, 32(sp)
  sd a5, 40(sp)
  sd a6, 48(sp)
  sd a7, 56(sp)
  call __vox_add__
  ld t5, 0(sp)
  ld t6, 8(sp)
  ld t3, 16(sp)
  ld t4, 24(sp)
  ld a4, 32(sp)
  ld a5, 40(sp)
  ld a6, 48(sp)
  ld a7, 56(sp)
  addi sp, sp, 64
            # return .tmp3
  mv a0, a0
  mv a1, a1
  ld ra, 344(sp)
    #b: callee load ['s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10']
  ld s1, 336(sp)
  ld s2, 328(sp)
  ld s3, 320(sp)
  ld s4, 312(sp)
  ld s5, 304(sp)
  ld s6, 296(sp)
  ld s7, 288(sp)
  ld s8, 280(sp)
  ld s9, 272(sp)
  ld s10, 264(sp)
  addi sp, sp, 352
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

