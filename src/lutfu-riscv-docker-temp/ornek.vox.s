#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -656
  sd ra, 648(sp)
  sd fp, 640(sp)
  addi fp, sp, 656
            # global c
            # copy .tmp0, 1
  li t0, 1
  sd zero, 0(sp)
  sd t0, 8(sp)
            # vector_set global_c, 0, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  ld t2, global_c_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp1, 22
  li t0, 22
  sd zero, 16(sp)
  sd t0, 24(sp)
            # vector_set global_c, 1, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  ld t2, global_c_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp2, 3
  li t0, 3
  sd zero, 32(sp)
  sd t0, 40(sp)
            # vector_set global_c, 2, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  ld t2, global_c_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global d
            # copy .tmp3, bu
  li t1, 3
  la t2, .L_string7
  sd t1, 48(sp)
  sd t2, 56(sp)
            # vector_set global_d, 0, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  ld t2, global_d_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp4, bir
  li t1, 3
  la t2, .L_string8
  sd t1, 64(sp)
  sd t2, 72(sp)
            # vector_set global_d, 1, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  ld t2, global_d_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp5, global
  li t1, 3
  la t2, .L_string3
  sd t1, 80(sp)
  sd t2, 88(sp)
            # vector_set global_d, 2, .tmp5
  ld t0, 80(sp)
  ld t1, 88(sp)
  ld t2, global_d_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp6, arrayidir
  li t1, 3
  la t2, .L_string10
  sd t1, 96(sp)
  sd t2, 104(sp)
            # vector_set global_d, 3, .tmp6
  ld t0, 96(sp)
  ld t1, 104(sp)
  ld t2, global_d_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp7, \n
  li t1, 3
  la t2, .L_string11
  sd t1, 112(sp)
  sd t2, 120(sp)
            # vector_set global_d, 4, .tmp7
  ld t0, 112(sp)
  ld t1, 120(sp)
  ld t2, global_d_value
  addi t2, t2, 64
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global i
            # arg_vox_lib global_c
  addi sp, sp, -16
  ld t0, global_c_type
  ld t1, global_c_value
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp8, True
  li t1, 2
  li t2, 1
  sd t1, 128(sp)
  sd t2, 136(sp)
            # branch_if_false .tmp8, .L_endif1
  ld t0, 136(sp)
  beq t0, zero, .L_endif1
            # vector c, 3
  li t1, 1
  add t2, sp, 168
  sd t1, 144(sp)
  sd t2, 152(sp)
  li t0, 3
  sd t0, 160(sp)
            # copy .tmp9, 1
  li t0, 1
  sd zero, 216(sp)
  sd t0, 224(sp)
            # vector_set c, 0, .tmp9
  ld t0, 216(sp)
  ld t1, 224(sp)
  ld t2, 152(sp)
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp10, 2
  li t0, 2
  sd zero, 232(sp)
  sd t0, 240(sp)
            # vector_set c, 1, .tmp10
  ld t0, 232(sp)
  ld t1, 240(sp)
  ld t2, 152(sp)
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp11, string
  li t1, 3
  la t2, .L_string9
  sd t1, 248(sp)
  sd t2, 256(sp)
            # vector_set c, 2, .tmp11
  ld t0, 248(sp)
  ld t1, 256(sp)
  ld t2, 152(sp)
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector d, 4
  li t1, 1
  add t2, sp, 288
  sd t1, 264(sp)
  sd t2, 272(sp)
  li t0, 4
  sd t0, 280(sp)
            # copy .tmp12, bu
  li t1, 3
  la t2, .L_string7
  sd t1, 352(sp)
  sd t2, 360(sp)
            # vector_set d, 0, .tmp12
  ld t0, 352(sp)
  ld t1, 360(sp)
  ld t2, 272(sp)
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp13, bir
  li t1, 3
  la t2, .L_string8
  sd t1, 368(sp)
  sd t2, 376(sp)
            # vector_set d, 1, .tmp13
  ld t0, 368(sp)
  ld t1, 376(sp)
  ld t2, 272(sp)
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp14, string
  li t1, 3
  la t2, .L_string9
  sd t1, 384(sp)
  sd t2, 392(sp)
            # vector_set d, 2, .tmp14
  ld t0, 384(sp)
  ld t1, 392(sp)
  ld t2, 272(sp)
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp15, arrayidir
  li t1, 3
  la t2, .L_string10
  sd t1, 400(sp)
  sd t2, 408(sp)
            # vector_set d, 3, .tmp15
  ld t0, 400(sp)
  ld t1, 408(sp)
  ld t2, 272(sp)
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy i
  sd zero, 416(sp)
  sd zero, 424(sp)
            # arg_vox_lib c
  addi sp, sp, -16
  ld t0, 160(sp)
  ld t1, 168(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp16, 0
  li t0, 0
  sd zero, 432(sp)
  sd t0, 440(sp)
            # copy i, .tmp16
  ld t0, 432(sp)
  ld t1, 440(sp)
  sd t0, 416(sp)
  sd t1, 424(sp)
            # branch .L_for_cond1
  j .L_for_cond1
            # label .L_for_body1
.L_for_body1:
            # vector_get .tmp17, d, i
  ld t1, 272(sp)
  ld t0, 424(sp)
  slli t0, t0, 4
  add t1, t1, t0
  ld t0, 0(t1)
  ld t1, 8(t1)
  sd t0, 448(sp)
  sd t1, 456(sp)
            # arg_vox_lib .tmp17
  addi sp, sp, -16
  ld t0, 464(sp)
  ld t1, 472(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp19, 1
  li t0, 1
  sd zero, 480(sp)
  sd t0, 488(sp)
            # + .tmp18, i, .tmp19
  ld t0, 424(sp)
  ld t1, 488(sp)
  add t0, t0, t1
  sd zero, 464(sp)
  sd t0, 472(sp)
            # copy i, .tmp18
  ld t0, 464(sp)
  ld t1, 472(sp)
  sd t0, 416(sp)
  sd t1, 424(sp)
            # label .L_for_cond1
.L_for_cond1:
            # copy .tmp21, 4
  li t0, 4
  sd zero, 512(sp)
  sd t0, 520(sp)
            # < .tmp20, i, .tmp21
  ld t0, 424(sp)
  ld t1, 520(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 496(sp)
  sd t2, 504(sp)
            # branch_if_true .tmp20, .L_for_body1
  ld t0, 504(sp)
  bne t0, zero, .L_for_body1
            # arg_vox_lib d
  addi sp, sp, -16
  ld t0, 280(sp)
  ld t1, 288(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp22, \n
  li t1, 3
  la t2, .L_string11
  sd t1, 528(sp)
  sd t2, 536(sp)
            # arg_vox_lib .tmp22
  addi sp, sp, -16
  ld t0, 544(sp)
  ld t1, 552(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # label .L_endif1
.L_endif1:
            # copy .tmp23, 0
  li t0, 0
  sd zero, 544(sp)
  sd t0, 552(sp)
            # copy global_i, .tmp23
  ld t0, 544(sp)
  ld t1, 552(sp)
  la t2, global_i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # branch .L_for_cond2
  j .L_for_cond2
            # label .L_for_body2
.L_for_body2:
            # vector_get .tmp24, global_d, global_i
  ld t1, global_d_value
  ld t0, global_i_value
  slli t0, t0, 4
  add t1, t1, t0
  ld t0, 0(t1)
  ld t1, 8(t1)
  sd t0, 560(sp)
  sd t1, 568(sp)
            # arg_vox_lib .tmp24
  addi sp, sp, -16
  ld t0, 576(sp)
  ld t1, 584(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # copy .tmp26, 1
  li t0, 1
  sd zero, 592(sp)
  sd t0, 600(sp)
            # + .tmp25, global_i, .tmp26
  ld t0, global_i_value
  ld t1, 600(sp)
  add t0, t0, t1
  sd zero, 576(sp)
  sd t0, 584(sp)
            # copy global_i, .tmp25
  ld t0, 576(sp)
  ld t1, 584(sp)
  la t2, global_i_type
  sd t0, (t2)
  sd t1, 8(t2)
            # label .L_for_cond2
.L_for_cond2:
            # copy .tmp28, 4
  li t0, 4
  sd zero, 624(sp)
  sd t0, 632(sp)
            # < .tmp27, global_i, .tmp28
  ld t0, global_i_value
  ld t1, 632(sp)
  slt t2, t0, t1
  li t1, 2
  sd t1, 608(sp)
  sd t2, 616(sp)
            # branch_if_true .tmp27, .L_for_body2
  ld t0, 616(sp)
  bne t0, zero, .L_for_body2
            # arg_vox_lib global_d
  addi sp, sp, -16
  ld t0, global_d_type
  ld t1, global_d_value
  sd t0, (sp)
  sd t1, 8(sp)
            # call_vox_lib __vox_print__, 1
  mv a1, sp
  li a0, 1
  call __vox_print__
  addi sp, sp, 16
            # endfun 
  ld ra, 648(sp)
  ld fp, 640(sp)
  addi sp, sp, 656
  ret

  .data
global_c_type:    .quad 1
global_c_value:   .quad global_c_vector
global_c_length:  .quad 3
global_c_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_d_type:    .quad 1
global_d_value:   .quad global_d_vector
global_d_length:  .quad 5
global_d_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_i_type:   .quad 0
global_i_value:  .quad 0

.L_string7:  .string "bu"
.L_string8:  .string "bir"
.L_string3:  .string "global"
.L_string10:  .string "arrayidir"
.L_string11:  .string "\n"
.L_string9:  .string "string"
