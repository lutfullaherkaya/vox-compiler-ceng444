#include "vox_lib.h"
  
  .global main
  .text
  .align 2
main:
  addi sp, sp, -72
  sd ra, 64(sp)
            # global a
            # copy {'name': '.tmp0', 'id': 0}, 2
  li t0, 2
  sd zero, 0(sp)
  sd t0, 8(sp)
            # copy {'name': 'a', 'id': -1}, {'name': '.tmp0', 'id': 0}
  ld t0, 0(sp)
  ld t1, 8(sp)
  la t2, global_a_type
  sd t0, (t2)
  sd t1, 8(t2)
            # copy {'name': '.tmp1', 'id': 0}, True
  li t1, 2
  li t2, 1
  sd t1, 16(sp)
  sd t2, 24(sp)
            # branch_if_false {'name': '.tmp1', 'id': 0}, .L_endif1
  ld t0, 24(sp)
  beq t0, zero, .L_endif1
            # copy {'name': '.tmp2', 'id': 0}, 4
  li t0, 4
  sd zero, 48(sp)
  sd t0, 56(sp)
            # copy {'name': 'a', 'id': 0}, {'name': '.tmp2', 'id': 0}
  ld t0, 48(sp)
  ld t1, 56(sp)
  sd t0, 32(sp)
  sd t1, 40(sp)
            # param {'name': 'a', 'id': 0}
  addi sp, sp, -16
  ld t0, 48(sp)
  ld t1, 56(sp)
  sd t0, (sp)
  sd t1, 8(sp)
            # call __br_print__, 1
  mv a1, sp
  li a0, 1
  call __br_print__
  addi sp, sp, 16
            # label .L_endif1
.L_endif1:
  ld ra, 64(sp)
  addi sp, sp, 72
  mv a0, zero
  ret

  .data
global_a_type:  .quad 0
global_a_value: .quad 0

