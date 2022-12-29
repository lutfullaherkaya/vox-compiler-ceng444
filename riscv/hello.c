#include <stdio.h>
#include <stdlib.h>

char* strveccpy(char *dst, const char* src);

int main(){
  char *arr1 = (char *)malloc(10*sizeof(char));
  char *arr2 = (char *)malloc(10*sizeof(char));
  arr1[9] = 0;
  for(int i = 0;i<9;i++){
    arr1[i] = 'a'+i;
  }

  strveccpy(arr2, arr1);
  printf("Original: %s\n", arr1);
  printf("Copied with vector instructions (should be the same with original): %s\n", arr2);
  return 0;
}
