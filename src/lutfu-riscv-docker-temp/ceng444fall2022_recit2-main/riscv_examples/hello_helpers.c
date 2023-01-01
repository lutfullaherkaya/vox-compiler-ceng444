#include "hello_helpers.h"
#include <stdio.h>


void scan_inputs(long* a0){
  scanf(" %d %d",a0, &a0[1]);
}

void print_outputs(long a0, long a1, long a2){
  printf("Outputs: %d %d %d ", a0, a1, a2);
}
