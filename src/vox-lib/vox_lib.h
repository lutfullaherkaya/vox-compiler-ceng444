#ifndef VOX_LIB_H
#define VOX_LIB_H


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

void _vox_vector_integer_add(VoxObject *vector, long integer, VoxObject *result_vector, long size);
void _vox_vector_integer_sub(VoxObject *vector, long integer, VoxObject *result_vector, long size);
void _vox_integer_vector_sub(VoxObject *vector, long integer, VoxObject *result_vector, long size);
void _vox_vector_integer_mul(VoxObject *vector, long integer, VoxObject *result_vector, long size);
void _vox_vector_integer_div(VoxObject *vector, long integer, VoxObject *result_vector, long size);
void _vox_vector_vector_add(VoxObject *vector1, VoxObject *vector2, VoxObject *result_vector, long size);
void _vox_vector_vector_sub(VoxObject *vector1, VoxObject *vector2, VoxObject *result_vector, long size);
void _vox_vector_vector_mul(VoxObject *vector1, VoxObject *vector2, VoxObject *result_vector, long size);
void _vox_vector_vector_div(VoxObject *vector1, VoxObject *vector2, VoxObject *result_vector, long size);

void __vox_print__(VoxObject object);
void __vox_print_without_newline__(VoxObject *object, int print_str_quotes);

VoxObject __vox_add__(VoxObject object1, VoxObject object2);
VoxObject __vox_sub__(VoxObject object1, VoxObject object2);
VoxObject __vox_mul__(VoxObject object1, VoxObject object2);
VoxObject __vox_div__(VoxObject object1, VoxObject object2);

VoxObject len(VoxObject object);
VoxObject type(VoxObject object);

#endif /* VOX_LIB_H */