	.file	"clock_tick.c"
	.text
	.p2align 4,,15
	.globl	clock_tick
	.def	clock_tick;	.scl	2;	.type	32;	.endef
	.seh_proc	clock_tick
clock_tick:
	.seh_endprologue
	movl	$1000, %eax
	ret
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-W64 project) 8.1.0"
