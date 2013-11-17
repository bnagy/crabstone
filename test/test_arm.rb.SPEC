**********
Platforms: ARM
0x1000: bl	#0xffffffffffffffb4
	op_count: 1
		operands[1].type: IMM = 0x4294967220

0x1004: str	lr, [sp, #-0x4]!
	Update-flags: True
	op_count: 2
		operands[1].type: REG = lr
		operands[2].type: MEM
			operands[2].mem.base: REG = sp
			operands[2].mem.disp = 4294967292

0x1008: andeq	r0, r0, r0
	Code condition: 1
	op_count: 3
		operands[1].type: REG = r0
		operands[2].type: REG = r0
		operands[3].type: REG = r0

0x100c: str	r8, [r2, #-0x3e0]!
	Update-flags: True
	op_count: 2
		operands[1].type: REG = r8
		operands[2].type: MEM
			operands[2].mem.base: REG = r2
			operands[2].mem.disp = 4294966304

0x1010: mcreq	p02, #0x0, r0, c03, c01, #0x7
	Code condition: 1
	op_count: 6
		operands[1].type: P-IMM = 0x2
		operands[2].type: IMM = 0x0
		operands[3].type: REG = r0
		operands[4].type: C-IMM = 0x3
		operands[5].type: C-IMM = 0x1
		operands[6].type: IMM = 0x7

0x1014: mov	r0, #0x0
	op_count: 2
		operands[1].type: REG = r0
		operands[2].type: IMM = 0x0

0x1018: strb	r3, [r1, r2]
	op_count: 2
		operands[1].type: REG = r3
		operands[2].type: MEM
			operands[2].mem.base: REG = r1
			operands[2].mem.index: REG = r2

0x101c: cmp	r3, #0x0
	Writeback: True
	op_count: 2
		operands[1].type: REG = r3
		operands[2].type: IMM = 0x0

**********
Platforms: THUMB-2
0x1000: mov.w	r1, #0x0
	op_count: 2
		operands[1].type: REG = r1
		operands[2].type: IMM = 0x0

0x1004: pop.w	{r11, pc}
	op_count: 2
		operands[1].type: REG = r11
		operands[2].type: REG = pc

0x1008: tbb	[r1, r0]
	op_count: 1
		operands[1].type: MEM
			operands[1].mem.base: REG = r1
			operands[1].mem.index: REG = r0

**********
Platforms: ARM: Cortex-A15 + NEON
0x1000: sdiv	r0, r0, r1
	op_count: 3
		operands[1].type: REG = r0
		operands[2].type: REG = r0
		operands[3].type: REG = r1

0x1004: udiv	r1, r1, r2
	op_count: 3
		operands[1].type: REG = r1
		operands[2].type: REG = r1
		operands[3].type: REG = r2

0x1008: vbit	q5, q15, q6
	op_count: 3
		operands[1].type: REG = q5
		operands[2].type: REG = q15
		operands[3].type: REG = q6

0x100c: vcgt.f32	q10, q9, q12
	op_count: 3
		operands[1].type: REG = q10
		operands[2].type: REG = q9
		operands[3].type: REG = q12

**********
Platforms: THUMB
0x1000: bx	lr
	op_count: 1
		operands[1].type: REG = lr

0x1002: mov	r11, sp
	op_count: 2
		operands[1].type: REG = r11
		operands[2].type: REG = sp

0x1004: sub	sp, #0xc
	op_count: 2
		operands[1].type: REG = sp
		operands[2].type: IMM = 0x12

0x1006: ldr	r1, [r1, #0xc]
	op_count: 2
		operands[1].type: REG = r1
		operands[2].type: MEM
			operands[2].mem.base: REG = r1
			operands[2].mem.disp = 12

