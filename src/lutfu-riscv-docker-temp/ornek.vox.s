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
  mv t3, a0
  mv t4, a1
            # arg .tmp0
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
  mv t3, a0
  mv t4, a1
            # param a2
  mv t5, a2
  mv t6, a3
            # param a3
  mv s1, a4
  mv s2, a5
            # param a4
  mv s3, a6
  mv s4, a7
            # param a5
  ld s5, 264(sp)
  ld s6, 272(sp)
            # param a6
  ld s7, 280(sp)
  ld s8, 288(sp)
            # copy x, a1
            # copy y, a2
            # copy z, a3
            # copy t, a4
            # add .tmp2, x, y
  mv a0, t3
  mv a1, t4
  mv a2, t5
  mv a3, t6
  call __vox_add__
  mv s9, a0
  mv s10, a1
            # add .tmp1, .tmp2, z
  mv a0, s9
  mv a1, s10
  mv a2, s1
  mv a3, s2
  call __vox_add__
  mv s5, a0
  mv s6, a1
            # add .tmp0, .tmp1, t
  mv a0, s5
  mv a1, s6
  mv a2, s3
  mv a3, s4
  call __vox_add__
  mv s7, a0
  mv s8, a1
            # arg .tmp0
  mv a0, s7
  mv a1, s8
            # call __vox_print__
  addi sp, sp, -32
  sd t3, 0(sp)
  sd t4, 8(sp)
  sd t5, 16(sp)
  sd t6, 24(sp)
  call __vox_print__
  ld t3, 0(sp)
  ld t4, 8(sp)
  ld t5, 16(sp)
  ld t6, 24(sp)
  addi sp, sp, 32
            # add .tmp5, x, y
  mv a0, t3
  mv a1, t4
  mv a2, t5
  mv a3, t6
  call __vox_add__
  mv t3, a0
  mv t4, a1
            # add .tmp4, .tmp5, z
  mv a0, t3
  mv a1, t4
  mv a2, s1
  mv a3, s2
  call __vox_add__
  mv s9, a0
  mv s10, a1
            # add .tmp3, .tmp4, t
  mv a0, s9
  mv a1, s10
  mv a2, s3
  mv a3, s4
  call __vox_add__
  mv s5, a0
  mv s6, a1
            # return .tmp3
  mv a0, s5
  mv a1, s6
  ld ra, 256(sp)
  addi sp, sp, 264
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

