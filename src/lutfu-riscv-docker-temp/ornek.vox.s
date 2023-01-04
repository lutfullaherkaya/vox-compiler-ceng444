#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -496
  sd ra, 488(sp)
  sd fp, 480(sp)
  addi fp, sp, 496
            # global a
            # copy .tmp0, 1
  li t0, 1
  sd zero, 0(sp)
  sd t0, 8(sp)
            # vector_set global_a, 0, .tmp0
  ld t0, 0(sp)
  ld t1, 8(sp)
  ld t2, global_a_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp1, 2
  li t0, 2
  sd zero, 16(sp)
  sd t0, 24(sp)
            # vector_set global_a, 1, .tmp1
  ld t0, 16(sp)
  ld t1, 24(sp)
  ld t2, global_a_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp2, 3
  li t0, 3
  sd zero, 32(sp)
  sd t0, 40(sp)
            # vector_set global_a, 2, .tmp2
  ld t0, 32(sp)
  ld t1, 40(sp)
  ld t2, global_a_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp3, 4
  li t0, 4
  sd zero, 48(sp)
  sd t0, 56(sp)
            # vector_set global_a, 3, .tmp3
  ld t0, 48(sp)
  ld t1, 56(sp)
  ld t2, global_a_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp4, 5
  li t0, 5
  sd zero, 64(sp)
  sd t0, 72(sp)
            # vector_set global_a, 4, .tmp4
  ld t0, 64(sp)
  ld t1, 72(sp)
  ld t2, global_a_value
  addi t2, t2, 64
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global b
            # copy .tmp5, 5
  li t0, 5
  sd zero, 80(sp)
  sd t0, 88(sp)
            # vector_set global_b, 0, .tmp5
  ld t0, 80(sp)
  ld t1, 88(sp)
  ld t2, global_b_value
  addi t2, t2, 0
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp6, 6
  li t0, 6
  sd zero, 96(sp)
  sd t0, 104(sp)
            # vector_set global_b, 1, .tmp6
  ld t0, 96(sp)
  ld t1, 104(sp)
  ld t2, global_b_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp7, 7
  li t0, 7
  sd zero, 112(sp)
  sd t0, 120(sp)
            # vector_set global_b, 2, .tmp7
  ld t0, 112(sp)
  ld t1, 120(sp)
  ld t2, global_b_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp8, 8
  li t0, 8
  sd zero, 128(sp)
  sd t0, 136(sp)
            # vector_set global_b, 3, .tmp8
  ld t0, 128(sp)
  ld t1, 136(sp)
  ld t2, global_b_value
  addi t2, t2, 48
  sd t0, 0(t2)
  sd t1, 8(t2)
            # copy .tmp9, 9
  li t0, 9
  sd zero, 144(sp)
  sd t0, 152(sp)
            # vector_set global_b, 4, .tmp9
  ld t0, 144(sp)
  ld t1, 152(sp)
  ld t2, global_b_value
  addi t2, t2, 64
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global c
            # copy .tmp10, 3
  li t0, 3
  sd zero, 160(sp)
  sd t0, 168(sp)
            # copy global_c, .tmp10
  ld t0, 160(sp)
  ld t1, 168(sp)
  la t2, global_c_type
  sd t0, (t2)
  sd t1, 8(t2)
            # copy .tmp12, 1
  li t0, 1
  sd zero, 192(sp)
  sd t0, 200(sp)
            # arg_count 2
            # arg .tmp12, 0
  ld a0, 192(sp)
  ld a1, 200(sp)
            # arg global_a, 1
  ld a2, global_a_type
  ld a3, global_a_value
            # call .tmp11, __vox_sub__
  call __vox_sub__
  addi sp, sp, 0
  sd a0, 176(sp)
  sd a1, 184(sp)
            # arg_count 1
            # arg .tmp11, 0
  ld a0, 176(sp)
  ld a1, 184(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp14, 1
  li t0, 1
  sd zero, 224(sp)
  sd t0, 232(sp)
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg .tmp14, 1
  ld a2, 224(sp)
  ld a3, 232(sp)
            # call .tmp13, __vox_sub__
  call __vox_sub__
  addi sp, sp, 0
  sd a0, 208(sp)
  sd a1, 216(sp)
            # arg_count 1
            # arg .tmp13, 0
  ld a0, 208(sp)
  ld a1, 216(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp16, 0
  li t0, 0
  sd zero, 256(sp)
  sd t0, 264(sp)
            # arg_count 2
            # arg .tmp16, 0
  ld a0, 256(sp)
  ld a1, 264(sp)
            # arg global_a, 1
  ld a2, global_a_type
  ld a3, global_a_value
            # call .tmp15, __vox_sub__
  call __vox_sub__
  addi sp, sp, 0
  sd a0, 240(sp)
  sd a1, 248(sp)
            # arg_count 1
            # arg .tmp15, 0
  ld a0, 240(sp)
  ld a1, 248(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp17, __vox_sub__
  call __vox_sub__
  addi sp, sp, 0
  sd a0, 272(sp)
  sd a1, 280(sp)
            # arg_count 1
            # arg .tmp17, 0
  ld a0, 272(sp)
  ld a1, 280(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_b, 0
  ld a0, global_b_type
  ld a1, global_b_value
            # arg global_a, 1
  ld a2, global_a_type
  ld a3, global_a_value
            # call .tmp18, __vox_sub__
  call __vox_sub__
  addi sp, sp, 0
  sd a0, 288(sp)
  sd a1, 296(sp)
            # arg_count 1
            # arg .tmp18, 0
  ld a0, 288(sp)
  ld a1, 296(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_b, 0
  ld a0, global_b_type
  ld a1, global_b_value
            # arg global_a, 1
  ld a2, global_a_type
  ld a3, global_a_value
            # call .tmp19, __vox_div__
  call __vox_div__
  addi sp, sp, 0
  sd a0, 304(sp)
  sd a1, 312(sp)
            # arg_count 1
            # arg .tmp19, 0
  ld a0, 304(sp)
  ld a1, 312(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp20, __vox_div__
  call __vox_div__
  addi sp, sp, 0
  sd a0, 320(sp)
  sd a1, 328(sp)
            # arg_count 1
            # arg .tmp20, 0
  ld a0, 320(sp)
  ld a1, 328(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp22, 10
  li t0, 10
  sd zero, 352(sp)
  sd t0, 360(sp)
            # arg_count 2
            # arg .tmp22, 0
  ld a0, 352(sp)
  ld a1, 360(sp)
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp21, __vox_div__
  call __vox_div__
  addi sp, sp, 0
  sd a0, 336(sp)
  sd a1, 344(sp)
            # arg_count 1
            # arg .tmp21, 0
  ld a0, 336(sp)
  ld a1, 344(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp24, 2
  li t0, 2
  sd zero, 384(sp)
  sd t0, 392(sp)
            # arg_count 2
            # arg global_b, 0
  ld a0, global_b_type
  ld a1, global_b_value
            # arg .tmp24, 1
  ld a2, 384(sp)
  ld a3, 392(sp)
            # call .tmp23, __vox_div__
  call __vox_div__
  addi sp, sp, 0
  sd a0, 368(sp)
  sd a1, 376(sp)
            # arg_count 1
            # arg .tmp23, 0
  ld a0, 368(sp)
  ld a1, 376(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp25, __vox_mul__
  call __vox_mul__
  addi sp, sp, 0
  sd a0, 400(sp)
  sd a1, 408(sp)
            # arg_count 1
            # arg .tmp25, 0
  ld a0, 400(sp)
  ld a1, 408(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp27, 2
  li t0, 2
  sd zero, 432(sp)
  sd t0, 440(sp)
            # arg_count 2
            # arg global_a, 0
  ld a0, global_a_type
  ld a1, global_a_value
            # arg .tmp27, 1
  ld a2, 432(sp)
  ld a3, 440(sp)
            # call .tmp26, __vox_mul__
  call __vox_mul__
  addi sp, sp, 0
  sd a0, 416(sp)
  sd a1, 424(sp)
            # arg_count 1
            # arg .tmp26, 0
  ld a0, 416(sp)
  ld a1, 424(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # copy .tmp29, 10
  li t0, 10
  sd zero, 464(sp)
  sd t0, 472(sp)
            # arg_count 2
            # arg .tmp29, 0
  ld a0, 464(sp)
  ld a1, 472(sp)
            # arg global_b, 1
  ld a2, global_b_type
  ld a3, global_b_value
            # call .tmp28, __vox_div__
  call __vox_div__
  addi sp, sp, 0
  sd a0, 448(sp)
  sd a1, 456(sp)
            # arg_count 1
            # arg .tmp28, 0
  ld a0, 448(sp)
  ld a1, 456(sp)
            # call __vox_print__
  call __vox_print__
  addi sp, sp, 0
            # endfun 
  ld ra, 488(sp)
  ld fp, 480(sp)
  addi sp, sp, 496
  ret

  .data
global_a_type:    .quad 1
global_a_value:   .quad global_a_vector
global_a_length:  .quad 5
global_a_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_b_type:    .quad 1
global_b_value:   .quad global_b_vector
global_b_length:  .quad 5
global_b_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

global_c_type:   .quad 0
global_c_value:  .quad 0

