  .global _br_vector_integer_add
  .global _br_vector_vector_add

  .text
  .align 2
#void _br_vector_integer_add(long* vector, long integer, long *result_vector, long size);
_br_vector_integer_add:
  blez a3, .L2
.L1:
  vsetvli t0, a3, e64, m8, tu, mu
  vle64.v v0, (a0)
  vadd.vx v0, v0, a1
  vse64.v v0, (a2)
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L1
.L2:
  ret

#void _br_vector_vector_add(long* vector1, long* vector2, long *result_vector, long size);
_br_vector_vector_add:
  blez a3, .L4
.L3:
  vsetvli t0, a3, e64, m8, tu, mu
  vle64.v v0, (a0)
  vle64.v v8, (a1)
  vadd.vv v0, v0, v8
  vse64.v v0, (a2)
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a1, a1, t1
  add a2, a2, t1
  bgtz a3, .L3
.L4:
  ret
