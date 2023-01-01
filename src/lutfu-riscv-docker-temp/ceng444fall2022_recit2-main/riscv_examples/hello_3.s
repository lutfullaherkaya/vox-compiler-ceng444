  .global main

# Let's make it such that if the addition is negative, we terminate with 1.

  .text
  .align 2
main:
  la a0, global_var
  ld a1, (a0)
  ld a2, 8(a0)
  add a0, a1, a2
  bltz a0, .L1
  ret
.L1:
  li a0, 1
  ret

  .data
global_var: .quad 5,-6
