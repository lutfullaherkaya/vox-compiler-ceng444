#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # global a
            # global b
            # copy global_b, global_a
  ld t3, a_type
  ld t4, a_value
            # arg global_b
  mv a0, t3
  mv a1, t4
            # call __vox_print__
  la t0, a_type
  sd t3, (t0)
  sd t4, 8(t0)
  la t0, b_type
  sd t3, (t0)
  sd t4, 8(t0)
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
  li t5, 0
  li t6, 5
  sd t5, 0(sp)
  sd t6, 8(sp)
            # arg 6
  li t5, 0
  li t6, 6
  sd t5, 16(sp)
  sd t6, 24(sp)
            # call .tmp0, cok_parali
  call cok_parali
  addi sp, sp, 32
            # arg .tmp0
  mv t3, a0
  mv t4, a1
  mv a0, t3
  mv a1, t4
            # call __vox_print__
  addi sp, sp, -16
  sd t3, 0(sp)
  sd t4, 8(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  addi sp, sp, 16
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun cok_parali(a1, a2, a3, a4, a5, a6);
cok_parali:
  addi sp, sp, -264
  sd ra, 256(sp)
            # param a1
            # param a2
            # param a3
            # param a4
            # param a5
  ld t3, 264(sp)
  ld t4, 272(sp)
            # param a6
  ld t5, 280(sp)
  ld t6, 288(sp)
            # copy x, a1
            # copy y, a2
            # copy z, a3
            # copy t, a4
            # add .tmp2, x, y
  mv s1, a0
  mv s2, a1
  mv s3, a2
  mv s4, a3
  mv a0, s1
  mv a1, s2
  mv a2, s3
  mv a3, s4
  call __vox_add__
            # add .tmp1, .tmp2, z
  mv s5, a0
  mv s6, a1
  mv a0, s5
  mv a1, s6
  mv a2, a4
  mv a3, a5
  call __vox_add__
            # add .tmp0, .tmp1, t
  mv s7, a0
  mv s8, a1
  mv a0, s7
  mv a1, s8
  mv a2, a6
  mv a3, a7
  call __vox_add__
            # arg .tmp0
  mv s9, a0
  mv s10, a1
  mv a0, s9
  mv a1, s10
            # call __vox_print__
  addi sp, sp, -64
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  sd a4, 32(sp)
  sd a5, 40(sp)
  sd a6, 48(sp)
  sd a7, 56(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  ld a4, 32(sp)
  ld a5, 40(sp)
  ld a6, 48(sp)
  ld a7, 56(sp)
  addi sp, sp, 64
            # add .tmp5, x, y
  mv a0, s1
  mv a1, s2
  mv a2, s3
  mv a3, s4
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
  ld ra, 256(sp)
  addi sp, sp, 264
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

