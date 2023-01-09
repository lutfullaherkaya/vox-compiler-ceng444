#include "vox_lib.h"
  
  .global main
  .text
  .align 2

# fun main();
main:
            # return 
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
