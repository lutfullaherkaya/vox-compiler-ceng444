#include "hello_helpers.h"

  .global main

  .text
  .align 2
main:
  addi sp,sp,-24 # 3 longs, one for ra, others for scan_inputs
  sd ra, 16(sp) # save ra to bottom of frame
  mv a0, sp # sp points to space for 2 contigious longs.
  call scan_inputs
  ld a1, (sp)
  ld a2, 8(sp)
  add a0, a1, a2
  bltz a0, .L1
  j .L2
.L1:
  li a0, 1
.L2:
  call print_outputs
  ld ra, 16(sp)
  addi sp,sp,24
  ret
