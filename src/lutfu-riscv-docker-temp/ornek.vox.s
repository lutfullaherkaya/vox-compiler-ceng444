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
  sd s1, 96(sp)
  sd s2, 88(sp)
  mv a0, s1
  mv a1, s2
            # call __vox_print__
  la t0, a_type
  sd s1, (t0)
  sd s2, 8(t0)
  la t0, b_type
  sd s1, (t0)
  sd s2, 8(t0)
  call __vox_print__
            # arg global_a
  ld a0, a_type
  ld a1, a_value
            # call __vox_print__
  call __vox_print__
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
  mv s1, a0
  mv s2, a1
  mv a0, s1
  mv a1, s2
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 104(sp)
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
  ld s1, 352(sp)
  ld s2, 360(sp)
            # param a6
  ld s3, 368(sp)
  ld s4, 376(sp)
            # copy x, a1
            # copy y, a2
            # copy z, a3
            # copy t, a4
            # add .tmp2, x, y
  mv s5, a0
  mv s6, a1
  mv s7, a2
  mv s8, a3
  sd s5, 304(sp)
  sd s6, 296(sp)
  mv a0, s5
  mv a1, s6
  sd s7, 288(sp)
  sd s8, 280(sp)
  mv a2, s7
  mv a3, s8
  call __vox_add__
            # add .tmp1, .tmp2, z
  mv s9, a0
  mv s10, a1
  sd s9, 272(sp)
  sd s10, 264(sp)
  mv a0, s9
  mv a1, s10
  mv a2, a4
  mv a3, a5
  call __vox_add__
            # add .tmp0, .tmp1, t
  mv t3, a0
  mv t4, a1
  mv a0, t3
  mv a1, t4
  mv a2, a6
  mv a3, a7
  call __vox_add__
            # arg .tmp0
  mv t5, a0
  mv t6, a1
  mv a0, t5
  mv a1, t6
            # call __vox_print__
  addi sp, sp, -64
  sd a4, 0(sp)
  sd a5, 8(sp)
  sd t3, 16(sp)
  sd t4, 24(sp)
  sd a6, 32(sp)
  sd a7, 40(sp)
  sd t5, 48(sp)
  sd t6, 56(sp)
  call __vox_print__
  ld a4, 0(sp)
  ld a5, 8(sp)
  ld t3, 16(sp)
  ld t4, 24(sp)
  ld a6, 32(sp)
  ld a7, 40(sp)
  ld t5, 48(sp)
  ld t6, 56(sp)
  addi sp, sp, 64
            # add .tmp5, x, y
  mv a0, s5
  mv a1, s6
  mv a2, s7
  mv a3, s8
  call __vox_add__
            # add .tmp4, .tmp5, z
  mv a2, a0
  mv a3, a1
  mv a0, a2
  mv a1, a3
  mv a0, a0
  mv a1, a1
  mv a2, a4
  mv a3, a5
  call __vox_add__
            # add .tmp3, .tmp4, t
  mv a2, a0
  mv a3, a1
  mv a0, a2
  mv a1, a3
  mv a0, a0
  mv a1, a1
  mv a2, a6
  mv a3, a7
  call __vox_add__
            # return .tmp3
  mv a0, a0
  mv a1, a1
  ld ra, 344(sp)
  ld s5, 336(sp)
  ld s6, 328(sp)
  ld s7, 320(sp)
  ld s8, 312(sp)
  ld s9, 304(sp)
  ld s10, 296(sp)
  addi sp, sp, 352
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

