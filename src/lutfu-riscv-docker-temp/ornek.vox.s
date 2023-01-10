#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -8
  sd ra, 0(sp)
            # global v
            # vector_set global_v, 0, 1
  ld t2, v_value
  li t0, 0
  li t1, 1
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v, 1, 2
  ld t2, v_value
  addi t2, t2, 16
  li t0, 0
  li t1, 2
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v, 2, 3
  ld t2, v_value
  addi t2, t2, 32
  li t0, 0
  li t1, 3
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global v2
            # vector_set global_v2, 0, 4
  ld t2, v2_value
  li t0, 0
  li t1, 4
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v2, 1, 5
  ld t2, v2_value
  addi t2, t2, 16
  li t0, 0
  li t1, 5
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v, 0, hello world
  ld t2, v_value
  li t0, 3
  la t1, .L_string1
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v2, 1, icice
  ld t2, v2_value
  addi t2, t2, 16
  li t0, 3
  la t1, .L_string2
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_v, 1, global_v2
  ld t2, v_value
  addi t2, t2, 16
  ld t0, v2_type
  ld t1, v2_value
  sd t0, 0(t2)
  sd t1, 8(t2)
            # arg global_v
  ld a0, v_type
  ld a1, v_value
            # call __vox_print__
  call __vox_print__
            # return 
  ld ra, 0(sp)
  addi sp, sp, 8
  li a0, 0
  ret

# fun g(a);
g:
  addi sp, sp, -16
            # param a
  sd a0, 0(sp)
  sd a1, 8(sp)
            # return 
  addi sp, sp, 16
  ret

# fun main.fake();
main.fake:
            # return 4
  li a0, 0
  li a1, 4
  ret

  .data
v_type:    .quad 1
v_value:   .quad v_vector
v_length:  .quad 3
v_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

v2_type:    .quad 1
v2_value:   .quad v2_vector
v2_length:  .quad 2
v2_vector:
  .quad 0, 0
  .quad 0, 0

.L_string1:  .string "hello world"
.L_string2:  .string "icice"
