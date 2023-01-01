#include "vox_lib.h"
#include <stdio.h>
#include <stdlib.h>

void __br_print__(long argc, BracketObject argv[]){
  switch (argv[0].type) {
    case VOX_INT: {
      printf("%ld\n", argv[0].value.integer);

      break;
    }
    case VOX_VECTOR: {
      long* vector = argv[0].value.vector;
      long length = vector[0];

      putchar('[');
      for(long i = 1; i < length; i++) printf("%ld, ", vector[i]);
      printf("%ld]\n", vector[length]);
      break;
    }
    case VOX_BOOL: {
      if (argv[0].value.boolean) printf("true\n");
      else printf("false\n");
      break;
    }
  }

}

BracketObject __br_initvector__(long argc,  BracketObject argv[]){
  BracketObject return_object;
  return_object.type = 1;

  long* vector = (long* )malloc((argc+1)*sizeof(long));
  vector[0] = argc;

  for(long i = 1; i < argc+1; i++){
    if(argv[i-1].type){
      printf("Trying to initialize a nested array on index %d. This is the culprit:\n",i-1);
      __br_print__(1, &(argv[i-1]));
      puts("Runtime error :(");
      exit(1);
    }

    vector[i] = argv[i-1].value.integer; 
  }
  
  return_object.value.vector = vector;
  return return_object;
}

BracketObject __br_add__(long argc, BracketObject argv[]){
  BracketObject return_object;
  return_object.type = argv[0].type || argv[1].type;

  if(return_object.type){
    if(argv[0].type && argv[1].type){
      long* vector1 = argv[0].value.vector;
      long* vector2 = argv[1].value.vector;

      if(vector1[0] != vector2[0]){
        puts("Vector sizes of");
        __br_print__(1, argv);
        __br_print__(1, &(argv[1]));
        puts("do not match. Runtime error :(");
        exit(1);
      }

      long* result_vector = (long* )malloc((vector1[0]+1)*sizeof(long));
      result_vector[0] = vector1[0];

      _br_vector_vector_add(vector1+1, vector2+1, result_vector+1, vector1[0]);

      return_object.value.vector = result_vector;
    }
    else if(argv[0].type){
      long* vector = argv[0].value.vector;
      long* result_vector = (long* )malloc((vector[0]+1)*sizeof(long));
      result_vector[0] = vector[0];

      _br_vector_integer_add(vector+1, argv[1].value.integer, result_vector+1, vector[0]);

      return_object.value.vector = result_vector;
    }
    else{
      long* vector = argv[1].value.vector;
      long* result_vector = (long* )malloc((vector[0]+1)*sizeof(long));
      result_vector[0] = vector[0];

      _br_vector_integer_add(vector+1, argv[0].value.integer, result_vector+1,  vector[0]);

      return_object.value.vector = result_vector;      
    }
  }
  else return_object.value.integer = argv[0].value.integer + argv[1].value.integer;

  return return_object;
}
