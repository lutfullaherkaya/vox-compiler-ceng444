  .global main

  .text
  .align 2
main:
  la a0, global_var
  ld a1, (a0)
  ld a2, 8(a0)
  add a0, a1, a2
  ret

  .data
global_var: .quad 5,6
