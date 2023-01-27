	.file	"vox_lib.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0_v1p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	s0,8(sp)
	addi	s0,sp,16
	li	a5,0
	mv	a0,a5
	ld	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.align	1
	.globl	len
	.type	len, @function
len:
	addi	sp,sp,-112
	sd	ra,104(sp)
	sd	s0,96(sp)
	sd	s2,88(sp)
	sd	s3,80(sp)
	addi	s0,sp,112
	sd	a0,-112(s0)
	sd	a1,-104(s0)
	sd	zero,-88(s0)
	li	a5,-1
	sd	a5,-80(s0)
	ld	a4,-112(s0)
	li	a5,1
	bne	a4,a5,.L4
	ld	a5,-104(s0)
	sd	a5,-48(s0)
	ld	a5,-104(s0)
	ld	a5,-8(a5)
	sd	a5,-56(s0)
	ld	a5,-56(s0)
	sd	a5,-80(s0)
	j	.L5
.L4:
	ld	a4,-112(s0)
	li	a5,3
	bne	a4,a5,.L5
	ld	a5,-104(s0)
	mv	a0,a5
	call	strlen
	mv	a5,a0
	sd	a5,-40(s0)
	ld	a5,-40(s0)
	sd	a5,-80(s0)
.L5:
	ld	a5,-88(s0)
	sd	a5,-72(s0)
	ld	a5,-80(s0)
	sd	a5,-64(s0)
	ld	a4,-72(s0)
	ld	a5,-64(s0)
	mv	s2,a4
	mv	s3,a5
	mv	a4,s2
	mv	a5,s3
	mv	a0,a4
	mv	a1,a5
	ld	ra,104(sp)
	ld	s0,96(sp)
	ld	s2,88(sp)
	ld	s3,80(sp)
	addi	sp,sp,112
	jr	ra
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
	addi	sp,sp,-64
	sd	s0,56(sp)
	addi	s0,sp,64
	sd	a0,-64(s0)
	sd	a1,-56(s0)
	sd	zero,-48(s0)
	sd	zero,-40(s0)
	li	a5,3
	sd	a5,-48(s0)
	ld	a5,-64(s0)
	li	a4,3
	beq	a5,a4,.L8
	li	a4,3
	bgt	a5,a4,.L9
	li	a4,2
	beq	a5,a4,.L10
	li	a4,2
	bgt	a5,a4,.L9
	beq	a5,zero,.L11
	li	a4,1
	beq	a5,a4,.L12
	j	.L9
.L11:
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	sd	a5,-40(s0)
	j	.L13
.L12:
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
	sd	a5,-40(s0)
	j	.L13
.L10:
	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	sd	a5,-40(s0)
	j	.L13
.L8:
	lui	a5,%hi(.LC3)
	addi	a5,a5,%lo(.LC3)
	sd	a5,-40(s0)
	j	.L13
.L9:
	lui	a5,%hi(.LC4)
	addi	a5,a5,%lo(.LC4)
	sd	a5,-40(s0)
.L13:
	ld	a5,-48(s0)
	sd	a5,-32(s0)
	ld	a5,-40(s0)
	sd	a5,-24(s0)
	ld	a4,-32(s0)
	ld	a5,-24(s0)
	mv	a2,a4
	mv	a3,a5
	mv	a4,a2
	mv	a5,a3
	mv	a0,a4
	mv	a1,a5
	ld	s0,56(sp)
	addi	sp,sp,64
	jr	ra
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
	addi	sp,sp,-64
	sd	ra,56(sp)
	sd	s0,48(sp)
	addi	s0,sp,64
	sd	a0,-56(s0)
	mv	a5,a1
	sw	a5,-60(s0)
	ld	a5,-56(s0)
	ld	a5,0(a5)
	li	a4,3
	beq	a5,a4,.L16
	li	a4,3
	bgt	a5,a4,.L27
	li	a4,2
	beq	a5,a4,.L18
	li	a4,2
	bgt	a5,a4,.L27
	beq	a5,zero,.L19
	li	a4,1
	beq	a5,a4,.L20
	j	.L27
.L19:
	ld	a5,-56(s0)
	ld	a5,8(a5)
	mv	a1,a5
	lui	a5,%hi(.LC5)
	addi	a0,a5,%lo(.LC5)
	call	printf
	j	.L17
.L20:
	ld	a5,-56(s0)
	ld	a5,8(a5)
	sd	a5,-32(s0)
	ld	a5,-56(s0)
	ld	a5,8(a5)
	ld	a5,-8(a5)
	sd	a5,-40(s0)
	li	a0,91
	call	putchar
	sd	zero,-24(s0)
	j	.L21
.L22:
	ld	a5,-24(s0)
	slli	a5,a5,4
	ld	a4,-32(s0)
	add	a5,a4,a5
	li	a1,1
	mv	a0,a5
	call	__vox_print_without_newline__
	lui	a5,%hi(.LC6)
	addi	a0,a5,%lo(.LC6)
	call	printf
	ld	a5,-24(s0)
	addi	a5,a5,1
	sd	a5,-24(s0)
.L21:
	ld	a5,-40(s0)
	addi	a5,a5,-1
	ld	a4,-24(s0)
	blt	a4,a5,.L22
	ld	a5,-40(s0)
	slli	a5,a5,4
	addi	a5,a5,-16
	ld	a4,-32(s0)
	add	a5,a4,a5
	li	a1,1
	mv	a0,a5
	call	__vox_print_without_newline__
	li	a0,93
	call	putchar
	j	.L17
.L18:
	ld	a5,-56(s0)
	ld	a5,8(a5)
	beq	a5,zero,.L23
	lui	a5,%hi(.LC7)
	addi	a0,a5,%lo(.LC7)
	call	printf
	j	.L17
.L23:
	lui	a5,%hi(.LC8)
	addi	a0,a5,%lo(.LC8)
	call	printf
	j	.L17
.L16:
	lw	a5,-60(s0)
	sext.w	a5,a5
	beq	a5,zero,.L25
	ld	a5,-56(s0)
	ld	a5,8(a5)
	mv	a1,a5
	lui	a5,%hi(.LC9)
	addi	a0,a5,%lo(.LC9)
	call	printf
	j	.L28
.L25:
	ld	a5,-56(s0)
	ld	a5,8(a5)
	mv	a1,a5
	lui	a5,%hi(.LC10)
	addi	a0,a5,%lo(.LC10)
	call	printf
.L28:
	nop
.L17:
.L27:
	nop
	ld	ra,56(sp)
	ld	s0,48(sp)
	addi	sp,sp,64
	jr	ra
	.size	__vox_print_without_newline__, .-__vox_print_without_newline__
	.align	1
	.globl	__vox_print__
	.type	__vox_print__, @function
__vox_print__:
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	sd	a0,-32(s0)
	sd	a1,-24(s0)
	addi	a5,s0,-32
	li	a1,0
	mv	a0,a5
	call	__vox_print_without_newline__
	li	a0,10
	call	putchar
	nop
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
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
	addi	sp,sp,-192
	sd	ra,184(sp)
	sd	s0,176(sp)
	sd	s2,168(sp)
	sd	s3,160(sp)
	addi	s0,sp,192
	sd	a0,-176(s0)
	sd	a1,-168(s0)
	sd	a2,-192(s0)
	sd	a3,-184(s0)
	ld	a4,-176(s0)
	li	a5,1
	beq	a4,a5,.L31
	ld	a4,-192(s0)
	li	a5,1
	bne	a4,a5,.L32
.L31:
	li	a5,1
	j	.L33
.L32:
	li	a5,0
.L33:
	sd	a5,-152(s0)
	ld	a4,-152(s0)
	li	a5,1
	bne	a4,a5,.L34
	ld	a5,-176(s0)
	beq	a5,zero,.L35
	ld	a5,-192(s0)
	beq	a5,zero,.L35
	ld	a5,-168(s0)
	sd	a5,-40(s0)
	ld	a5,-184(s0)
	sd	a5,-48(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-56(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-64(s0)
	ld	a4,-56(s0)
	ld	a5,-64(s0)
	beq	a4,a5,.L36
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	puts
	ld	a0,-176(s0)
	ld	a1,-168(s0)
	call	__vox_print__
	ld	a0,-192(s0)
	ld	a1,-184(s0)
	call	__vox_print__
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	puts
	li	a0,1
	call	exit
.L36:
	ld	a5,-56(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-72(s0)
	ld	a5,-72(s0)
	ld	a4,-56(s0)
	sd	a4,0(a5)
	ld	a5,-72(s0)
	addi	a5,a5,8
	sd	a5,-72(s0)
	ld	a3,-56(s0)
	ld	a2,-72(s0)
	ld	a1,-48(s0)
	ld	a0,-40(s0)
	call	_vox_vector_vector_add
	ld	a5,-72(s0)
	sd	a5,-144(s0)
	j	.L39
.L35:
	ld	a5,-176(s0)
	beq	a5,zero,.L38
	ld	a5,-168(s0)
	sd	a5,-104(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-112(s0)
	ld	a5,-112(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-120(s0)
	ld	a5,-120(s0)
	ld	a4,-112(s0)
	sd	a4,0(a5)
	ld	a5,-120(s0)
	addi	a5,a5,8
	sd	a5,-120(s0)
	ld	a5,-184(s0)
	ld	a3,-112(s0)
	ld	a2,-120(s0)
	mv	a1,a5
	ld	a0,-104(s0)
	call	_vox_vector_integer_add
	ld	a5,-120(s0)
	sd	a5,-144(s0)
	j	.L39
.L38:
	ld	a5,-184(s0)
	sd	a5,-80(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-88(s0)
	ld	a5,-88(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-96(s0)
	ld	a5,-96(s0)
	ld	a4,-88(s0)
	sd	a4,0(a5)
	ld	a5,-96(s0)
	addi	a5,a5,8
	sd	a5,-96(s0)
	ld	a5,-168(s0)
	ld	a3,-88(s0)
	ld	a2,-96(s0)
	mv	a1,a5
	ld	a0,-80(s0)
	call	_vox_vector_integer_add
	ld	a5,-96(s0)
	sd	a5,-144(s0)
	j	.L39
.L34:
	ld	a4,-168(s0)
	ld	a5,-184(s0)
	add	a5,a4,a5
	sd	a5,-144(s0)
.L39:
	ld	a5,-152(s0)
	sd	a5,-136(s0)
	ld	a5,-144(s0)
	sd	a5,-128(s0)
	ld	a4,-136(s0)
	ld	a5,-128(s0)
	mv	s2,a4
	mv	s3,a5
	mv	a4,s2
	mv	a5,s3
	mv	a0,a4
	mv	a1,a5
	ld	ra,184(sp)
	ld	s0,176(sp)
	ld	s2,168(sp)
	ld	s3,160(sp)
	addi	sp,sp,192
	jr	ra
	.size	__vox_add__, .-__vox_add__
	.align	1
	.globl	__vox_sub__
	.type	__vox_sub__, @function
__vox_sub__:
	addi	sp,sp,-192
	sd	ra,184(sp)
	sd	s0,176(sp)
	sd	s2,168(sp)
	sd	s3,160(sp)
	addi	s0,sp,192
	sd	a0,-176(s0)
	sd	a1,-168(s0)
	sd	a2,-192(s0)
	sd	a3,-184(s0)
	ld	a4,-176(s0)
	li	a5,1
	beq	a4,a5,.L42
	ld	a4,-192(s0)
	li	a5,1
	bne	a4,a5,.L43
.L42:
	li	a5,1
	j	.L44
.L43:
	li	a5,0
.L44:
	sd	a5,-152(s0)
	ld	a4,-152(s0)
	li	a5,1
	bne	a4,a5,.L45
	ld	a5,-176(s0)
	beq	a5,zero,.L46
	ld	a5,-192(s0)
	beq	a5,zero,.L46
	ld	a5,-168(s0)
	sd	a5,-40(s0)
	ld	a5,-184(s0)
	sd	a5,-48(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-56(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-64(s0)
	ld	a4,-56(s0)
	ld	a5,-64(s0)
	beq	a4,a5,.L47
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	puts
	ld	a0,-176(s0)
	ld	a1,-168(s0)
	call	__vox_print__
	ld	a0,-192(s0)
	ld	a1,-184(s0)
	call	__vox_print__
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	puts
	li	a0,1
	call	exit
.L47:
	ld	a5,-56(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-72(s0)
	ld	a5,-72(s0)
	ld	a4,-56(s0)
	sd	a4,0(a5)
	ld	a5,-72(s0)
	addi	a5,a5,8
	sd	a5,-72(s0)
	ld	a3,-56(s0)
	ld	a2,-72(s0)
	ld	a1,-48(s0)
	ld	a0,-40(s0)
	call	_vox_vector_vector_sub
	ld	a5,-72(s0)
	sd	a5,-144(s0)
	j	.L50
.L46:
	ld	a5,-176(s0)
	beq	a5,zero,.L49
	ld	a5,-168(s0)
	sd	a5,-104(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-112(s0)
	ld	a5,-112(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-120(s0)
	ld	a5,-120(s0)
	ld	a4,-112(s0)
	sd	a4,0(a5)
	ld	a5,-120(s0)
	addi	a5,a5,8
	sd	a5,-120(s0)
	ld	a5,-184(s0)
	ld	a3,-112(s0)
	ld	a2,-120(s0)
	mv	a1,a5
	ld	a0,-104(s0)
	call	_vox_vector_integer_sub
	ld	a5,-120(s0)
	sd	a5,-144(s0)
	j	.L50
.L49:
	ld	a5,-184(s0)
	sd	a5,-80(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-88(s0)
	ld	a5,-88(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-96(s0)
	ld	a5,-96(s0)
	ld	a4,-88(s0)
	sd	a4,0(a5)
	ld	a5,-96(s0)
	addi	a5,a5,8
	sd	a5,-96(s0)
	ld	a5,-168(s0)
	ld	a3,-88(s0)
	ld	a2,-96(s0)
	mv	a1,a5
	ld	a0,-80(s0)
	call	_vox_integer_vector_sub
	ld	a5,-96(s0)
	sd	a5,-144(s0)
	j	.L50
.L45:
	ld	a4,-168(s0)
	ld	a5,-184(s0)
	sub	a5,a4,a5
	sd	a5,-144(s0)
.L50:
	ld	a5,-152(s0)
	sd	a5,-136(s0)
	ld	a5,-144(s0)
	sd	a5,-128(s0)
	ld	a4,-136(s0)
	ld	a5,-128(s0)
	mv	s2,a4
	mv	s3,a5
	mv	a4,s2
	mv	a5,s3
	mv	a0,a4
	mv	a1,a5
	ld	ra,184(sp)
	ld	s0,176(sp)
	ld	s2,168(sp)
	ld	s3,160(sp)
	addi	sp,sp,192
	jr	ra
	.size	__vox_sub__, .-__vox_sub__
	.align	1
	.globl	__vox_mul__
	.type	__vox_mul__, @function
__vox_mul__:
	addi	sp,sp,-192
	sd	ra,184(sp)
	sd	s0,176(sp)
	sd	s2,168(sp)
	sd	s3,160(sp)
	addi	s0,sp,192
	sd	a0,-176(s0)
	sd	a1,-168(s0)
	sd	a2,-192(s0)
	sd	a3,-184(s0)
	ld	a4,-176(s0)
	li	a5,1
	beq	a4,a5,.L53
	ld	a4,-192(s0)
	li	a5,1
	bne	a4,a5,.L54
.L53:
	li	a5,1
	j	.L55
.L54:
	li	a5,0
.L55:
	sd	a5,-152(s0)
	ld	a4,-152(s0)
	li	a5,1
	bne	a4,a5,.L56
	ld	a5,-176(s0)
	beq	a5,zero,.L57
	ld	a5,-192(s0)
	beq	a5,zero,.L57
	ld	a5,-168(s0)
	sd	a5,-40(s0)
	ld	a5,-184(s0)
	sd	a5,-48(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-56(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-64(s0)
	ld	a4,-56(s0)
	ld	a5,-64(s0)
	beq	a4,a5,.L58
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	puts
	ld	a0,-176(s0)
	ld	a1,-168(s0)
	call	__vox_print__
	ld	a0,-192(s0)
	ld	a1,-184(s0)
	call	__vox_print__
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	puts
	li	a0,1
	call	exit
.L58:
	ld	a5,-56(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-72(s0)
	ld	a5,-72(s0)
	ld	a4,-56(s0)
	sd	a4,0(a5)
	ld	a5,-72(s0)
	addi	a5,a5,8
	sd	a5,-72(s0)
	ld	a3,-56(s0)
	ld	a2,-72(s0)
	ld	a1,-48(s0)
	ld	a0,-40(s0)
	call	_vox_vector_vector_mul
	ld	a5,-72(s0)
	sd	a5,-144(s0)
	j	.L61
.L57:
	ld	a5,-176(s0)
	beq	a5,zero,.L60
	ld	a5,-168(s0)
	sd	a5,-104(s0)
	ld	a5,-168(s0)
	ld	a5,-8(a5)
	sd	a5,-112(s0)
	ld	a5,-112(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-120(s0)
	ld	a5,-120(s0)
	ld	a4,-112(s0)
	sd	a4,0(a5)
	ld	a5,-120(s0)
	addi	a5,a5,8
	sd	a5,-120(s0)
	ld	a5,-184(s0)
	ld	a3,-112(s0)
	ld	a2,-120(s0)
	mv	a1,a5
	ld	a0,-104(s0)
	call	_vox_vector_integer_mul
	ld	a5,-120(s0)
	sd	a5,-144(s0)
	j	.L61
.L60:
	ld	a5,-184(s0)
	sd	a5,-80(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-88(s0)
	ld	a5,-88(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-96(s0)
	ld	a5,-96(s0)
	ld	a4,-88(s0)
	sd	a4,0(a5)
	ld	a5,-96(s0)
	addi	a5,a5,8
	sd	a5,-96(s0)
	ld	a5,-168(s0)
	ld	a3,-88(s0)
	ld	a2,-96(s0)
	mv	a1,a5
	ld	a0,-80(s0)
	call	_vox_vector_integer_mul
	ld	a5,-96(s0)
	sd	a5,-144(s0)
	j	.L61
.L56:
	ld	a4,-168(s0)
	ld	a5,-184(s0)
	mul	a5,a4,a5
	sd	a5,-144(s0)
.L61:
	ld	a5,-152(s0)
	sd	a5,-136(s0)
	ld	a5,-144(s0)
	sd	a5,-128(s0)
	ld	a4,-136(s0)
	ld	a5,-128(s0)
	mv	s2,a4
	mv	s3,a5
	mv	a4,s2
	mv	a5,s3
	mv	a0,a4
	mv	a1,a5
	ld	ra,184(sp)
	ld	s0,176(sp)
	ld	s2,168(sp)
	ld	s3,160(sp)
	addi	sp,sp,192
	jr	ra
	.size	__vox_mul__, .-__vox_mul__
	.align	1
	.globl	__vox_div__
	.type	__vox_div__, @function
__vox_div__:
	addi	sp,sp,-208
	sd	ra,200(sp)
	sd	s0,192(sp)
	sd	s2,184(sp)
	sd	s3,176(sp)
	addi	s0,sp,208
	sd	a0,-192(s0)
	sd	a1,-184(s0)
	sd	a2,-208(s0)
	sd	a3,-200(s0)
	ld	a4,-192(s0)
	li	a5,1
	beq	a4,a5,.L64
	ld	a4,-208(s0)
	li	a5,1
	bne	a4,a5,.L65
.L64:
	li	a5,1
	j	.L66
.L65:
	li	a5,0
.L66:
	sd	a5,-168(s0)
	ld	a4,-168(s0)
	li	a5,1
	bne	a4,a5,.L67
	ld	a5,-192(s0)
	beq	a5,zero,.L68
	ld	a5,-208(s0)
	beq	a5,zero,.L68
	ld	a5,-184(s0)
	sd	a5,-48(s0)
	ld	a5,-200(s0)
	sd	a5,-56(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-64(s0)
	ld	a5,-200(s0)
	ld	a5,-8(a5)
	sd	a5,-72(s0)
	ld	a4,-64(s0)
	ld	a5,-72(s0)
	beq	a4,a5,.L69
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	puts
	ld	a0,-192(s0)
	ld	a1,-184(s0)
	call	__vox_print__
	ld	a0,-208(s0)
	ld	a1,-200(s0)
	call	__vox_print__
	lui	a5,%hi(.LC12)
	addi	a0,a5,%lo(.LC12)
	call	puts
	li	a0,1
	call	exit
.L69:
	ld	a5,-64(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-80(s0)
	ld	a5,-80(s0)
	ld	a4,-64(s0)
	sd	a4,0(a5)
	ld	a5,-80(s0)
	addi	a5,a5,8
	sd	a5,-80(s0)
	ld	a3,-64(s0)
	ld	a2,-80(s0)
	ld	a1,-56(s0)
	ld	a0,-48(s0)
	call	_vox_vector_vector_div
	ld	a5,-80(s0)
	sd	a5,-160(s0)
	j	.L74
.L68:
	ld	a5,-192(s0)
	beq	a5,zero,.L71
	ld	a5,-184(s0)
	sd	a5,-120(s0)
	ld	a5,-184(s0)
	ld	a5,-8(a5)
	sd	a5,-128(s0)
	ld	a5,-128(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-136(s0)
	ld	a5,-136(s0)
	ld	a4,-128(s0)
	sd	a4,0(a5)
	ld	a5,-136(s0)
	addi	a5,a5,8
	sd	a5,-136(s0)
	ld	a5,-200(s0)
	ld	a3,-128(s0)
	ld	a2,-136(s0)
	mv	a1,a5
	ld	a0,-120(s0)
	call	_vox_vector_integer_div
	ld	a5,-136(s0)
	sd	a5,-160(s0)
	j	.L74
.L71:
	ld	a5,-200(s0)
	sd	a5,-88(s0)
	ld	a5,-200(s0)
	ld	a5,-8(a5)
	sd	a5,-96(s0)
	ld	a5,-96(s0)
	slli	a5,a5,1
	addi	a5,a5,1
	li	a1,8
	mv	a0,a5
	call	calloc
	mv	a5,a0
	sd	a5,-104(s0)
	ld	a5,-104(s0)
	ld	a4,-96(s0)
	sd	a4,0(a5)
	ld	a5,-104(s0)
	addi	a5,a5,8
	sd	a5,-104(s0)
	ld	a5,-104(s0)
	sd	a5,-112(s0)
	sd	zero,-40(s0)
	j	.L72
.L73:
	ld	a3,-184(s0)
	ld	a5,-40(s0)
	slli	a5,a5,4
	ld	a4,-88(s0)
	add	a5,a4,a5
	ld	a4,8(a5)
	ld	a5,-40(s0)
	slli	a5,a5,4
	ld	a2,-112(s0)
	add	a5,a2,a5
	div	a4,a3,a4
	sd	a4,8(a5)
	ld	a5,-40(s0)
	addi	a5,a5,1
	sd	a5,-40(s0)
.L72:
	ld	a4,-40(s0)
	ld	a5,-96(s0)
	blt	a4,a5,.L73
	ld	a5,-104(s0)
	sd	a5,-160(s0)
	j	.L74
.L67:
	ld	a4,-184(s0)
	ld	a5,-200(s0)
	div	a5,a4,a5
	sd	a5,-160(s0)
.L74:
	ld	a5,-168(s0)
	sd	a5,-152(s0)
	ld	a5,-160(s0)
	sd	a5,-144(s0)
	ld	a4,-152(s0)
	ld	a5,-144(s0)
	mv	s2,a4
	mv	s3,a5
	mv	a4,s2
	mv	a5,s3
	mv	a0,a4
	mv	a1,a5
	ld	ra,200(sp)
	ld	s0,192(sp)
	ld	s2,184(sp)
	ld	s3,176(sp)
	addi	sp,sp,208
	jr	ra
	.size	__vox_div__, .-__vox_div__
	.ident	"GCC: () 12.2.0"
	.section	.note.GNU-stack,"",@progbits
