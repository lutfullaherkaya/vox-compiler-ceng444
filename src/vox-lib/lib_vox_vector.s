  .global _vox_vector_integer_add
  .global _vox_vector_integer_sub
  .global _vox_vector_integer_mul
  .global _vox_vector_integer_div
  .global _vox_vector_vector_add
  .global _vox_vector_vector_sub
  .global _vox_vector_vector_mul
  .global _vox_vector_vector_div
  .global _vox_integer_vector_sub

  .text
  .align 2
#void _vox_vector_integer_add(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_vox_vector_integer_add:
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

#void _vox_vector_integer_sub(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_vox_vector_integer_sub:
  blez a3, .L4
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L3:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3     # stride load: loads element 16 by 16, thus skipping the types and taking the values
  vsub.vx v0, v0, a1
  vsse64.v v0, (a2), t3     # stride store
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L3
.L4:
  ret

#void _vox_integer_vector_sub(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_vox_integer_vector_sub:
  blez a3, .L41
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L31:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3     # stride load: loads element 16 by 16, thus skipping the types and taking the values
  vrsub.vx v0, v0, a1
  vsse64.v v0, (a2), t3     # stride store
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L31
.L41:
  ret

#void _vox_vector_integer_mul(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_vox_vector_integer_mul:
  blez a3, .L5
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L6:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3     # stride load: loads element 16 by 16, thus skipping the types and taking the values
  vmul.vx v0, v0, a1
  vsse64.v v0, (a2), t3     # stride store
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L6
.L5:
  ret

#void _vox_vector_integer_div(VoxObject* vector, long integer, VoxObject *result_vector, long size);
_vox_vector_integer_div:
  blez a3, .L81
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L71:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3     # stride load: loads element 16 by 16, thus skipping the types and taking the values
  vdiv.vx v0, v0, a1
  vsse64.v v0, (a2), t3     # stride store
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1
  bgtz a3, .L71
.L81:
  ret

#void _vox_vector_vector_add(VoxObject* vector1, VoxObject* vector2, VoxObject *result_vector, long size);
_vox_vector_vector_add:
  blez a3, .L10
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a1, a1, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L9:
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
  bgtz a3, .L9
.L10:
  ret

#void _vox_vector_vector_sub(VoxObject* vector1, VoxObject* vector2, VoxObject *result_vector, long size);
_vox_vector_vector_sub:
  blez a3, .L12
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a1, a1, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L11:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3
  vlse64.v v8, (a1), t3
  vsub.vv v0, v0, v8
  vsse64.v v0, (a2), t3
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a1, a1, t1
  add a2, a2, t1
  bgtz a3, .L11
.L12:
  ret

#void _vox_vector_vector_mul(VoxObject* vector1, VoxObject* vector2, VoxObject *result_vector, long size);
_vox_vector_vector_mul:
  blez a3, .L13
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a1, a1, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L14:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3
  vlse64.v v8, (a1), t3
  vmul.vv v0, v0, v8
  vsse64.v v0, (a2), t3
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a1, a1, t1
  add a2, a2, t1
  bgtz a3, .L14
.L13:
  ret

#void _vox_vector_vector_div(VoxObject* vector1, VoxObject* vector2, VoxObject *result_vector, long size);
_vox_vector_vector_div:
  blez a3, .L15
  li t3, 16
  addi a0, a0, 8 # so that we get the values instead of types
  addi a1, a1, 8 # so that we get the values instead of types
  addi a2, a2, 8 # so that we store to the values instead of types
.L16:
  vsetvli t0, a3, e64, m8, tu, mu
  vlse64.v v0, (a0), t3
  vlse64.v v8, (a1), t3
  vdiv.vv v0, v0, v8
  vsse64.v v0, (a2), t3
  sub a3, a3, t0
  slli t1, t0, 3
  add a0, a0, t1
  add a1, a1, t1
  add a2, a2, t1
  bgtz a3, .L16
.L15:
  ret
