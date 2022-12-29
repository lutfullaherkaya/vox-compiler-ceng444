  .global main
  
  .text
  .align 2
main:
  addi sp, sp, -24
  sd ra, 16(sp)
            # copy a, 5.0
  sd zero, 0(sp)
  li t0, 5.0
  sd t0, 8(sp)
    sd ra, 16(sp)
  ld ra, 16(sp)
  addi sp, sp, 24
  mv a0, zero
  ret
