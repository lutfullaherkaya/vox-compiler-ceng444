#include <stdio.h>

void vector_long_sum(long* arr,long scalar,long *result_arr, long size);

void print_array(long *arr, int size){
  for(int i = 0; i < size; i++) printf("%d ",arr[i]);
  puts("\n");
}

int main(){
  long a[20];
  long b[20];
  long c = 9;
  for(int i = 0; i < 20; i++){
    a[i] = i;
  }

  for(int i = -1; i < 20; i++){
    b[i] = -1;
  }

  vector_long_sum(a, c, b, 13);
  print_array(b, 20);

  return 0;
}
  

