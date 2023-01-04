#include "vox_lib.h"
#include <stdio.h>
#include <stdlib.h>

VoxObject len(VoxObject object) {
    VoxObject result = {VOX_INT, {-1}};
    if (object.type == VOX_VECTOR) {
        VoxObject *vector = object.value.vector;
        long length = *(((long *) object.value.vector) - 1);
        result.value.integer = length;
    } else if (object.type == VOX_STRING) {
        // todo: implement
    }
    return result;
}

void __vox_print_without_newline__(VoxObject *object, int print_str_quotes) {
    switch (object->type) {
        case VOX_INT: {
            printf("%ld", object->value.integer);
            break;
        }
        case VOX_VECTOR: {
            VoxObject *vector = object->value.vector;
            long length = *(((long *) object->value.vector) - 1);


            putchar('[');
            for (long i = 0; i < length - 1; i++) {
                __vox_print_without_newline__(&vector[i], 1);
                printf(", ");
            }
            __vox_print_without_newline__(&vector[length - 1], 1);
            putchar(']');
            break;
        }
        case VOX_BOOL: {
            if (object->value.boolean) printf("true");
            else printf("false");
            break;
        }
        case VOX_STRING: {
            if (print_str_quotes) {
                /* todo: escape newlines and tabs */
                printf("\"%s\"", object->value.string);
            } else {
                printf("%s", object->value.string);
            }

            break;
        }
    }

}

void __vox_print__(VoxObject object) {
    __vox_print_without_newline__(&object, 0);
    putchar('\n');
}


VoxObject __vox_add__(VoxObject object1, VoxObject object2) {
    VoxObject return_object;
    return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;

    if (return_object.type == VOX_VECTOR) {
        if (object1.type && object2.type) {
            VoxObject *vector1 = object1.value.vector;
            VoxObject *vector2 = object2.value.vector;
            long length1 = *(((long *) object1.value.vector) - 1);
            long length2 = *(((long *) object2.value.vector) - 1);

            if (length1 != length2) {
                puts("Vector sizes of");
                __vox_print__(object1);
                __vox_print__(object2);
                puts("do not match. Runtime error :(");
                exit(1);
            }

            long *result_vector = (long *) malloc(length1 * sizeof(VoxObject) + sizeof(long));
            *result_vector = length1;
            result_vector++;
            /* yess, did not think it would work but it worked just like i had hoped. this adds only the values and not types,
            * thus we give the first vectors value as long array
            */
            _br_vector_vector_add(vector1, vector2, (VoxObject *) result_vector, length1);

            return_object.value.vector = (VoxObject *) result_vector;
        } else if (object1.type) {
            VoxObject *vector = object1.value.vector;
            long length = *(((long *) object1.value.vector) - 1);
            long *result_vector = (long *) malloc(length * sizeof(VoxObject) + sizeof(long));
            *result_vector = length;
            result_vector++;

            _br_vector_integer_add(vector, object2.value.integer, (VoxObject *) result_vector, length);

            return_object.value.vector = (VoxObject *) result_vector;
        } else {
            VoxObject *vector = object2.value.vector;
            long length = *(((long *) object2.value.vector) - 1);
            long *result_vector = (long *) malloc(length * sizeof(VoxObject) + sizeof(long));
            *result_vector = length;
            result_vector++;

            _br_vector_integer_add(vector, object1.value.integer, (VoxObject *) result_vector, length);

            return_object.value.vector = (VoxObject *) result_vector;
        }
    } else return_object.value.integer = object1.value.integer + object2.value.integer;

    return return_object;
}
