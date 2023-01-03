#ifndef VOX_LIB_H
#define VOX_LIB_H

void _br_vector_integer_add(long *vector, long integer, long *result_vector, long size);

void _br_vector_vector_add(long *vector1, long *vector2, long *result_vector, long size);

#define VOX_INT 0
#define VOX_VECTOR 1
#define VOX_BOOL 2
#define VOX_STRING 3

struct VoxObject;

typedef union VoxValue {
    long integer;
    struct VoxObject *vector;
    long boolean;
    char *string;
} VoxValue;

typedef struct VoxObject {
    long type;
    VoxValue value;
} VoxObject;

void __vox_print__(long argc, VoxObject argv[]);
void __vox_print_without_newline__(long argc, VoxObject argv[]);

VoxObject __br_initvector__(long argc, VoxObject argv[]);

#endif /* VOX_LIB_H */
