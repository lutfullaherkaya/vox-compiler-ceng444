#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:

  addi sp, sp, -56
  sd ra, 48(sp)
            # global toplam
            # copy .tmp0, 0
  li t0, 0
  sd zero, 0(sp)
  sd t0, 8(sp)
            # copy global_toplam, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, global_toplam_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global temp
            # copy .tmp1, 0
  li t0, 0
  sd zero, 16(sp)
  sd t0, 24(sp)
            # copy global_temp, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  la t2, global_temp_type
  sd t0, (t2)
  sd t1, 8(t2)
            # call .tmp2, yuze_kadar_toplama_ekle
  mv a1, sp
  call yuze_kadar_toplama_ekle
  sd a0, 32(sp)
  sd a1, 40(sp)
            # param .tmp2
  addi sp, sp, -16
  ld t0, 48(sp)
  ld t1, 56(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # param global_toplam
  addi sp, sp, -16
  ld t0, global_toplam_type
  ld t1, global_toplam_value
  sd t0, (sp)
  sd t1, 8(sp)
            # call __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # endfun 
  ld ra, 48(sp)
  addi sp, sp, 56
  ret

# fun yuze_kadar_toplama_ekle();
yuze_kadar_toplama_ekle:

  addi sp, sp, -88
  sd ra, 80(sp)
            # copy .tmp1, 100
  li t0, 100
  sd zero, 16(sp)
  sd t0, 24(sp)
            # < .tmp0, global_toplam, .tmp1
  ld t0, global_toplam_value
  ld t1, 24(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 0(sp)
  sd t2, 8(sp)
            # branch_if_false .tmp0, .L_endif1
  ld t0, 8(sp)
  beq t0, zero, .L_endif1
            # copy .tmp3, 1
  li t0, 1
  sd zero, 48(sp)
  sd t0, 56(sp)
            # + .tmp2, global_toplam, .tmp3
  ld t0, global_toplam_value
  ld t1, 56(sp)
  add t0, t0, t1
  sd zero, 32(sp)
  sd t0, 40(sp)
            # copy global_toplam, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  la t2, global_toplam_type
  sd t0, (t2)
  sd t1, 8(t2)
            # call .tmp4, yuze_kadar_toplama_ekle
  mv a1, sp
  call yuze_kadar_toplama_ekle
  sd a0, 64(sp)
  sd a1, 72(sp)
            # copy global_temp, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  la t2, global_temp_type
  sd t0, (t2)
  sd t1, 8(t2)
            # label .L_endif1
.L_endif1:
            # endfun 
  ld ra, 80(sp)
  addi sp, sp, 88
  ret

  .data
global_toplam_type:  .quad 0
global_toplam_value: .quad 0

global_temp_type:  .quad 0
global_temp_value: .quad 0

