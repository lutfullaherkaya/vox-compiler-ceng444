#include <stdio.h>

  .global main

  .text
  .align 2
main:
  la t0, global_var
  ld a1, (t0)
  ld a2, 8(t0)
  add a0, a1, a2
  bltz a0, .L1
  ret
.L1:
  addi sp, sp, -8
  sd ra, (sp)
  la a0, its_negative
  call puts
  ld ra, (sp)
  addi sp, sp, 8
  li a0, 0
  ret



  .data
global_var: .quad 5,-6
its_negative: .ascii "It's Negative!"
