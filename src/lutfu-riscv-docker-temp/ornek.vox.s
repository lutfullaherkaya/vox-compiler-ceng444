#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
  addi sp, sp, -16
  sd ra, 8(sp)
  sd fp, 0(sp)
  addi fp, sp, 16
            # global a
            # copy global_a, hello
  li t0, 3
  la t1, .L_string1
  la t2, a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global b
            # copy global_b, hello
  li t0, 3
  la t1, .L_string1
  la t2, b_type
  sd t0, (t2)
  sd t1, 8(t2)
            # global df
            # vector_set global_df, 0, 1
  li t0, 0
  li t1, 1
  ld t2, df_value
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_df, 1, 2
  li t0, 0
  li t1, 2
  ld t2, df_value
  addi t2, t2, 16
  sd t0, 0(t2)
  sd t1, 8(t2)
            # vector_set global_df, 2, 3
  li t0, 0
  li t1, 3
  ld t2, df_value
  addi t2, t2, 32
  sd t0, 0(t2)
  sd t1, 8(t2)
            # global fff
            # copy global_fff, -123
  li t0, 0
  li t1, -123
  la t2, fff_type
  sd t0, (t2)
  sd t1, 8(t2)
            # arg_count 1
            # arg hello, 0
  li a0, 3
  la a1, .L_string1
            # call __vox_print__
  call __vox_print__
            # arg_count 1
            # arg hello, 0
  li a0, 3
  la a1, .L_string1
            # call __vox_print__
  call __vox_print__
            # arg_count 1
            # arg 123, 0
  li a0, 0
  li a1, 123
            # call __vox_print__
  call __vox_print__
            # endfun 
  ld ra, 8(sp)
  ld fp, 0(sp)
  addi sp, sp, 16
  ret

# fun f();
f:
  addi sp, sp, -48
  sd ra, 40(sp)
  sd fp, 32(sp)
  addi fp, sp, 48
            # copy a, 5
  li t0, 0
  li t1, 5
  sd t0, 0(sp)
  sd t1, 8(sp)
            # copy b, 5
  li t0, 0
  li t1, 5
  sd t0, 16(sp)
  sd t1, 24(sp)
            # endfun 
  ld ra, 40(sp)
  ld fp, 32(sp)
  addi sp, sp, 48
  ret

  .data
a_type:   .quad 0
a_value:  .quad 0

b_type:   .quad 0
b_value:  .quad 0

df_type:    .quad 1
df_value:   .quad df_vector
df_length:  .quad 3
df_vector:
  .quad 0, 0
  .quad 0, 0
  .quad 0, 0

fff_type:   .quad 0
fff_value:  .quad 0

.L_string1:  .string "hello"
