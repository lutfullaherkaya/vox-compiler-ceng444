#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -240
  sd ra, 232(sp)
  sd fp, 224(sp)
  addi fp, sp, 240
            # global temp
            # arg_count 13
  addi sp, sp, -144
            # copy .tmp0, 1
  li t0, 1
  sd zero, 144(sp)
  sd t0, 152(sp)
            # arg .tmp0, 0
  ld a0, 144(sp)
  ld a1, 152(sp)
            # copy .tmp1, 2
  li t0, 2
  sd zero, 160(sp)
  sd t0, 168(sp)
            # arg .tmp1, 1
  ld a2, 160(sp)
  ld a3, 168(sp)
            # copy .tmp2, 3
  li t0, 3
  sd zero, 176(sp)
  sd t0, 184(sp)
            # arg .tmp2, 2
  ld a4, 176(sp)
  ld a5, 184(sp)
            # copy .tmp3, 4
  li t0, 4
  sd zero, 192(sp)
  sd t0, 200(sp)
            # arg .tmp3, 3
  ld a6, 192(sp)
  ld a7, 200(sp)
            # copy .tmp4, 5
  li t0, 5
  sd zero, 208(sp)
  sd t0, 216(sp)
            # arg .tmp4, 4
  ld t0, 208(sp)
  ld t1, 216(sp)
  sd t0, 0(sp)
  sd t1, 8(sp)
            # copy .tmp5, 6
  li t0, 6
  sd zero, 224(sp)
  sd t0, 232(sp)
            # arg .tmp5, 5
  ld t0, 224(sp)
  ld t1, 232(sp)
  sd t0, 16(sp)
  sd t1, 24(sp)
            # copy .tmp6, 7
  li t0, 7
  sd zero, 240(sp)
  sd t0, 248(sp)
            # arg .tmp6, 6
  ld t0, 240(sp)
  ld t1, 248(sp)
  sd t0, 32(sp)
  sd t1, 40(sp)
            # copy .tmp7, 8
  li t0, 8
  sd zero, 256(sp)
  sd t0, 264(sp)
            # arg .tmp7, 7
  ld t0, 256(sp)
  ld t1, 264(sp)
  sd t0, 48(sp)
  sd t1, 56(sp)
            # copy .tmp8, 9
  li t0, 9
  sd zero, 272(sp)
  sd t0, 280(sp)
            # arg .tmp8, 8
  ld t0, 272(sp)
  ld t1, 280(sp)
  sd t0, 64(sp)
  sd t1, 72(sp)
            # copy .tmp9, 10
  li t0, 10
  sd zero, 288(sp)
  sd t0, 296(sp)
            # arg .tmp9, 9
  ld t0, 288(sp)
  ld t1, 296(sp)
  sd t0, 80(sp)
  sd t1, 88(sp)
            # copy .tmp10, 11
  li t0, 11
  sd zero, 304(sp)
  sd t0, 312(sp)
            # arg .tmp10, 10
  ld t0, 304(sp)
  ld t1, 312(sp)
  sd t0, 96(sp)
  sd t1, 104(sp)
            # copy .tmp11, 12
  li t0, 12
  sd zero, 320(sp)
  sd t0, 328(sp)
            # arg .tmp11, 11
  ld t0, 320(sp)
  ld t1, 328(sp)
  sd t0, 112(sp)
  sd t1, 120(sp)
            # copy .tmp12, 13
  li t0, 13
  sd zero, 336(sp)
  sd t0, 344(sp)
            # arg .tmp12, 12
  ld t0, 336(sp)
  ld t1, 344(sp)
  sd t0, 128(sp)
  sd t1, 136(sp)
            # call .tmp13, a
  call a
  addi sp, sp, 144
  sd a0, 208(sp)
  sd a1, 216(sp)
            # copy global_temp, .tmp13
  ld t0, 208(sp)
  ld t1, 216(sp)
  la t2, global_temp_type
  sd t0, (t2)
  sd t1, 8(t2)
            # endfun 
  ld ra, 232(sp)
  ld fp, 224(sp)
  addi sp, sp, 240
  ret

# fun a(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
a:
  addi sp, sp, -224
  sd ra, 216(sp)
  sd fp, 208(sp)
  addi fp, sp, 224
            # param p1, 0
  sd a0, 0(sp)
  sd a1, 8(sp)
            # param p2, 1
  sd a2, 16(sp)
  sd a3, 24(sp)
            # param p3, 2
  sd a4, 32(sp)
  sd a5, 40(sp)
            # param p4, 3
  sd a6, 48(sp)
  sd a7, 56(sp)
            # param p5, 4
  ld t1, 0(fp)
  ld t2, 8(fp)
  sd t1, 64(sp)
  sd t2, 72(sp)
            # param p6, 5
  ld t1, 16(fp)
  ld t2, 24(fp)
  sd t1, 80(sp)
  sd t2, 88(sp)
            # param p7, 6
  ld t1, 32(fp)
  ld t2, 40(fp)
  sd t1, 96(sp)
  sd t2, 104(sp)
            # param p8, 7
  ld t1, 48(fp)
  ld t2, 56(fp)
  sd t1, 112(sp)
  sd t2, 120(sp)
            # param p9, 8
  ld t1, 64(fp)
  ld t2, 72(fp)
  sd t1, 128(sp)
  sd t2, 136(sp)
            # param p10, 9
  ld t1, 80(fp)
  ld t2, 88(fp)
  sd t1, 144(sp)
  sd t2, 152(sp)
            # param p11, 10
  ld t1, 96(fp)
  ld t2, 104(fp)
  sd t1, 160(sp)
  sd t2, 168(sp)
            # param p12, 11
  ld t1, 112(fp)
  ld t2, 120(fp)
  sd t1, 176(sp)
  sd t2, 184(sp)
            # param p13, 12
  ld t1, 128(fp)
  ld t2, 136(fp)
  sd t1, 192(sp)
  sd t2, 200(sp)
            # arg_vox_lib p1
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
            # arg_vox_lib p2
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
            # arg_vox_lib p3
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
            # arg_vox_lib p4
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
            # arg_vox_lib p5
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
            # arg_vox_lib p6
  addi sp, sp, -16
  ld t0, 96(sp)
  ld t1, 104(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p7
  addi sp, sp, -16
  ld t0, 112(sp)
  ld t1, 120(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p8
  addi sp, sp, -16
  ld t0, 128(sp)
  ld t1, 136(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p9
  addi sp, sp, -16
  ld t0, 144(sp)
  ld t1, 152(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p10
  addi sp, sp, -16
  ld t0, 160(sp)
  ld t1, 168(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p11
  addi sp, sp, -16
  ld t0, 176(sp)
  ld t1, 184(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p12
  addi sp, sp, -16
  ld t0, 192(sp)
  ld t1, 200(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # arg_vox_lib p13
  addi sp, sp, -16
  ld t0, 208(sp)
  ld t1, 216(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # endfun 
  ld ra, 216(sp)
  ld fp, 208(sp)
  addi sp, sp, 224
  ret

  .data
global_temp_type:  .quad 0
global_temp_value: .quad 0

