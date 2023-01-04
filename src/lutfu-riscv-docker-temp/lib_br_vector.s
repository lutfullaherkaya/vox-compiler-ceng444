  .global _br_vector_integer_add
  .global _br_vector_vector_add

  .text
  .align 2
#void _br_vector_integer_add(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_br_vector_integer_add:
  blez a3, .L2
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L1:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3     # stride load: loads element 16 by 16, thus skipping the types and taking the values
  vadd.vx v0, v0, a1
  vsse64.v v0, (a2), t3     # stride store
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L1
.L2:
  ret

#void _br_vector_vector_add(VoxObject* vector1, VoxObject* vector2, VoxObject *result_vector, long size);
_br_vector_vector_add:
  blez a3, .L4
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a1, a1, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L3:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3
  vlse64.v v8, (a1), t3
  vadd.vv v0, v0, v8
  vsse64.v v0, (a2), t3
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a1, a1, t1
  add a2, a2, t1
  bgtz a3, .L3
.L4:
  ret
