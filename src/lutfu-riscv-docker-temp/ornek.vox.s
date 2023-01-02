#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -144
  sd ra, 136(sp)
  sd fp, 128(sp)
  addi fp, sp, 144
            # global temp
            # copy .tmp0, 19
  li t0, 19
  sd zero, 0(sp)
  sd t0, 8(sp)
            # arg .tmp0, 0
  ld a0, 0(sp)
  ld a1, 8(sp)
            # copy .tmp2, 0
  li t0, 0
  sd zero, 32(sp)
  sd t0, 40(sp)
            # copy .tmp3, 1919
  li t0, 1919
  sd zero, 48(sp)
  sd t0, 56(sp)
            # - .tmp1, .tmp2, .tmp3
  ld t0, 40(sp)
  ld t1, 56(sp)
  sub t0, t0, t1
  sd zero, 16(sp)
  sd t0, 24(sp)
            # arg .tmp1, 1
  ld a2, 16(sp)
  ld a3, 24(sp)
            # copy .tmp4, 191919
  li t0, 191919
  sd zero, 64(sp)
  sd t0, 72(sp)
            # arg .tmp4, 2
  ld a4, 64(sp)
  ld a5, 72(sp)
            # copy .tmp5, 123
  li t0, 123
  sd zero, 80(sp)
  sd t0, 88(sp)
            # arg .tmp5, 3
  ld a6, 80(sp)
  ld a7, 88(sp)
            # copy .tmp6, 22
  li t0, 22
  sd zero, 96(sp)
  sd t0, 104(sp)
            # arg .tmp6, 4
            # call .tmp7, f
  call f
  sd a0, 112(sp)
  sd a1, 120(sp)
            # copy global_temp, .tmp7
  ld t0, 112(sp)
  ld t1, 120(sp)
  la t2, global_temp_type
  sd t0, (t2)
  sd t1, 8(t2)
            # endfun 
  ld ra, 136(sp)
  ld fp, 128(sp)
  addi sp, sp, 144
  ret

# fun f(a, b, c, d, e);
f:
  addi sp, sp, -96
  sd ra, 88(sp)
  sd fp, 80(sp)
  addi fp, sp, 96
            # param a, 0
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param b, 1
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param c, 2
  sd a4, 32(sp)
  sd a5, 40(sp)
            # param d, 3
  sd a6, 48(sp)
  sd a7, 56(sp)
            # param e, 4
            # arg_vox_lib a
  addi sp, sp, -16
  ld t0, 16(sp)
  ld t1, 24(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib b
  addi sp, sp, -16
  ld t0, 32(sp)
  ld t1, 40(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib c
  addi sp, sp, -16
  ld t0, 48(sp)
  ld t1, 56(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib d
  addi sp, sp, -16
  ld t0, 64(sp)
  ld t1, 72(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib e
  addi sp, sp, -16
  ld t0, 80(sp)
  ld t1, 88(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # endfun 
  ld ra, 88(sp)
  ld fp, 80(sp)
  addi sp, sp, 96
  ret

  .data
global_temp_type:  .quad 0
global_temp_value: .quad 0

