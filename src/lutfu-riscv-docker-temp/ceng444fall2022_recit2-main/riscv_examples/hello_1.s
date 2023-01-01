  .global main

  .text
  .align 2
main:
  ld a0, global_var
  ret

  .data
global_var: .quad 5
