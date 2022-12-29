  .global vector_long_sum

  .text
  .align 2
#void void vector_long_sum(long* arr,long scalar,long *result_arr, long size)
vector_long_sum:
  blez a3, .L2 # if num_elements <= 0 skip to end
.L1:
  vsetvli t0, a3, e64, m2, tu, mu #a3 holds num_elements, t0 will hold
                                  #vl, SEW=64bits, LMUL=2, tu, mu -> look up tailmask
                                  #undisturbed in the spec, you want it on.
  vle64.v v0, (a0) #load vl elements into v0 from a0
  vadd.vx v0, v0, a1 #add a1 to every element of v0
  vse64.v v0, (a2) #save vl elements into a2 from v0
  sub a3, a3, t0 #subtract vl from num_elements
  slli t1, t0, 3
  add a0, a0, t1
  add a2, a2, t1 #bump up starting indices of a0,a2 by 8*t0 (because each element is 64 bytes)
  bgtz a3, .L1 #keep looping if num_elements > 0
.L2:
  ret
