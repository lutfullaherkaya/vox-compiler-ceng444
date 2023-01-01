#ifndef LIB_BRACKET_H
#define LIB_BRACKET_H

void _br_vector_integer_add(long* vector, long integer, long *result_vector, long size);
void _br_vector_vector_add(long* vector1, long* vector2, long *result_vector, long size);

#define VOX_INT 0
#define VOX_VECTOR 1
#define VOX_BOOL 2

typedef union BracketValue {
  long integer; // 0 vector 1 integer galiba
  long* vector;
  long boolean;
} BracketValue;

typedef struct BracketObject {
  long type;
  BracketValue value;
} BracketObject;

void __br_print__(long argc, BracketObject argv[]);
BracketObject __br_initvector__(long argc,  BracketObject argv[]);

#endif /* LIB_BRACKET_H */
