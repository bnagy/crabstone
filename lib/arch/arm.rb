# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

module Crabstone
  module ARM

    class OperandShift < FFI::Struct
      layout(
        :type, :uint,
        :value, :uint
      )
    end

    class MemoryOperand < FFI::Struct
      layout(
        :base, :uint,
        :index, :uint,
        :scale, :int,
        :disp, :int64
      )
    end

    class OperandValue < FFI::Union
      layout(
        :reg, :uint,
        :imm, :long_long,
        :fp, :double,
        :mem, MemoryOperand
      )
    end

    class Operand < FFI::Struct
      layout(
        :shift, OperandShift,
        :type, :uint,
        :value, OperandValue
      )

      def value
        case self[:type]
        when OP_REG
          self[:value][:reg]
        when OP_IMM
          self[:value][:imm]
        when OP_MEM
          self[:value][:mem]
        when OP_FP
          self[:value][:fp]
        else
          nil
        end
      end

      def reg?
        self[:type] == OP_REG
      end

      def imm?
        self[:type] == OP_IMM
      end

      def cimm?
        self[:type] == OP_CIMM
      end

      def pimm?
        self[:type] == OP_PIMM
      end

      def mem?
        self[:type] == OP_MEM
      end

      def fp?
        self[:type] == OP_FP
      end

      def valid?
        [OP_MEM, OP_IMM, OP_CIMM, OP_PIMM, OP_FP, OP_REG].include? self[:type]
      end
    end

    class Instruction < FFI::Struct
      layout(
        :cc, :uint,
        :update_flags, :bool,
        :writeback, :bool,
        :op_count, :uint8,
        :operands, [Operand, 32]
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # ARM operand shift type
    SFT_INVALID = 0
    SFT_ASR     = 1
    SFT_LSL     = 2
    SFT_LSR     = 3
    SFT_ROR     = 4
    SFT_RRX     = 5
    SFT_ASR_REG = 6
    SFT_LSL_REG = 7
    SFT_LSR_REG = 8
    SFT_ROR_REG = 9
    SFT_RRX_REG = 10

    # ARM code condition type
    CC_INVALID = 0
    CC_EQ      = 1
    CC_NE      = 2
    CC_HS      = 3
    CC_LO      = 4
    CC_MI      = 5
    CC_PL      = 6
    CC_VS      = 7
    CC_VC      = 8
    CC_HI      = 9
    CC_LS      = 10
    CC_GE      = 11
    CC_LT      = 12
    CC_GT      = 13
    CC_LE      = 14
    CC_AL      = 15

    # Operand type
    OP_INVALID = 0  # Uninitialized.
    OP_REG     = 1   # Register operand.
    OP_CIMM    = 2   # C-Immediate operand.
    OP_PIMM    = 3   # C-Immediate operand.
    OP_IMM     = 4   # Immediate operand.
    OP_FP      = 5    # Floating-Point immediate operand.
    OP_MEM     = 6   # Memory operand

    # ARM registers
    REG_INVALID    = 0
    REG_APSR       = 1
    REG_APSR_NZCV  = 2
    REG_CPSR       = 3
    REG_FPEXC      = 4
    REG_FPINST     = 5
    REG_FPSCR      = 6
    REG_FPSCR_NZCV = 7
    REG_FPSID      = 8
    REG_ITSTATE    = 9
    REG_LR         = 10
    REG_PC         = 11
    REG_SP         = 12
    REG_SPSR       = 13
    REG_D0         = 14
    REG_D1         = 15
    REG_D2         = 16
    REG_D3         = 17
    REG_D4         = 18
    REG_D5         = 19
    REG_D6         = 20
    REG_D7         = 21
    REG_D8         = 22
    REG_D9         = 23
    REG_D10        = 24
    REG_D11        = 25
    REG_D12        = 26
    REG_D13        = 27
    REG_D14        = 28
    REG_D15        = 29
    REG_D16        = 30
    REG_D17        = 31
    REG_D18        = 32
    REG_D19        = 33
    REG_D20        = 34
    REG_D21        = 35
    REG_D22        = 36
    REG_D23        = 37
    REG_D24        = 38
    REG_D25        = 39
    REG_D26        = 40
    REG_D27        = 41
    REG_D28        = 42
    REG_D29        = 43
    REG_D30        = 44
    REG_D31        = 45
    REG_FPINST2    = 46
    REG_MVFR0      = 47
    REG_MVFR1      = 48
    REG_Q0         = 49
    REG_Q1         = 50
    REG_Q2         = 51
    REG_Q3         = 52
    REG_Q4         = 53
    REG_Q5         = 54
    REG_Q6         = 55
    REG_Q7         = 56
    REG_Q8         = 57
    REG_Q9         = 58
    REG_Q10        = 59
    REG_Q11        = 60
    REG_Q12        = 61
    REG_Q13        = 62
    REG_Q14        = 63
    REG_Q15        = 64
    REG_R0         = 65
    REG_R1         = 66
    REG_R2         = 67
    REG_R3         = 68
    REG_R4         = 69
    REG_R5         = 70
    REG_R6         = 71
    REG_R7         = 72
    REG_R8         = 73
    REG_R9         = 74
    REG_R10        = 75
    REG_R11        = 76
    REG_R12        = 77
    REG_S0         = 78
    REG_S1         = 79
    REG_S2         = 80
    REG_S3         = 81
    REG_S4         = 82
    REG_S5         = 83
    REG_S6         = 84
    REG_S7         = 85
    REG_S8         = 86
    REG_S9         = 87
    REG_S10        = 88
    REG_S11        = 89
    REG_S12        = 90
    REG_S13        = 91
    REG_S14        = 92
    REG_S15        = 93
    REG_S16        = 94
    REG_S17        = 95
    REG_S18        = 96
    REG_S19        = 97
    REG_S20        = 98
    REG_S21        = 99
    REG_S22        = 100
    REG_S23        = 101
    REG_S24        = 102
    REG_S25        = 103
    REG_S26        = 104
    REG_S27        = 105
    REG_S28        = 106
    REG_S29        = 107
    REG_S30        = 108
    REG_S31        = 109

    # ARM instructions
    INS_INVALID       = 0
    INS_ADC           = 1
    INS_ADD           = 2
    INS_ADR           = 3
    INS_AESD_8        = 4
    INS_AESE_8        = 5
    INS_AESIMC_8      = 6
    INS_AESMC_8       = 7
    INS_AND           = 8
    INS_BFC           = 9
    INS_BFI           = 10
    INS_BIC           = 11
    INS_BKPT          = 12
    INS_BL            = 13
    INS_BLX           = 14
    INS_BX            = 15
    INS_BXJ           = 16
    INS_B             = 17
    INS_CDP           = 18
    INS_CDP2          = 19
    INS_CLREX         = 20
    INS_CLZ           = 21
    INS_CMN           = 22
    INS_CMP           = 23
    INS_CPS           = 24
    INS_CRC32B        = 25
    INS_CRC32CB       = 26
    INS_CRC32CH       = 27
    INS_CRC32CW       = 28
    INS_CRC32H        = 29
    INS_CRC32W        = 30
    INS_DBG           = 31
    INS_DMB           = 32
    INS_DSB           = 33
    INS_EOR           = 34
    INS_VMOV          = 35
    INS_FLDMDBX       = 36
    INS_FLDMIAX       = 37
    INS_VMRS          = 38
    INS_FSTMDBX       = 39
    INS_FSTMIAX       = 40
    INS_HINT          = 41
    INS_HLT           = 42
    INS_ISB           = 43
    INS_LDA           = 44
    INS_LDAB          = 45
    INS_LDAEX         = 46
    INS_LDAEXB        = 47
    INS_LDAEXD        = 48
    INS_LDAEXH        = 49
    INS_LDAH          = 50
    INS_LDC2L         = 51
    INS_LDC2          = 52
    INS_LDCL          = 53
    INS_LDC           = 54
    INS_LDMDA         = 55
    INS_LDMDB         = 56
    INS_LDM           = 57
    INS_LDMIB         = 58
    INS_LDRBT         = 59
    INS_LDRB          = 60
    INS_LDRD          = 61
    INS_LDREX         = 62
    INS_LDREXB        = 63
    INS_LDREXD        = 64
    INS_LDREXH        = 65
    INS_LDRH          = 66
    INS_LDRHT         = 67
    INS_LDRSB         = 68
    INS_LDRSBT        = 69
    INS_LDRSH         = 70
    INS_LDRSHT        = 71
    INS_LDRT          = 72
    INS_LDR           = 73
    INS_MCR           = 74
    INS_MCR2          = 75
    INS_MCRR          = 76
    INS_MCRR2         = 77
    INS_MLA           = 78
    INS_MLS           = 79
    INS_MOV           = 80
    INS_MOVT          = 81
    INS_MOVW          = 82
    INS_MRC           = 83
    INS_MRC2          = 84
    INS_MRRC          = 85
    INS_MRRC2         = 86
    INS_MRS           = 87
    INS_MSR           = 88
    INS_MUL           = 89
    INS_MVN           = 90
    INS_ORR           = 91
    INS_PKHBT         = 92
    INS_PKHTB         = 93
    INS_PLDW          = 94
    INS_PLD           = 95
    INS_PLI           = 96
    INS_QADD          = 97
    INS_QADD16        = 98
    INS_QADD8         = 99
    INS_QASX          = 100
    INS_QDADD         = 101
    INS_QDSUB         = 102
    INS_QSAX          = 103
    INS_QSUB          = 104
    INS_QSUB16        = 105
    INS_QSUB8         = 106
    INS_RBIT          = 107
    INS_REV           = 108
    INS_REV16         = 109
    INS_REVSH         = 110
    INS_RFEDA         = 111
    INS_RFEDB         = 112
    INS_RFEIA         = 113
    INS_RFEIB         = 114
    INS_RSB           = 115
    INS_RSC           = 116
    INS_SADD16        = 117
    INS_SADD8         = 118
    INS_SASX          = 119
    INS_SBC           = 120
    INS_SBFX          = 121
    INS_SDIV          = 122
    INS_SEL           = 123
    INS_SETEND        = 124
    INS_SHA1C_32      = 125
    INS_SHA1H_32      = 126
    INS_SHA1M_32      = 127
    INS_SHA1P_32      = 128
    INS_SHA1SU0_32    = 129
    INS_SHA1SU1_32    = 130
    INS_SHA256H_32    = 131
    INS_SHA256H2_32   = 132
    INS_SHA256SU0_32  = 133
    INS_SHA256SU1_32  = 134
    INS_SHADD16       = 135
    INS_SHADD8        = 136
    INS_SHASX         = 137
    INS_SHSAX         = 138
    INS_SHSUB16       = 139
    INS_SHSUB8        = 140
    INS_SMC           = 141
    INS_SMLABB        = 142
    INS_SMLABT        = 143
    INS_SMLAD         = 144
    INS_SMLADX        = 145
    INS_SMLAL         = 146
    INS_SMLALBB       = 147
    INS_SMLALBT       = 148
    INS_SMLALD        = 149
    INS_SMLALDX       = 150
    INS_SMLALTB       = 151
    INS_SMLALTT       = 152
    INS_SMLATB        = 153
    INS_SMLATT        = 154
    INS_SMLAWB        = 155
    INS_SMLAWT        = 156
    INS_SMLSD         = 157
    INS_SMLSDX        = 158
    INS_SMLSLD        = 159
    INS_SMLSLDX       = 160
    INS_SMMLA         = 161
    INS_SMMLAR        = 162
    INS_SMMLS         = 163
    INS_SMMLSR        = 164
    INS_SMMUL         = 165
    INS_SMMULR        = 166
    INS_SMUAD         = 167
    INS_SMUADX        = 168
    INS_SMULBB        = 169
    INS_SMULBT        = 170
    INS_SMULL         = 171
    INS_SMULTB        = 172
    INS_SMULTT        = 173
    INS_SMULWB        = 174
    INS_SMULWT        = 175
    INS_SMUSD         = 176
    INS_SMUSDX        = 177
    INS_SRSDA         = 178
    INS_SRSDB         = 179
    INS_SRSIA         = 180
    INS_SRSIB         = 181
    INS_SSAT          = 182
    INS_SSAT16        = 183
    INS_SSAX          = 184
    INS_SSUB16        = 185
    INS_SSUB8         = 186
    INS_STC2L         = 187
    INS_STC2          = 188
    INS_STCL          = 189
    INS_STC           = 190
    INS_STL           = 191
    INS_STLB          = 192
    INS_STLEX         = 193
    INS_STLEXB        = 194
    INS_STLEXD        = 195
    INS_STLEXH        = 196
    INS_STLH          = 197
    INS_STMDA         = 198
    INS_STMDB         = 199
    INS_STM           = 200
    INS_STMIB         = 201
    INS_STRBT         = 202
    INS_STRB          = 203
    INS_STRD          = 204
    INS_STREX         = 205
    INS_STREXB        = 206
    INS_STREXD        = 207
    INS_STREXH        = 208
    INS_STRH          = 209
    INS_STRHT         = 210
    INS_STRT          = 211
    INS_STR           = 212
    INS_SUB           = 213
    INS_SVC           = 214
    INS_SWP           = 215
    INS_SWPB          = 216
    INS_SXTAB         = 217
    INS_SXTAB16       = 218
    INS_SXTAH         = 219
    INS_SXTB          = 220
    INS_SXTB16        = 221
    INS_SXTH          = 222
    INS_TEQ           = 223
    INS_TRAP          = 224
    INS_TST           = 225
    INS_UADD16        = 226
    INS_UADD8         = 227
    INS_UASX          = 228
    INS_UBFX          = 229
    INS_UDIV          = 230
    INS_UHADD16       = 231
    INS_UHADD8        = 232
    INS_UHASX         = 233
    INS_UHSAX         = 234
    INS_UHSUB16       = 235
    INS_UHSUB8        = 236
    INS_UMAAL         = 237
    INS_UMLAL         = 238
    INS_UMULL         = 239
    INS_UQADD16       = 240
    INS_UQADD8        = 241
    INS_UQASX         = 242
    INS_UQSAX         = 243
    INS_UQSUB16       = 244
    INS_UQSUB8        = 245
    INS_USAD8         = 246
    INS_USADA8        = 247
    INS_USAT          = 248
    INS_USAT16        = 249
    INS_USAX          = 250
    INS_USUB16        = 251
    INS_USUB8         = 252
    INS_UXTAB         = 253
    INS_UXTAB16       = 254
    INS_UXTAH         = 255
    INS_UXTB          = 256
    INS_UXTB16        = 257
    INS_UXTH          = 258
    INS_VABAL         = 259
    INS_VABA          = 260
    INS_VABDL         = 261
    INS_VABD          = 262
    INS_VABS          = 263
    INS_VACGE         = 264
    INS_VACGT         = 265
    INS_VADD          = 266
    INS_VADDHN        = 267
    INS_VADDL         = 268
    INS_VADDW         = 269
    INS_VAND          = 270
    INS_VBIC          = 271
    INS_VBIF          = 272
    INS_VBIT          = 273
    INS_VBSL          = 274
    INS_VCEQ          = 275
    INS_VCGE          = 276
    INS_VCGT          = 277
    INS_VCLE          = 278
    INS_VCLS          = 279
    INS_VCLT          = 280
    INS_VCLZ          = 281
    INS_VCMP          = 282
    INS_VCMPE         = 283
    INS_VCNT          = 284
    INS_VCVTA_S32_F32 = 285
    INS_VCVTA_U32_F32 = 286
    INS_VCVTA_S32_F64 = 287
    INS_VCVTA_U32_F64 = 288
    INS_VCVTB         = 289
    INS_VCVT          = 290
    INS_VCVTM_S32_F32 = 291
    INS_VCVTM_U32_F32 = 292
    INS_VCVTM_S32_F64 = 293
    INS_VCVTM_U32_F64 = 294
    INS_VCVTN_S32_F32 = 295
    INS_VCVTN_U32_F32 = 296
    INS_VCVTN_S32_F64 = 297
    INS_VCVTN_U32_F64 = 298
    INS_VCVTP_S32_F32 = 299
    INS_VCVTP_U32_F32 = 300
    INS_VCVTP_S32_F64 = 301
    INS_VCVTP_U32_F64 = 302
    INS_VCVTT         = 303
    INS_VDIV          = 304
    INS_VDUP          = 305
    INS_VEOR          = 306
    INS_VEXT          = 307
    INS_VFMA          = 308
    INS_VFMS          = 309
    INS_VFNMA         = 310
    INS_VFNMS         = 311
    INS_VHADD         = 312
    INS_VHSUB         = 313
    INS_VLD1          = 314
    INS_VLD2          = 315
    INS_VLD3          = 316
    INS_VLD4          = 317
    INS_VLDMDB        = 318
    INS_VLDMIA        = 319
    INS_VLDR          = 320
    INS_VMAXNM_F64    = 321
    INS_VMAXNM_F32    = 322
    INS_VMAX          = 323
    INS_VMINNM_F64    = 324
    INS_VMINNM_F32    = 325
    INS_VMIN          = 326
    INS_VMLA          = 327
    INS_VMLAL         = 328
    INS_VMLS          = 329
    INS_VMLSL         = 330
    INS_VMOVL         = 331
    INS_VMOVN         = 332
    INS_VMSR          = 333
    INS_VMUL          = 334
    INS_VMULL_P64     = 335
    INS_VMULL         = 336
    INS_VMVN          = 337
    INS_VNEG          = 338
    INS_VNMLA         = 339
    INS_VNMLS         = 340
    INS_VNMUL         = 341
    INS_VORN          = 342
    INS_VORR          = 343
    INS_VPADAL        = 344
    INS_VPADDL        = 345
    INS_VPADD         = 346
    INS_VPMAX         = 347
    INS_VPMIN         = 348
    INS_VQABS         = 349
    INS_VQADD         = 350
    INS_VQDMLAL       = 351
    INS_VQDMLSL       = 352
    INS_VQDMULH       = 353
    INS_VQDMULL       = 354
    INS_VQMOVUN       = 355
    INS_VQMOVN        = 356
    INS_VQNEG         = 357
    INS_VQRDMULH      = 358
    INS_VQRSHL        = 359
    INS_VQRSHRN       = 360
    INS_VQRSHRUN      = 361
    INS_VQSHL         = 362
    INS_VQSHLU        = 363
    INS_VQSHRN        = 364
    INS_VQSHRUN       = 365
    INS_VQSUB         = 366
    INS_VRADDHN       = 367
    INS_VRECPE        = 368
    INS_VRECPS        = 369
    INS_VREV16        = 370
    INS_VREV32        = 371
    INS_VREV64        = 372
    INS_VRHADD        = 373
    INS_VRINTA_F64    = 374
    INS_VRINTA_F32    = 375
    INS_VRINTM_F64    = 376
    INS_VRINTM_F32    = 377
    INS_VRINTN_F64    = 378
    INS_VRINTN_F32    = 379
    INS_VRINTP_F64    = 380
    INS_VRINTP_F32    = 381
    INS_VRINTR        = 382
    INS_VRINTX        = 383
    INS_VRINTX_F32    = 384
    INS_VRINTZ        = 385
    INS_VRINTZ_F32    = 386
    INS_VRSHL         = 387
    INS_VRSHRN        = 388
    INS_VRSHR         = 389
    INS_VRSQRTE       = 390
    INS_VRSQRTS       = 391
    INS_VRSRA         = 392
    INS_VRSUBHN       = 393
    INS_VSELEQ_F64    = 394
    INS_VSELEQ_F32    = 395
    INS_VSELGE_F64    = 396
    INS_VSELGE_F32    = 397
    INS_VSELGT_F64    = 398
    INS_VSELGT_F32    = 399
    INS_VSELVS_F64    = 400
    INS_VSELVS_F32    = 401
    INS_VSHLL         = 402
    INS_VSHL          = 403
    INS_VSHRN         = 404
    INS_VSHR          = 405
    INS_VSLI          = 406
    INS_VSQRT         = 407
    INS_VSRA          = 408
    INS_VSRI          = 409
    INS_VST1          = 410
    INS_VST2          = 411
    INS_VST3          = 412
    INS_VST4          = 413
    INS_VSTMDB        = 414
    INS_VSTMIA        = 415
    INS_VSTR          = 416
    INS_VSUB          = 417
    INS_VSUBHN        = 418
    INS_VSUBL         = 419
    INS_VSUBW         = 420
    INS_VSWP          = 421
    INS_VTBL          = 422
    INS_VTBX          = 423
    INS_VCVTR         = 424
    INS_VTRN          = 425
    INS_VTST          = 426
    INS_VUZP          = 427
    INS_VZIP          = 428
    INS_ADDW          = 429
    INS_ADR_W         = 430
    INS_ASR           = 431
    INS_DCPS1         = 432
    INS_DCPS2         = 433
    INS_DCPS3         = 434
    INS_IT            = 435
    INS_LSL           = 436
    INS_LSR           = 437
    INS_ORN           = 438
    INS_ROR           = 439
    INS_RRX           = 440
    INS_SUBW          = 441
    INS_TBB           = 442
    INS_TBH           = 443
    INS_CBNZ          = 444
    INS_CBZ           = 445
    INS_NOP           = 446
    INS_POP           = 447
    INS_PUSH          = 448
    INS_SEV           = 449
    INS_SEVL          = 450
    INS_WFE           = 451
    INS_WFI           = 452
    INS_YIELD         = 453

    # ARM group of instructions
    GRP_INVALID       = 0
    GRP_CRYPTO        = 1
    GRP_DATABARRIER   = 2
    GRP_DIVIDE        = 3
    GRP_FPARMV8       = 4
    GRP_MULTPRO       = 5
    GRP_NEON          = 6
    GRP_T2EXTRACTPACK = 7
    GRP_THUMB2DSP     = 8
    GRP_TRUSTZONE     = 9
    GRP_V4T           = 10
    GRP_V5T           = 11
    GRP_V5TE          = 12
    GRP_V6            = 13
    GRP_V6T2          = 14
    GRP_V7            = 15
    GRP_V8            = 16
    GRP_VFP2          = 17
    GRP_VFP3          = 18
    GRP_VFP4          = 19
    GRP_ARM           = 20
    GRP_MCLASS        = 21
    GRP_NOTMCLASS     = 22
    GRP_THUMB         = 23
    GRP_THUMB1ONLY    = 24
    GRP_THUMB2        = 25
    GRP_PREV8         = 26
    GRP_FPVMLX        = 27
    GRP_MULOPS        = 28
  end
end
