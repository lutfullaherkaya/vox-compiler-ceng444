	.file	"vox_lib.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0_v1p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
# GNU C17 () version 12.2.0 (riscv64-unknown-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version none
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=rocket -mabi=lp64d -misa-spec=2.2 -march=rv64imafdcv_zve32f_zve32x_zve64d_zve64f_zve64x_zvl128b_zvl32b_zvl64b
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16	#,,
	sd	s0,8(sp)	#,
	addi	s0,sp,16	#,,
# vox_lib.c:7: return 0;
	li	a5,0		# _1,
# vox_lib.c:8: }
	mv	a0,a5	#, <retval>
	ld	s0,8(sp)		#,
	addi	sp,sp,16	#,,
	jr	ra		#
	.size	main, .-main
	.align	1
	.globl	len
	.type	len, @function
len:
	addi	sp,sp,-112	#,,
	sd	ra,104(sp)	#,
	sd	s0,96(sp)	#,
	sd	s2,88(sp)	#,
	sd	s3,80(sp)	#,
	addi	s0,sp,112	#,,
	sd	a0,-112(s0)	#, object
	sd	a1,-104(s0)	#, object
# vox_lib.c:11:     VoxObject result = {VOX_INT, {-1}};
	sd	zero,-88(s0)	#, result.type
	li	a5,-1		# tmp78,
	sd	a5,-80(s0)	# tmp78, result.value.integer
# vox_lib.c:12:     if (object.type == VOX_VECTOR) {
	ld	a4,-112(s0)		# _1, object.type
# vox_lib.c:12:     if (object.type == VOX_VECTOR) {
	li	a5,1		# tmp79,
	bne	a4,a5,.L4	#, _1, tmp79,
# vox_lib.c:13:         VoxObject *vector = object.value.vector;
	ld	a5,-104(s0)		# tmp80, object.value.vector
	sd	a5,-48(s0)	# tmp80, vector
# vox_lib.c:14:         long length = *(((long *) object.value.vector) - 1);
	ld	a5,-104(s0)		# _2, object.value.vector
# vox_lib.c:14:         long length = *(((long *) object.value.vector) - 1);
	ld	a5,-8(a5)		# tmp81, MEM[(long int *)_2 + -8B]
	sd	a5,-56(s0)	# tmp81, length
# vox_lib.c:15:         result.value.integer = length;
	ld	a5,-56(s0)		# tmp82, length
	sd	a5,-80(s0)	# tmp82, result.value.integer
	j	.L5		#
.L4:
# vox_lib.c:16:     } else if (object.type == VOX_STRING) {
	ld	a4,-112(s0)		# _3, object.type
# vox_lib.c:16:     } else if (object.type == VOX_STRING) {
	li	a5,3		# tmp83,
	bne	a4,a5,.L5	#, _3, tmp83,
# vox_lib.c:17:         long length = strlen(object.value.string);
	ld	a5,-104(s0)		# _4, object.value.string
# vox_lib.c:17:         long length = strlen(object.value.string);
	mv	a0,a5	#, _4
	call	strlen		#
	mv	a5,a0	# _5,
# vox_lib.c:17:         long length = strlen(object.value.string);
	sd	a5,-40(s0)	# _5, length
# vox_lib.c:18:         result.value.integer = length;
	ld	a5,-40(s0)		# tmp84, length
	sd	a5,-80(s0)	# tmp84, result.value.integer
.L5:
# vox_lib.c:20:     return result;
	ld	a5,-88(s0)		# tmp85, result
	sd	a5,-72(s0)	# tmp85, D.2775
	ld	a5,-80(s0)		# tmp86, result
	sd	a5,-64(s0)	# tmp86, D.2775
	ld	a4,-72(s0)		# tmp87, D.2775
	ld	a5,-64(s0)		# tmp88, D.2775
	mv	s2,a4	# tmp89, tmp87
	mv	s3,a5	#, tmp88
	mv	a4,s2	# <retval>, tmp89
	mv	a5,s3	# <retval>,
# vox_lib.c:21: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	ra,104(sp)		#,
	ld	s0,96(sp)		#,
	ld	s2,88(sp)		#,
	ld	s3,80(sp)		#,
	addi	sp,sp,112	#,,
	jr	ra		#
	.size	len, .-len
	.section	.rodata
	.align	3
.LC0:
	.string	"int"
	.align	3
.LC1:
	.string	"vector"
	.align	3
.LC2:
	.string	"bool"
	.align	3
.LC3:
	.string	"string"
	.align	3
.LC4:
	.string	"unknown"
	.text
	.align	1
	.globl	type
	.type	type, @function
type:
	addi	sp,sp,-64	#,,
	sd	s0,56(sp)	#,
	addi	s0,sp,64	#,,
	sd	a0,-64(s0)	#, object
	sd	a1,-56(s0)	#, object
# vox_lib.c:24:     VoxObject result = {VOX_STRING};
	sd	zero,-48(s0)	#, result
	sd	zero,-40(s0)	#, result
	li	a5,3		# tmp74,
	sd	a5,-48(s0)	# tmp74, result.type
# vox_lib.c:26:     switch (object.type) {
	ld	a5,-64(s0)		# _1, object.type
# vox_lib.c:26:     switch (object.type) {
	li	a4,3		# tmp75,
	beq	a5,a4,.L8	#, _1, tmp75,
	li	a4,3		# tmp76,
	bgt	a5,a4,.L9	#, _1, tmp76,
	li	a4,2		# tmp77,
	beq	a5,a4,.L10	#, _1, tmp77,
	li	a4,2		# tmp78,
	bgt	a5,a4,.L9	#, _1, tmp78,
	beq	a5,zero,.L11	#, _1,,
	li	a4,1		# tmp79,
	beq	a5,a4,.L12	#, _1, tmp79,
	j	.L9		#
.L11:
# vox_lib.c:28:             result.value.string = "int";
	lui	a5,%hi(.LC0)	# tmp81,
	addi	a5,a5,%lo(.LC0)	# tmp80, tmp81,
	sd	a5,-40(s0)	# tmp80, result.value.string
# vox_lib.c:29:             break;
	j	.L13		#
.L12:
# vox_lib.c:31:             result.value.string = "vector";
	lui	a5,%hi(.LC1)	# tmp83,
	addi	a5,a5,%lo(.LC1)	# tmp82, tmp83,
	sd	a5,-40(s0)	# tmp82, result.value.string
# vox_lib.c:32:             break;
	j	.L13		#
.L10:
# vox_lib.c:34:             result.value.string = "bool";
	lui	a5,%hi(.LC2)	# tmp85,
	addi	a5,a5,%lo(.LC2)	# tmp84, tmp85,
	sd	a5,-40(s0)	# tmp84, result.value.string
# vox_lib.c:35:             break;
	j	.L13		#
.L8:
# vox_lib.c:37:             result.value.string = "string";
	lui	a5,%hi(.LC3)	# tmp87,
	addi	a5,a5,%lo(.LC3)	# tmp86, tmp87,
	sd	a5,-40(s0)	# tmp86, result.value.string
# vox_lib.c:38:             break;
	j	.L13		#
.L9:
# vox_lib.c:40:             result.value.string = "unknown";
	lui	a5,%hi(.LC4)	# tmp89,
	addi	a5,a5,%lo(.LC4)	# tmp88, tmp89,
	sd	a5,-40(s0)	# tmp88, result.value.string
.L13:
# vox_lib.c:42:     return result;
	ld	a5,-48(s0)		# tmp90, result
	sd	a5,-32(s0)	# tmp90, D.2778
	ld	a5,-40(s0)		# tmp91, result
	sd	a5,-24(s0)	# tmp91, D.2778
	ld	a4,-32(s0)		# tmp92, D.2778
	ld	a5,-24(s0)		# tmp93, D.2778
	mv	a2,a4	# tmp94, tmp92
	mv	a3,a5	#, tmp93
	mv	a4,a2	# <retval>, tmp94
	mv	a5,a3	# <retval>,
# vox_lib.c:43: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	s0,56(sp)		#,
	addi	sp,sp,64	#,,
	jr	ra		#
	.size	type, .-type
	.section	.rodata
	.align	3
.LC5:
	.string	"%ld"
	.align	3
.LC6:
	.string	", "
	.align	3
.LC7:
	.string	"true"
	.align	3
.LC8:
	.string	"false"
	.align	3
.LC9:
	.string	"\"%s\""
	.align	3
.LC10:
	.string	"%s"
	.text
	.align	1
	.globl	__vox_print_without_newline__
	.type	__vox_print_without_newline__, @function
__vox_print_without_newline__:
	addi	sp,sp,-64	#,,
	sd	ra,56(sp)	#,
	sd	s0,48(sp)	#,
	addi	s0,sp,64	#,,
	sd	a0,-56(s0)	# object, object
	mv	a5,a1	# tmp86, print_str_quotes
	sw	a5,-60(s0)	# tmp87, print_str_quotes
# vox_lib.c:46:     switch (object->type) {
	ld	a5,-56(s0)		# tmp88, object
	ld	a5,0(a5)		# _1, object_21(D)->type
# vox_lib.c:46:     switch (object->type) {
	li	a4,3		# tmp89,
	beq	a5,a4,.L16	#, _1, tmp89,
	li	a4,3		# tmp90,
	bgt	a5,a4,.L27	#, _1, tmp90,
	li	a4,2		# tmp91,
	beq	a5,a4,.L18	#, _1, tmp91,
	li	a4,2		# tmp92,
	bgt	a5,a4,.L27	#, _1, tmp92,
	beq	a5,zero,.L19	#, _1,,
	li	a4,1		# tmp93,
	beq	a5,a4,.L20	#, _1, tmp93,
# vox_lib.c:82: }
	j	.L27		#
.L19:
# vox_lib.c:48:             printf("%ld", object->value.integer);
	ld	a5,-56(s0)		# tmp94, object
	ld	a5,8(a5)		# _2, object_21(D)->value.integer
	mv	a1,a5	#, _2
	lui	a5,%hi(.LC5)	# tmp95,
	addi	a0,a5,%lo(.LC5)	#, tmp95,
	call	printf		#
# vox_lib.c:49:             break;
	j	.L17		#
.L20:
# vox_lib.c:52:             VoxObject *vector = object->value.vector;
	ld	a5,-56(s0)		# tmp96, object
	ld	a5,8(a5)		# tmp97, object_21(D)->value.vector
	sd	a5,-32(s0)	# tmp97, vector
# vox_lib.c:53:             long length = *(((long *) object->value.vector) - 1);
	ld	a5,-56(s0)		# tmp98, object
	ld	a5,8(a5)		# _3, object_21(D)->value.vector
# vox_lib.c:53:             long length = *(((long *) object->value.vector) - 1);
	ld	a5,-8(a5)		# tmp99, MEM[(long int *)_3 + -8B]
	sd	a5,-40(s0)	# tmp99, length
# vox_lib.c:56:             putchar('[');
	li	a0,91		#,
	call	putchar		#
# vox_lib.c:57:             for (long i = 0; i < length - 1; i++) {
	sd	zero,-24(s0)	#, i
# vox_lib.c:57:             for (long i = 0; i < length - 1; i++) {
	j	.L21		#
.L22:
# vox_lib.c:58:                 __vox_print_without_newline__(&vector[i], 1);
	ld	a5,-24(s0)		# i.0_4, i
	slli	a5,a5,4	#, _5, i.0_4
# vox_lib.c:58:                 __vox_print_without_newline__(&vector[i], 1);
	ld	a4,-32(s0)		# tmp100, vector
	add	a5,a4,a5	# _5, _6, tmp100
	li	a1,1		#,
	mv	a0,a5	#, _6
	call	__vox_print_without_newline__		#
# vox_lib.c:59:                 printf(", ");
	lui	a5,%hi(.LC6)	# tmp101,
	addi	a0,a5,%lo(.LC6)	#, tmp101,
	call	printf		#
# vox_lib.c:57:             for (long i = 0; i < length - 1; i++) {
	ld	a5,-24(s0)		# tmp103, i
	addi	a5,a5,1	#, tmp102, tmp103
	sd	a5,-24(s0)	# tmp102, i
.L21:
# vox_lib.c:57:             for (long i = 0; i < length - 1; i++) {
	ld	a5,-40(s0)		# tmp104, length
	addi	a5,a5,-1	#, _7, tmp104
# vox_lib.c:57:             for (long i = 0; i < length - 1; i++) {
	ld	a4,-24(s0)		# tmp105, i
	blt	a4,a5,.L22	#, tmp105, _7,
# vox_lib.c:61:             __vox_print_without_newline__(&vector[length - 1], 1);
	ld	a5,-40(s0)		# length.1_8, length
	slli	a5,a5,4	#, _9, length.1_8
	addi	a5,a5,-16	#, _10, _9
# vox_lib.c:61:             __vox_print_without_newline__(&vector[length - 1], 1);
	ld	a4,-32(s0)		# tmp106, vector
	add	a5,a4,a5	# _10, _11, tmp106
	li	a1,1		#,
	mv	a0,a5	#, _11
	call	__vox_print_without_newline__		#
# vox_lib.c:62:             putchar(']');
	li	a0,93		#,
	call	putchar		#
# vox_lib.c:63:             break;
	j	.L17		#
.L18:
# vox_lib.c:66:             if (object->value.boolean) printf("true");
	ld	a5,-56(s0)		# tmp107, object
	ld	a5,8(a5)		# _12, object_21(D)->value.boolean
# vox_lib.c:66:             if (object->value.boolean) printf("true");
	beq	a5,zero,.L23	#, _12,,
# vox_lib.c:66:             if (object->value.boolean) printf("true");
	lui	a5,%hi(.LC7)	# tmp108,
	addi	a0,a5,%lo(.LC7)	#, tmp108,
	call	printf		#
# vox_lib.c:68:             break;
	j	.L17		#
.L23:
# vox_lib.c:67:             else printf("false");
	lui	a5,%hi(.LC8)	# tmp109,
	addi	a0,a5,%lo(.LC8)	#, tmp109,
	call	printf		#
# vox_lib.c:68:             break;
	j	.L17		#
.L16:
# vox_lib.c:71:             if (print_str_quotes) {
	lw	a5,-60(s0)		# tmp111, print_str_quotes
	sext.w	a5,a5	# tmp112, tmp110
	beq	a5,zero,.L25	#, tmp112,,
# vox_lib.c:73:                 printf("\"%s\"", object->value.string);
	ld	a5,-56(s0)		# tmp113, object
	ld	a5,8(a5)		# _13, object_21(D)->value.string
	mv	a1,a5	#, _13
	lui	a5,%hi(.LC9)	# tmp114,
	addi	a0,a5,%lo(.LC9)	#, tmp114,
	call	printf		#
# vox_lib.c:78:             break;
	j	.L28		#
.L25:
# vox_lib.c:75:                 printf("%s", object->value.string);
	ld	a5,-56(s0)		# tmp115, object
	ld	a5,8(a5)		# _14, object_21(D)->value.string
	mv	a1,a5	#, _14
	lui	a5,%hi(.LC10)	# tmp116,
	addi	a0,a5,%lo(.LC10)	#, tmp116,
	call	printf		#
.L28:
# vox_lib.c:78:             break;
	nop	
.L17:
.L27:
# vox_lib.c:82: }
	nop	
	ld	ra,56(sp)		#,
	ld	s0,48(sp)		#,
	addi	sp,sp,64	#,,
	jr	ra		#
	.size	__vox_print_without_newline__, .-__vox_print_without_newline__
	.align	1
	.globl	__vox_print__
	.type	__vox_print__, @function
__vox_print__:
	addi	sp,sp,-32	#,,
	sd	ra,24(sp)	#,
	sd	s0,16(sp)	#,
	addi	s0,sp,32	#,,
	sd	a0,-32(s0)	#, object
	sd	a1,-24(s0)	#, object
# vox_lib.c:85:     __vox_print_without_newline__(&object, 0);
	addi	a5,s0,-32	#, tmp72,
	li	a1,0		#,
	mv	a0,a5	#, tmp72
	call	__vox_print_without_newline__		#
# vox_lib.c:86:     putchar('\n');
	li	a0,10		#,
	call	putchar		#
# vox_lib.c:87: }
	nop	
	ld	ra,24(sp)		#,
	ld	s0,16(sp)		#,
	addi	sp,sp,32	#,,
	jr	ra		#
	.size	__vox_print__, .-__vox_print__
	.section	.rodata
	.align	3
.LC11:
	.string	"Vector sizes of"
	.align	3
.LC12:
	.string	"do not match. Runtime error :("
	.text
	.align	1
	.globl	__vox_add__
	.type	__vox_add__, @function
__vox_add__:
	addi	sp,sp,-192	#,,
	sd	ra,184(sp)	#,
	sd	s0,176(sp)	#,
	sd	s2,168(sp)	#,
	sd	s3,160(sp)	#,
	addi	s0,sp,192	#,,
	sd	a0,-176(s0)	#, object1
	sd	a1,-168(s0)	#, object1
	sd	a2,-192(s0)	#, object2
	sd	a3,-184(s0)	#, object2
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-176(s0)		# _1, object1.type
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp99,
	beq	a4,a5,.L31	#, _1, tmp99,
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-192(s0)		# _2, object2.type
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp100,
	bne	a4,a5,.L32	#, _2, tmp100,
.L31:
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# iftmp.2_26,
	j	.L33		#
.L32:
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,0		# iftmp.2_26,
.L33:
# vox_lib.c:92:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	sd	a5,-152(s0)	# _3, return_object.type
# vox_lib.c:94:     if (return_object.type == VOX_VECTOR) {
	ld	a4,-152(s0)		# _4, return_object.type
# vox_lib.c:94:     if (return_object.type == VOX_VECTOR) {
	li	a5,1		# tmp101,
	bne	a4,a5,.L34	#, _4, tmp101,
# vox_lib.c:95:         if (object1.type && object2.type) {
	ld	a5,-176(s0)		# _5, object1.type
# vox_lib.c:95:         if (object1.type && object2.type) {
	beq	a5,zero,.L35	#, _5,,
# vox_lib.c:95:         if (object1.type && object2.type) {
	ld	a5,-192(s0)		# _6, object2.type
# vox_lib.c:95:         if (object1.type && object2.type) {
	beq	a5,zero,.L35	#, _6,,
# vox_lib.c:96:             VoxObject *vector1 = object1.value.vector;
	ld	a5,-168(s0)		# tmp102, object1.value.vector
	sd	a5,-40(s0)	# tmp102, vector1
# vox_lib.c:97:             VoxObject *vector2 = object2.value.vector;
	ld	a5,-184(s0)		# tmp103, object2.value.vector
	sd	a5,-48(s0)	# tmp103, vector2
# vox_lib.c:98:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _7, object1.value.vector
# vox_lib.c:98:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp104, MEM[(long int *)_7 + -8B]
	sd	a5,-56(s0)	# tmp104, length1
# vox_lib.c:99:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _8, object2.value.vector
# vox_lib.c:99:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp105, MEM[(long int *)_8 + -8B]
	sd	a5,-64(s0)	# tmp105, length2
# vox_lib.c:101:             if (length1 != length2) {
	ld	a4,-56(s0)		# tmp106, length1
	ld	a5,-64(s0)		# tmp107, length2
	beq	a4,a5,.L36	#, tmp106, tmp107,
# vox_lib.c:102:                 puts("Vector sizes of");
	lui	a5,%hi(.LC11)	# tmp108,
	addi	a0,a5,%lo(.LC11)	#, tmp108,
	call	puts		#
# vox_lib.c:103:                 __vox_print__(object1);
	ld	a0,-176(s0)		#, object1
	ld	a1,-168(s0)		#, object1
	call	__vox_print__		#
# vox_lib.c:104:                 __vox_print__(object2);
	ld	a0,-192(s0)		#, object2
	ld	a1,-184(s0)		#, object2
	call	__vox_print__		#
# vox_lib.c:105:                 puts("do not match. Runtime error :(");
	lui	a5,%hi(.LC12)	# tmp109,
	addi	a0,a5,%lo(.LC12)	#, tmp109,
	call	puts		#
# vox_lib.c:106:                 exit(1);
	li	a0,1		#,
	call	exit		#
.L36:
# vox_lib.c:109:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	ld	a5,-56(s0)		# tmp110, length1
	slli	a5,a5,1	#, _9, tmp110
# vox_lib.c:109:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _10, _9
# vox_lib.c:109:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _11
	call	calloc		#
	mv	a5,a0	# tmp111,
	sd	a5,-72(s0)	# tmp111, result_vector
# vox_lib.c:110:             *result_vector = length1;
	ld	a5,-72(s0)		# tmp112, result_vector
	ld	a4,-56(s0)		# tmp113, length1
	sd	a4,0(a5)	# tmp113, *result_vector_39
# vox_lib.c:111:             result_vector++;
	ld	a5,-72(s0)		# tmp115, result_vector
	addi	a5,a5,8	#, tmp114, tmp115
	sd	a5,-72(s0)	# tmp114, result_vector
# vox_lib.c:115:             _vox_vector_vector_add(vector1, vector2, (VoxObject *) result_vector, length1);
	ld	a3,-56(s0)		#, length1
	ld	a2,-72(s0)		#, result_vector
	ld	a1,-48(s0)		#, vector2
	ld	a0,-40(s0)		#, vector1
	call	_vox_vector_vector_add		#
# vox_lib.c:117:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-72(s0)		# tmp116, result_vector
	sd	a5,-144(s0)	# tmp116, return_object.value.vector
# vox_lib.c:95:         if (object1.type && object2.type) {
	j	.L39		#
.L35:
# vox_lib.c:118:         } else if (object1.type) {
	ld	a5,-176(s0)		# _12, object1.type
# vox_lib.c:118:         } else if (object1.type) {
	beq	a5,zero,.L38	#, _12,,
# vox_lib.c:119:             VoxObject *vector = object1.value.vector;
	ld	a5,-168(s0)		# tmp117, object1.value.vector
	sd	a5,-104(s0)	# tmp117, vector
# vox_lib.c:120:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _13, object1.value.vector
# vox_lib.c:120:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp118, MEM[(long int *)_13 + -8B]
	sd	a5,-112(s0)	# tmp118, length
# vox_lib.c:121:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-112(s0)		# tmp119, length
	slli	a5,a5,1	#, _14, tmp119
# vox_lib.c:121:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _15, _14
# vox_lib.c:121:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _16
	call	calloc		#
	mv	a5,a0	# tmp120,
	sd	a5,-120(s0)	# tmp120, result_vector
# vox_lib.c:122:             *result_vector = length;
	ld	a5,-120(s0)		# tmp121, result_vector
	ld	a4,-112(s0)		# tmp122, length
	sd	a4,0(a5)	# tmp122, *result_vector_60
# vox_lib.c:123:             result_vector++;
	ld	a5,-120(s0)		# tmp124, result_vector
	addi	a5,a5,8	#, tmp123, tmp124
	sd	a5,-120(s0)	# tmp123, result_vector
# vox_lib.c:125:             _vox_vector_integer_add(vector, object2.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-184(s0)		# _17, object2.value.integer
	ld	a3,-112(s0)		#, length
	ld	a2,-120(s0)		#, result_vector
	mv	a1,a5	#, _17
	ld	a0,-104(s0)		#, vector
	call	_vox_vector_integer_add		#
# vox_lib.c:127:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-120(s0)		# tmp125, result_vector
	sd	a5,-144(s0)	# tmp125, return_object.value.vector
	j	.L39		#
.L38:
# vox_lib.c:129:             VoxObject *vector = object2.value.vector;
	ld	a5,-184(s0)		# tmp126, object2.value.vector
	sd	a5,-80(s0)	# tmp126, vector
# vox_lib.c:130:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _18, object2.value.vector
# vox_lib.c:130:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp127, MEM[(long int *)_18 + -8B]
	sd	a5,-88(s0)	# tmp127, length
# vox_lib.c:131:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-88(s0)		# tmp128, length
	slli	a5,a5,1	#, _19, tmp128
# vox_lib.c:131:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _20, _19
# vox_lib.c:131:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _21
	call	calloc		#
	mv	a5,a0	# tmp129,
	sd	a5,-96(s0)	# tmp129, result_vector
# vox_lib.c:132:             *result_vector = length;
	ld	a5,-96(s0)		# tmp130, result_vector
	ld	a4,-88(s0)		# tmp131, length
	sd	a4,0(a5)	# tmp131, *result_vector_52
# vox_lib.c:133:             result_vector++;
	ld	a5,-96(s0)		# tmp133, result_vector
	addi	a5,a5,8	#, tmp132, tmp133
	sd	a5,-96(s0)	# tmp132, result_vector
# vox_lib.c:135:             _vox_vector_integer_add(vector, object1.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-168(s0)		# _22, object1.value.integer
	ld	a3,-88(s0)		#, length
	ld	a2,-96(s0)		#, result_vector
	mv	a1,a5	#, _22
	ld	a0,-80(s0)		#, vector
	call	_vox_vector_integer_add		#
# vox_lib.c:137:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-96(s0)		# tmp134, result_vector
	sd	a5,-144(s0)	# tmp134, return_object.value.vector
	j	.L39		#
.L34:
# vox_lib.c:139:     } else return_object.value.integer = object1.value.integer + object2.value.integer;
	ld	a4,-168(s0)		# _23, object1.value.integer
# vox_lib.c:139:     } else return_object.value.integer = object1.value.integer + object2.value.integer;
	ld	a5,-184(s0)		# _24, object2.value.integer
# vox_lib.c:139:     } else return_object.value.integer = object1.value.integer + object2.value.integer;
	add	a5,a4,a5	# _24, _25, _23
# vox_lib.c:139:     } else return_object.value.integer = object1.value.integer + object2.value.integer;
	sd	a5,-144(s0)	# _25, return_object.value.integer
.L39:
# vox_lib.c:141:     return return_object;
	ld	a5,-152(s0)		# tmp135, return_object
	sd	a5,-136(s0)	# tmp135, D.2805
	ld	a5,-144(s0)		# tmp136, return_object
	sd	a5,-128(s0)	# tmp136, D.2805
	ld	a4,-136(s0)		# tmp137, D.2805
	ld	a5,-128(s0)		# tmp138, D.2805
	mv	s2,a4	# tmp139, tmp137
	mv	s3,a5	#, tmp138
	mv	a4,s2	# <retval>, tmp139
	mv	a5,s3	# <retval>,
# vox_lib.c:142: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	ra,184(sp)		#,
	ld	s0,176(sp)		#,
	ld	s2,168(sp)		#,
	ld	s3,160(sp)		#,
	addi	sp,sp,192	#,,
	jr	ra		#
	.size	__vox_add__, .-__vox_add__
	.align	1
	.globl	__vox_sub__
	.type	__vox_sub__, @function
__vox_sub__:
	addi	sp,sp,-192	#,,
	sd	ra,184(sp)	#,
	sd	s0,176(sp)	#,
	sd	s2,168(sp)	#,
	sd	s3,160(sp)	#,
	addi	s0,sp,192	#,,
	sd	a0,-176(s0)	#, object1
	sd	a1,-168(s0)	#, object1
	sd	a2,-192(s0)	#, object2
	sd	a3,-184(s0)	#, object2
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-176(s0)		# _1, object1.type
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp99,
	beq	a4,a5,.L42	#, _1, tmp99,
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-192(s0)		# _2, object2.type
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp100,
	bne	a4,a5,.L43	#, _2, tmp100,
.L42:
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# iftmp.3_26,
	j	.L44		#
.L43:
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,0		# iftmp.3_26,
.L44:
# vox_lib.c:146:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	sd	a5,-152(s0)	# _3, return_object.type
# vox_lib.c:148:     if (return_object.type == VOX_VECTOR) {
	ld	a4,-152(s0)		# _4, return_object.type
# vox_lib.c:148:     if (return_object.type == VOX_VECTOR) {
	li	a5,1		# tmp101,
	bne	a4,a5,.L45	#, _4, tmp101,
# vox_lib.c:149:         if (object1.type && object2.type) {
	ld	a5,-176(s0)		# _5, object1.type
# vox_lib.c:149:         if (object1.type && object2.type) {
	beq	a5,zero,.L46	#, _5,,
# vox_lib.c:149:         if (object1.type && object2.type) {
	ld	a5,-192(s0)		# _6, object2.type
# vox_lib.c:149:         if (object1.type && object2.type) {
	beq	a5,zero,.L46	#, _6,,
# vox_lib.c:150:             VoxObject *vector1 = object1.value.vector;
	ld	a5,-168(s0)		# tmp102, object1.value.vector
	sd	a5,-40(s0)	# tmp102, vector1
# vox_lib.c:151:             VoxObject *vector2 = object2.value.vector;
	ld	a5,-184(s0)		# tmp103, object2.value.vector
	sd	a5,-48(s0)	# tmp103, vector2
# vox_lib.c:152:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _7, object1.value.vector
# vox_lib.c:152:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp104, MEM[(long int *)_7 + -8B]
	sd	a5,-56(s0)	# tmp104, length1
# vox_lib.c:153:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _8, object2.value.vector
# vox_lib.c:153:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp105, MEM[(long int *)_8 + -8B]
	sd	a5,-64(s0)	# tmp105, length2
# vox_lib.c:155:             if (length1 != length2) {
	ld	a4,-56(s0)		# tmp106, length1
	ld	a5,-64(s0)		# tmp107, length2
	beq	a4,a5,.L47	#, tmp106, tmp107,
# vox_lib.c:156:                 puts("Vector sizes of");
	lui	a5,%hi(.LC11)	# tmp108,
	addi	a0,a5,%lo(.LC11)	#, tmp108,
	call	puts		#
# vox_lib.c:157:                 __vox_print__(object1);
	ld	a0,-176(s0)		#, object1
	ld	a1,-168(s0)		#, object1
	call	__vox_print__		#
# vox_lib.c:158:                 __vox_print__(object2);
	ld	a0,-192(s0)		#, object2
	ld	a1,-184(s0)		#, object2
	call	__vox_print__		#
# vox_lib.c:159:                 puts("do not match. Runtime error :(");
	lui	a5,%hi(.LC12)	# tmp109,
	addi	a0,a5,%lo(.LC12)	#, tmp109,
	call	puts		#
# vox_lib.c:160:                 exit(1);
	li	a0,1		#,
	call	exit		#
.L47:
# vox_lib.c:163:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	ld	a5,-56(s0)		# tmp110, length1
	slli	a5,a5,1	#, _9, tmp110
# vox_lib.c:163:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _10, _9
# vox_lib.c:163:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _11
	call	calloc		#
	mv	a5,a0	# tmp111,
	sd	a5,-72(s0)	# tmp111, result_vector
# vox_lib.c:164:             *result_vector = length1;
	ld	a5,-72(s0)		# tmp112, result_vector
	ld	a4,-56(s0)		# tmp113, length1
	sd	a4,0(a5)	# tmp113, *result_vector_39
# vox_lib.c:165:             result_vector++;
	ld	a5,-72(s0)		# tmp115, result_vector
	addi	a5,a5,8	#, tmp114, tmp115
	sd	a5,-72(s0)	# tmp114, result_vector
# vox_lib.c:169:             _vox_vector_vector_sub(vector1, vector2, (VoxObject *) result_vector, length1);
	ld	a3,-56(s0)		#, length1
	ld	a2,-72(s0)		#, result_vector
	ld	a1,-48(s0)		#, vector2
	ld	a0,-40(s0)		#, vector1
	call	_vox_vector_vector_sub		#
# vox_lib.c:171:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-72(s0)		# tmp116, result_vector
	sd	a5,-144(s0)	# tmp116, return_object.value.vector
# vox_lib.c:149:         if (object1.type && object2.type) {
	j	.L50		#
.L46:
# vox_lib.c:172:         } else if (object1.type) {
	ld	a5,-176(s0)		# _12, object1.type
# vox_lib.c:172:         } else if (object1.type) {
	beq	a5,zero,.L49	#, _12,,
# vox_lib.c:173:             VoxObject *vector = object1.value.vector;
	ld	a5,-168(s0)		# tmp117, object1.value.vector
	sd	a5,-104(s0)	# tmp117, vector
# vox_lib.c:174:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _13, object1.value.vector
# vox_lib.c:174:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp118, MEM[(long int *)_13 + -8B]
	sd	a5,-112(s0)	# tmp118, length
# vox_lib.c:175:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-112(s0)		# tmp119, length
	slli	a5,a5,1	#, _14, tmp119
# vox_lib.c:175:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _15, _14
# vox_lib.c:175:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _16
	call	calloc		#
	mv	a5,a0	# tmp120,
	sd	a5,-120(s0)	# tmp120, result_vector
# vox_lib.c:176:             *result_vector = length;
	ld	a5,-120(s0)		# tmp121, result_vector
	ld	a4,-112(s0)		# tmp122, length
	sd	a4,0(a5)	# tmp122, *result_vector_60
# vox_lib.c:177:             result_vector++;
	ld	a5,-120(s0)		# tmp124, result_vector
	addi	a5,a5,8	#, tmp123, tmp124
	sd	a5,-120(s0)	# tmp123, result_vector
# vox_lib.c:179:             _vox_vector_integer_sub(vector, object2.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-184(s0)		# _17, object2.value.integer
	ld	a3,-112(s0)		#, length
	ld	a2,-120(s0)		#, result_vector
	mv	a1,a5	#, _17
	ld	a0,-104(s0)		#, vector
	call	_vox_vector_integer_sub		#
# vox_lib.c:181:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-120(s0)		# tmp125, result_vector
	sd	a5,-144(s0)	# tmp125, return_object.value.vector
	j	.L50		#
.L49:
# vox_lib.c:183:             VoxObject *vector = object2.value.vector;
	ld	a5,-184(s0)		# tmp126, object2.value.vector
	sd	a5,-80(s0)	# tmp126, vector
# vox_lib.c:184:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _18, object2.value.vector
# vox_lib.c:184:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp127, MEM[(long int *)_18 + -8B]
	sd	a5,-88(s0)	# tmp127, length
# vox_lib.c:185:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-88(s0)		# tmp128, length
	slli	a5,a5,1	#, _19, tmp128
# vox_lib.c:185:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _20, _19
# vox_lib.c:185:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _21
	call	calloc		#
	mv	a5,a0	# tmp129,
	sd	a5,-96(s0)	# tmp129, result_vector
# vox_lib.c:186:             *result_vector = length;
	ld	a5,-96(s0)		# tmp130, result_vector
	ld	a4,-88(s0)		# tmp131, length
	sd	a4,0(a5)	# tmp131, *result_vector_52
# vox_lib.c:187:             result_vector++;
	ld	a5,-96(s0)		# tmp133, result_vector
	addi	a5,a5,8	#, tmp132, tmp133
	sd	a5,-96(s0)	# tmp132, result_vector
# vox_lib.c:189:             _vox_integer_vector_sub(vector, object1.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-168(s0)		# _22, object1.value.integer
	ld	a3,-88(s0)		#, length
	ld	a2,-96(s0)		#, result_vector
	mv	a1,a5	#, _22
	ld	a0,-80(s0)		#, vector
	call	_vox_integer_vector_sub		#
# vox_lib.c:191:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-96(s0)		# tmp134, result_vector
	sd	a5,-144(s0)	# tmp134, return_object.value.vector
	j	.L50		#
.L45:
# vox_lib.c:193:     } else return_object.value.integer = object1.value.integer - object2.value.integer;
	ld	a4,-168(s0)		# _23, object1.value.integer
# vox_lib.c:193:     } else return_object.value.integer = object1.value.integer - object2.value.integer;
	ld	a5,-184(s0)		# _24, object2.value.integer
# vox_lib.c:193:     } else return_object.value.integer = object1.value.integer - object2.value.integer;
	sub	a5,a4,a5	# _25, _23, _24
# vox_lib.c:193:     } else return_object.value.integer = object1.value.integer - object2.value.integer;
	sd	a5,-144(s0)	# _25, return_object.value.integer
.L50:
# vox_lib.c:195:     return return_object;
	ld	a5,-152(s0)		# tmp135, return_object
	sd	a5,-136(s0)	# tmp135, D.2825
	ld	a5,-144(s0)		# tmp136, return_object
	sd	a5,-128(s0)	# tmp136, D.2825
	ld	a4,-136(s0)		# tmp137, D.2825
	ld	a5,-128(s0)		# tmp138, D.2825
	mv	s2,a4	# tmp139, tmp137
	mv	s3,a5	#, tmp138
	mv	a4,s2	# <retval>, tmp139
	mv	a5,s3	# <retval>,
# vox_lib.c:196: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	ra,184(sp)		#,
	ld	s0,176(sp)		#,
	ld	s2,168(sp)		#,
	ld	s3,160(sp)		#,
	addi	sp,sp,192	#,,
	jr	ra		#
	.size	__vox_sub__, .-__vox_sub__
	.align	1
	.globl	__vox_mul__
	.type	__vox_mul__, @function
__vox_mul__:
	addi	sp,sp,-192	#,,
	sd	ra,184(sp)	#,
	sd	s0,176(sp)	#,
	sd	s2,168(sp)	#,
	sd	s3,160(sp)	#,
	addi	s0,sp,192	#,,
	sd	a0,-176(s0)	#, object1
	sd	a1,-168(s0)	#, object1
	sd	a2,-192(s0)	#, object2
	sd	a3,-184(s0)	#, object2
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-176(s0)		# _1, object1.type
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp99,
	beq	a4,a5,.L53	#, _1, tmp99,
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-192(s0)		# _2, object2.type
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp100,
	bne	a4,a5,.L54	#, _2, tmp100,
.L53:
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# iftmp.4_26,
	j	.L55		#
.L54:
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,0		# iftmp.4_26,
.L55:
# vox_lib.c:200:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	sd	a5,-152(s0)	# _3, return_object.type
# vox_lib.c:202:     if (return_object.type == VOX_VECTOR) {
	ld	a4,-152(s0)		# _4, return_object.type
# vox_lib.c:202:     if (return_object.type == VOX_VECTOR) {
	li	a5,1		# tmp101,
	bne	a4,a5,.L56	#, _4, tmp101,
# vox_lib.c:203:         if (object1.type && object2.type) {
	ld	a5,-176(s0)		# _5, object1.type
# vox_lib.c:203:         if (object1.type && object2.type) {
	beq	a5,zero,.L57	#, _5,,
# vox_lib.c:203:         if (object1.type && object2.type) {
	ld	a5,-192(s0)		# _6, object2.type
# vox_lib.c:203:         if (object1.type && object2.type) {
	beq	a5,zero,.L57	#, _6,,
# vox_lib.c:204:             VoxObject *vector1 = object1.value.vector;
	ld	a5,-168(s0)		# tmp102, object1.value.vector
	sd	a5,-40(s0)	# tmp102, vector1
# vox_lib.c:205:             VoxObject *vector2 = object2.value.vector;
	ld	a5,-184(s0)		# tmp103, object2.value.vector
	sd	a5,-48(s0)	# tmp103, vector2
# vox_lib.c:206:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _7, object1.value.vector
# vox_lib.c:206:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp104, MEM[(long int *)_7 + -8B]
	sd	a5,-56(s0)	# tmp104, length1
# vox_lib.c:207:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _8, object2.value.vector
# vox_lib.c:207:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp105, MEM[(long int *)_8 + -8B]
	sd	a5,-64(s0)	# tmp105, length2
# vox_lib.c:209:             if (length1 != length2) {
	ld	a4,-56(s0)		# tmp106, length1
	ld	a5,-64(s0)		# tmp107, length2
	beq	a4,a5,.L58	#, tmp106, tmp107,
# vox_lib.c:210:                 puts("Vector sizes of");
	lui	a5,%hi(.LC11)	# tmp108,
	addi	a0,a5,%lo(.LC11)	#, tmp108,
	call	puts		#
# vox_lib.c:211:                 __vox_print__(object1);
	ld	a0,-176(s0)		#, object1
	ld	a1,-168(s0)		#, object1
	call	__vox_print__		#
# vox_lib.c:212:                 __vox_print__(object2);
	ld	a0,-192(s0)		#, object2
	ld	a1,-184(s0)		#, object2
	call	__vox_print__		#
# vox_lib.c:213:                 puts("do not match. Runtime error :(");
	lui	a5,%hi(.LC12)	# tmp109,
	addi	a0,a5,%lo(.LC12)	#, tmp109,
	call	puts		#
# vox_lib.c:214:                 exit(1);
	li	a0,1		#,
	call	exit		#
.L58:
# vox_lib.c:217:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	ld	a5,-56(s0)		# tmp110, length1
	slli	a5,a5,1	#, _9, tmp110
# vox_lib.c:217:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _10, _9
# vox_lib.c:217:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _11
	call	calloc		#
	mv	a5,a0	# tmp111,
	sd	a5,-72(s0)	# tmp111, result_vector
# vox_lib.c:218:             *result_vector = length1;
	ld	a5,-72(s0)		# tmp112, result_vector
	ld	a4,-56(s0)		# tmp113, length1
	sd	a4,0(a5)	# tmp113, *result_vector_39
# vox_lib.c:219:             result_vector++;
	ld	a5,-72(s0)		# tmp115, result_vector
	addi	a5,a5,8	#, tmp114, tmp115
	sd	a5,-72(s0)	# tmp114, result_vector
# vox_lib.c:223:             _vox_vector_vector_mul(vector1, vector2, (VoxObject *) result_vector, length1);
	ld	a3,-56(s0)		#, length1
	ld	a2,-72(s0)		#, result_vector
	ld	a1,-48(s0)		#, vector2
	ld	a0,-40(s0)		#, vector1
	call	_vox_vector_vector_mul		#
# vox_lib.c:225:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-72(s0)		# tmp116, result_vector
	sd	a5,-144(s0)	# tmp116, return_object.value.vector
# vox_lib.c:203:         if (object1.type && object2.type) {
	j	.L61		#
.L57:
# vox_lib.c:226:         } else if (object1.type) {
	ld	a5,-176(s0)		# _12, object1.type
# vox_lib.c:226:         } else if (object1.type) {
	beq	a5,zero,.L60	#, _12,,
# vox_lib.c:227:             VoxObject *vector = object1.value.vector;
	ld	a5,-168(s0)		# tmp117, object1.value.vector
	sd	a5,-104(s0)	# tmp117, vector
# vox_lib.c:228:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-168(s0)		# _13, object1.value.vector
# vox_lib.c:228:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp118, MEM[(long int *)_13 + -8B]
	sd	a5,-112(s0)	# tmp118, length
# vox_lib.c:229:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-112(s0)		# tmp119, length
	slli	a5,a5,1	#, _14, tmp119
# vox_lib.c:229:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _15, _14
# vox_lib.c:229:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _16
	call	calloc		#
	mv	a5,a0	# tmp120,
	sd	a5,-120(s0)	# tmp120, result_vector
# vox_lib.c:230:             *result_vector = length;
	ld	a5,-120(s0)		# tmp121, result_vector
	ld	a4,-112(s0)		# tmp122, length
	sd	a4,0(a5)	# tmp122, *result_vector_60
# vox_lib.c:231:             result_vector++;
	ld	a5,-120(s0)		# tmp124, result_vector
	addi	a5,a5,8	#, tmp123, tmp124
	sd	a5,-120(s0)	# tmp123, result_vector
# vox_lib.c:233:             _vox_vector_integer_mul(vector, object2.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-184(s0)		# _17, object2.value.integer
	ld	a3,-112(s0)		#, length
	ld	a2,-120(s0)		#, result_vector
	mv	a1,a5	#, _17
	ld	a0,-104(s0)		#, vector
	call	_vox_vector_integer_mul		#
# vox_lib.c:235:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-120(s0)		# tmp125, result_vector
	sd	a5,-144(s0)	# tmp125, return_object.value.vector
	j	.L61		#
.L60:
# vox_lib.c:237:             VoxObject *vector = object2.value.vector;
	ld	a5,-184(s0)		# tmp126, object2.value.vector
	sd	a5,-80(s0)	# tmp126, vector
# vox_lib.c:238:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-184(s0)		# _18, object2.value.vector
# vox_lib.c:238:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp127, MEM[(long int *)_18 + -8B]
	sd	a5,-88(s0)	# tmp127, length
# vox_lib.c:239:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-88(s0)		# tmp128, length
	slli	a5,a5,1	#, _19, tmp128
# vox_lib.c:239:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _20, _19
# vox_lib.c:239:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _21
	call	calloc		#
	mv	a5,a0	# tmp129,
	sd	a5,-96(s0)	# tmp129, result_vector
# vox_lib.c:240:             *result_vector = length;
	ld	a5,-96(s0)		# tmp130, result_vector
	ld	a4,-88(s0)		# tmp131, length
	sd	a4,0(a5)	# tmp131, *result_vector_52
# vox_lib.c:241:             result_vector++;
	ld	a5,-96(s0)		# tmp133, result_vector
	addi	a5,a5,8	#, tmp132, tmp133
	sd	a5,-96(s0)	# tmp132, result_vector
# vox_lib.c:243:             _vox_vector_integer_mul(vector, object1.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-168(s0)		# _22, object1.value.integer
	ld	a3,-88(s0)		#, length
	ld	a2,-96(s0)		#, result_vector
	mv	a1,a5	#, _22
	ld	a0,-80(s0)		#, vector
	call	_vox_vector_integer_mul		#
# vox_lib.c:245:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-96(s0)		# tmp134, result_vector
	sd	a5,-144(s0)	# tmp134, return_object.value.vector
	j	.L61		#
.L56:
# vox_lib.c:247:     } else return_object.value.integer = object1.value.integer * object2.value.integer;
	ld	a4,-168(s0)		# _23, object1.value.integer
# vox_lib.c:247:     } else return_object.value.integer = object1.value.integer * object2.value.integer;
	ld	a5,-184(s0)		# _24, object2.value.integer
# vox_lib.c:247:     } else return_object.value.integer = object1.value.integer * object2.value.integer;
	mul	a5,a4,a5	# _25, _23, _24
# vox_lib.c:247:     } else return_object.value.integer = object1.value.integer * object2.value.integer;
	sd	a5,-144(s0)	# _25, return_object.value.integer
.L61:
# vox_lib.c:249:     return return_object;
	ld	a5,-152(s0)		# tmp135, return_object
	sd	a5,-136(s0)	# tmp135, D.2845
	ld	a5,-144(s0)		# tmp136, return_object
	sd	a5,-128(s0)	# tmp136, D.2845
	ld	a4,-136(s0)		# tmp137, D.2845
	ld	a5,-128(s0)		# tmp138, D.2845
	mv	s2,a4	# tmp139, tmp137
	mv	s3,a5	#, tmp138
	mv	a4,s2	# <retval>, tmp139
	mv	a5,s3	# <retval>,
# vox_lib.c:250: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	ra,184(sp)		#,
	ld	s0,176(sp)		#,
	ld	s2,168(sp)		#,
	ld	s3,160(sp)		#,
	addi	sp,sp,192	#,,
	jr	ra		#
	.size	__vox_mul__, .-__vox_mul__
	.align	1
	.globl	__vox_div__
	.type	__vox_div__, @function
__vox_div__:
	addi	sp,sp,-208	#,,
	sd	ra,200(sp)	#,
	sd	s0,192(sp)	#,
	sd	s2,184(sp)	#,
	sd	s3,176(sp)	#,
	addi	s0,sp,208	#,,
	sd	a0,-192(s0)	#, object1
	sd	a1,-184(s0)	#, object1
	sd	a2,-208(s0)	#, object2
	sd	a3,-200(s0)	#, object2
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-192(s0)		# _1, object1.type
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp107,
	beq	a4,a5,.L64	#, _1, tmp107,
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	ld	a4,-208(s0)		# _2, object2.type
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# tmp108,
	bne	a4,a5,.L65	#, _2, tmp108,
.L64:
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,1		# iftmp.5_35,
	j	.L66		#
.L65:
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	li	a5,0		# iftmp.5_35,
.L66:
# vox_lib.c:254:     return_object.type = object1.type == VOX_VECTOR || object2.type == VOX_VECTOR;
	sd	a5,-168(s0)	# _3, return_object.type
# vox_lib.c:256:     if (return_object.type == VOX_VECTOR) {
	ld	a4,-168(s0)		# _4, return_object.type
# vox_lib.c:256:     if (return_object.type == VOX_VECTOR) {
	li	a5,1		# tmp109,
	bne	a4,a5,.L67	#, _4, tmp109,
# vox_lib.c:257:         if (object1.type && object2.type) {
	ld	a5,-192(s0)		# _5, object1.type
# vox_lib.c:257:         if (object1.type && object2.type) {
	beq	a5,zero,.L68	#, _5,,
# vox_lib.c:257:         if (object1.type && object2.type) {
	ld	a5,-208(s0)		# _6, object2.type
# vox_lib.c:257:         if (object1.type && object2.type) {
	beq	a5,zero,.L68	#, _6,,
# vox_lib.c:258:             VoxObject *vector1 = object1.value.vector;
	ld	a5,-184(s0)		# tmp110, object1.value.vector
	sd	a5,-48(s0)	# tmp110, vector1
# vox_lib.c:259:             VoxObject *vector2 = object2.value.vector;
	ld	a5,-200(s0)		# tmp111, object2.value.vector
	sd	a5,-56(s0)	# tmp111, vector2
# vox_lib.c:260:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-184(s0)		# _7, object1.value.vector
# vox_lib.c:260:             long length1 = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp112, MEM[(long int *)_7 + -8B]
	sd	a5,-64(s0)	# tmp112, length1
# vox_lib.c:261:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-200(s0)		# _8, object2.value.vector
# vox_lib.c:261:             long length2 = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp113, MEM[(long int *)_8 + -8B]
	sd	a5,-72(s0)	# tmp113, length2
# vox_lib.c:263:             if (length1 != length2) {
	ld	a4,-64(s0)		# tmp114, length1
	ld	a5,-72(s0)		# tmp115, length2
	beq	a4,a5,.L69	#, tmp114, tmp115,
# vox_lib.c:264:                 puts("Vector sizes of");
	lui	a5,%hi(.LC11)	# tmp116,
	addi	a0,a5,%lo(.LC11)	#, tmp116,
	call	puts		#
# vox_lib.c:265:                 __vox_print__(object1);
	ld	a0,-192(s0)		#, object1
	ld	a1,-184(s0)		#, object1
	call	__vox_print__		#
# vox_lib.c:266:                 __vox_print__(object2);
	ld	a0,-208(s0)		#, object2
	ld	a1,-200(s0)		#, object2
	call	__vox_print__		#
# vox_lib.c:267:                 puts("do not match. Runtime error :(");
	lui	a5,%hi(.LC12)	# tmp117,
	addi	a0,a5,%lo(.LC12)	#, tmp117,
	call	puts		#
# vox_lib.c:268:                 exit(1);
	li	a0,1		#,
	call	exit		#
.L69:
# vox_lib.c:271:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	ld	a5,-64(s0)		# tmp118, length1
	slli	a5,a5,1	#, _9, tmp118
# vox_lib.c:271:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _10, _9
# vox_lib.c:271:             long *result_vector = (long *) calloc(length1 * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _11
	call	calloc		#
	mv	a5,a0	# tmp119,
	sd	a5,-80(s0)	# tmp119, result_vector
# vox_lib.c:272:             *result_vector = length1;
	ld	a5,-80(s0)		# tmp120, result_vector
	ld	a4,-64(s0)		# tmp121, length1
	sd	a4,0(a5)	# tmp121, *result_vector_49
# vox_lib.c:273:             result_vector++;
	ld	a5,-80(s0)		# tmp123, result_vector
	addi	a5,a5,8	#, tmp122, tmp123
	sd	a5,-80(s0)	# tmp122, result_vector
# vox_lib.c:277:             _vox_vector_vector_div(vector1, vector2, (VoxObject *) result_vector, length1);
	ld	a3,-64(s0)		#, length1
	ld	a2,-80(s0)		#, result_vector
	ld	a1,-56(s0)		#, vector2
	ld	a0,-48(s0)		#, vector1
	call	_vox_vector_vector_div		#
# vox_lib.c:279:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-80(s0)		# tmp124, result_vector
	sd	a5,-160(s0)	# tmp124, return_object.value.vector
# vox_lib.c:257:         if (object1.type && object2.type) {
	j	.L74		#
.L68:
# vox_lib.c:280:         } else if (object1.type) {
	ld	a5,-192(s0)		# _12, object1.type
# vox_lib.c:280:         } else if (object1.type) {
	beq	a5,zero,.L71	#, _12,,
# vox_lib.c:281:             VoxObject *vector = object1.value.vector;
	ld	a5,-184(s0)		# tmp125, object1.value.vector
	sd	a5,-120(s0)	# tmp125, vector
# vox_lib.c:282:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-184(s0)		# _13, object1.value.vector
# vox_lib.c:282:             long length = *(((long *) object1.value.vector) - 1);
	ld	a5,-8(a5)		# tmp126, MEM[(long int *)_13 + -8B]
	sd	a5,-128(s0)	# tmp126, length
# vox_lib.c:283:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-128(s0)		# tmp127, length
	slli	a5,a5,1	#, _14, tmp127
# vox_lib.c:283:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _15, _14
# vox_lib.c:283:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _16
	call	calloc		#
	mv	a5,a0	# tmp128,
	sd	a5,-136(s0)	# tmp128, result_vector
# vox_lib.c:284:             *result_vector = length;
	ld	a5,-136(s0)		# tmp129, result_vector
	ld	a4,-128(s0)		# tmp130, length
	sd	a4,0(a5)	# tmp130, *result_vector_73
# vox_lib.c:285:             result_vector++;
	ld	a5,-136(s0)		# tmp132, result_vector
	addi	a5,a5,8	#, tmp131, tmp132
	sd	a5,-136(s0)	# tmp131, result_vector
# vox_lib.c:287:             _vox_vector_integer_div(vector, object2.value.integer, (VoxObject *) result_vector, length);
	ld	a5,-200(s0)		# _17, object2.value.integer
	ld	a3,-128(s0)		#, length
	ld	a2,-136(s0)		#, result_vector
	mv	a1,a5	#, _17
	ld	a0,-120(s0)		#, vector
	call	_vox_vector_integer_div		#
# vox_lib.c:289:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-136(s0)		# tmp133, result_vector
	sd	a5,-160(s0)	# tmp133, return_object.value.vector
	j	.L74		#
.L71:
# vox_lib.c:291:             VoxObject *vector = object2.value.vector;
	ld	a5,-200(s0)		# tmp134, object2.value.vector
	sd	a5,-88(s0)	# tmp134, vector
# vox_lib.c:292:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-200(s0)		# _18, object2.value.vector
# vox_lib.c:292:             long length = *(((long *) object2.value.vector) - 1);
	ld	a5,-8(a5)		# tmp135, MEM[(long int *)_18 + -8B]
	sd	a5,-96(s0)	# tmp135, length
# vox_lib.c:293:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	ld	a5,-96(s0)		# tmp136, length
	slli	a5,a5,1	#, _19, tmp136
# vox_lib.c:293:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	addi	a5,a5,1	#, _20, _19
# vox_lib.c:293:             long *result_vector = (long *) calloc(length * 2 + 1, sizeof(long));
	li	a1,8		#,
	mv	a0,a5	#, _21
	call	calloc		#
	mv	a5,a0	# tmp137,
	sd	a5,-104(s0)	# tmp137, result_vector
# vox_lib.c:294:             *result_vector = length;
	ld	a5,-104(s0)		# tmp138, result_vector
	ld	a4,-96(s0)		# tmp139, length
	sd	a4,0(a5)	# tmp139, *result_vector_62
# vox_lib.c:295:             result_vector++;
	ld	a5,-104(s0)		# tmp141, result_vector
	addi	a5,a5,8	#, tmp140, tmp141
	sd	a5,-104(s0)	# tmp140, result_vector
# vox_lib.c:296:             VoxObject *result_object_vector = (VoxObject *) result_vector;
	ld	a5,-104(s0)		# tmp142, result_vector
	sd	a5,-112(s0)	# tmp142, result_object_vector
# vox_lib.c:299:             for (long i = 0; i < length; ++i) {
	sd	zero,-40(s0)	#, i
# vox_lib.c:299:             for (long i = 0; i < length; ++i) {
	j	.L72		#
.L73:
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	ld	a3,-184(s0)		# _22, object1.value.integer
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	ld	a5,-40(s0)		# i.6_23, i
	slli	a5,a5,4	#, _24, i.6_23
	ld	a4,-88(s0)		# tmp143, vector
	add	a5,a4,a5	# _24, _25, tmp143
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	ld	a4,8(a5)		# _26, _25->value.integer
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	ld	a5,-40(s0)		# i.7_27, i
	slli	a5,a5,4	#, _28, i.7_27
	ld	a2,-112(s0)		# tmp144, result_object_vector
	add	a5,a2,a5	# _28, _29, tmp144
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	div	a4,a3,a4	# _26, _30, _22
# vox_lib.c:300:                 result_object_vector[i].value.integer = object1.value.integer / vector[i].value.integer;
	sd	a4,8(a5)	# _30, _29->value.integer
# vox_lib.c:299:             for (long i = 0; i < length; ++i) {
	ld	a5,-40(s0)		# tmp146, i
	addi	a5,a5,1	#, tmp145, tmp146
	sd	a5,-40(s0)	# tmp145, i
.L72:
# vox_lib.c:299:             for (long i = 0; i < length; ++i) {
	ld	a4,-40(s0)		# tmp147, i
	ld	a5,-96(s0)		# tmp148, length
	blt	a4,a5,.L73	#, tmp147, tmp148,
# vox_lib.c:303:             return_object.value.vector = (VoxObject *) result_vector;
	ld	a5,-104(s0)		# tmp149, result_vector
	sd	a5,-160(s0)	# tmp149, return_object.value.vector
	j	.L74		#
.L67:
# vox_lib.c:305:     } else return_object.value.integer = object1.value.integer / object2.value.integer;
	ld	a4,-184(s0)		# _31, object1.value.integer
# vox_lib.c:305:     } else return_object.value.integer = object1.value.integer / object2.value.integer;
	ld	a5,-200(s0)		# _32, object2.value.integer
# vox_lib.c:305:     } else return_object.value.integer = object1.value.integer / object2.value.integer;
	div	a5,a4,a5	# _32, _33, _31
# vox_lib.c:305:     } else return_object.value.integer = object1.value.integer / object2.value.integer;
	sd	a5,-160(s0)	# _33, return_object.value.integer
.L74:
# vox_lib.c:307:     return return_object;
	ld	a5,-168(s0)		# tmp150, return_object
	sd	a5,-152(s0)	# tmp150, D.2865
	ld	a5,-160(s0)		# tmp151, return_object
	sd	a5,-144(s0)	# tmp151, D.2865
	ld	a4,-152(s0)		# tmp152, D.2865
	ld	a5,-144(s0)		# tmp153, D.2865
	mv	s2,a4	# tmp154, tmp152
	mv	s3,a5	#, tmp153
	mv	a4,s2	# <retval>, tmp154
	mv	a5,s3	# <retval>,
# vox_lib.c:308: }
	mv	a0,a4	#, <retval>
	mv	a1,a5	#, <retval>
	ld	ra,200(sp)		#,
	ld	s0,192(sp)		#,
	ld	s2,184(sp)		#,
	ld	s3,176(sp)		#,
	addi	sp,sp,208	#,,
	jr	ra		#
	.size	__vox_div__, .-__vox_div__
	.ident	"GCC: () 12.2.0"
	.section	.note.GNU-stack,"",@progbits
