	.file	"like.c"
	.text
	.section	.rodata
.LC0:
	.string	"steven"
.LC1:
	.string	"I like %s.\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$25, -16(%rbp)
	movq	$.LC0, -8(%rbp)
	movl	-16(%rbp), %eax
	cmpl	$20, %eax
	jle	.L2
	movq	-8(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	printf
.L2:
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.1 20250808 (Red Hat 15.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
