#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # copy global_b, global_a
  ld t0, a_type
  ld t1, a_value
  la t2, b_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg 22
  li a0, 0
  li a1, 22
            # call .tmp0, x
  call x
  sd a0, 0(sp)
  sd a1, 8(sp)
            # arg .tmp0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 16(sp)
  addi sp, sp, 24
  li a0, 0
  ret

# fun x(ab);
x:
  addi sp, sp, -56
  sd ra, 48(sp)
            # param ab
  sd a0, 0(sp)
  sd a1, 8(sp)
            # add .tmp0, 6, ab
  li a0, 0
  li a1, 6
  ld a2, 0(sp)
  ld a3, 8(sp)
  call __vox_add__
  sd a0, 32(sp)
  sd a1, 40(sp)
            # copy a, 6
  li t0, 0
  li t1, 6
  sd t0, 16(sp)
  sd t1, 24(sp)
            # return .tmp0
  ld a0, 32(sp)
  ld a1, 40(sp)
  ld ra, 48(sp)
  addi sp, sp, 56
  ret

# fun main.fake();
main.fake:
            # return 0
  li a0, 0
  li a1, 0
  ret

  .data
a_type:   .quad 0
a_value:  .quad 5

b_type:   .quad 0
b_value:  .quad 0

ab_type:   .quad 0
ab_value:  .quad 55

