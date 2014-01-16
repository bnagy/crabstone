# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

module Crabstone
  module PPC

    class MemoryOperand < FFI::Struct
      layout(
        :base, :uint,
        :disp, :int32
      )
    end

    class OperandValue < FFI::Union
      layout(
        :reg, :uint,
        :imm, :int32,
        :mem, MemoryOperand
      )
    end

    class Operand < FFI::Struct
      layout(
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

      def mem?
        self[:type] == OP_MEM
      end

      def valid?
        [OP_MEM, OP_IMM, OP_REG].include? self[:type]
      end
    end

    class Instruction < FFI::Struct
      layout(
        :bc, :uint,
        :bh, :uint,
        :update_cr0, :bool,
        :op_count, :uint8,
        :operands, [Operand, 8],
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # PPC branch codes for some branch instructions
    BC_LT       = (0<<5)|12
    BC_LE       = (1<<5)|4
    BC_EQ       = (2<<5)|12
    BC_GE       = (0<<5)|4
    BC_GT       = (1<<5)|12
    BC_NE       = (2<<5)|4
    BC_UN       = (3<<5)|12
    BC_NU       = (3<<5)|4
    BC_LT_MINUS = (0<<5)|14
    BC_LE_MINUS = (1<<5)|6
    BC_EQ_MINUS = (2<<5)|14
    BC_GE_MINUS = (0<<5)|6
    BC_GT_MINUS = (1<<5)|14
    BC_NE_MINUS = (2<<5)|6
    BC_UN_MINUS = (3<<5)|14
    BC_NU_MINUS = (3<<5)|6
    BC_LT_PLUS  = (0<<5)|15
    BC_LE_PLUS  = (1<<5)|7
    BC_EQ_PLUS  = (2<<5)|15
    BC_GE_PLUS  = (0<<5)|7
    BC_GT_PLUS  = (1<<5)|15
    BC_NE_PLUS  = (2<<5)|7
    BC_UN_PLUS  = (3<<5)|15
    BC_NU_PLUS  = (3<<5)|7

    # PPC branch hint for some branch instructions

    BH_NO    = 0
    BH_PLUS  = 1
    BH_MINUS = 2

    # Operand type for instruction's operands

    OP_INVALID = 0
    OP_REG     = 1
    OP_IMM     = 2
    OP_MEM     = 3

    # PPC registers

    REG_INVALID = 0
    REG_CARRY   = 1
    REG_CR0     = 2
    REG_CR1     = 3
    REG_CR2     = 4
    REG_CR3     = 5
    REG_CR4     = 6
    REG_CR5     = 7
    REG_CR6     = 8
    REG_CR7     = 9
    REG_CR8     = 10
    REG_CR9     = 11
    REG_CR10    = 12
    REG_CR11    = 13
    REG_CR12    = 14
    REG_CR13    = 15
    REG_CR14    = 16
    REG_CR15    = 17
    REG_CR16    = 18
    REG_CR17    = 19
    REG_CR18    = 20
    REG_CR19    = 21
    REG_CR20    = 22
    REG_CR21    = 23
    REG_CR22    = 24
    REG_CR23    = 25
    REG_CR24    = 26
    REG_CR25    = 27
    REG_CR26    = 28
    REG_CR27    = 29
    REG_CR28    = 30
    REG_CR29    = 31
    REG_CR30    = 32
    REG_CR31    = 33
    REG_CTR     = 34
    REG_F0      = 35
    REG_F1      = 36
    REG_F2      = 37
    REG_F3      = 38
    REG_F4      = 39
    REG_F5      = 40
    REG_F6      = 41
    REG_F7      = 42
    REG_F8      = 43
    REG_F9      = 44
    REG_F10     = 45
    REG_F11     = 46
    REG_F12     = 47
    REG_F13     = 48
    REG_F14     = 49
    REG_F15     = 50
    REG_F16     = 51
    REG_F17     = 52
    REG_F18     = 53
    REG_F19     = 54
    REG_F20     = 55
    REG_F21     = 56
    REG_F22     = 57
    REG_F23     = 58
    REG_F24     = 59
    REG_F25     = 60
    REG_F26     = 61
    REG_F27     = 62
    REG_F28     = 63
    REG_F29     = 64
    REG_F30     = 65
    REG_F31     = 66
    REG_LR      = 67
    REG_R0      = 68
    REG_R1      = 69
    REG_R2      = 70
    REG_R3      = 71
    REG_R4      = 72
    REG_R5      = 73
    REG_R6      = 74
    REG_R7      = 75
    REG_R8      = 76
    REG_R9      = 77
    REG_R10     = 78
    REG_R11     = 79
    REG_R12     = 80
    REG_R13     = 81
    REG_R14     = 82
    REG_R15     = 83
    REG_R16     = 84
    REG_R17     = 85
    REG_R18     = 86
    REG_R19     = 87
    REG_R20     = 88
    REG_R21     = 89
    REG_R22     = 90
    REG_R23     = 91
    REG_R24     = 92
    REG_R25     = 93
    REG_R26     = 94
    REG_R27     = 95
    REG_R28     = 96
    REG_R29     = 97
    REG_R30     = 98
    REG_R31     = 99
    REG_V0      = 100
    REG_V1      = 101
    REG_V2      = 102
    REG_V3      = 103
    REG_V4      = 104
    REG_V5      = 105
    REG_V6      = 106
    REG_V7      = 107
    REG_V8      = 108
    REG_V9      = 109
    REG_V10     = 110
    REG_V11     = 111
    REG_V12     = 112
    REG_V13     = 113
    REG_V14     = 114
    REG_V15     = 115
    REG_V16     = 116
    REG_V17     = 117
    REG_V18     = 118
    REG_V19     = 119
    REG_V20     = 120
    REG_V21     = 121
    REG_V22     = 122
    REG_V23     = 123
    REG_V24     = 124
    REG_V25     = 125
    REG_V26     = 126
    REG_V27     = 127
    REG_V28     = 128
    REG_V29     = 129
    REG_V30     = 130
    REG_V31     = 131
    REG_VRSAVE  = 132
    REG_RM      = 133
    REG_CTR8    = 134
    REG_LR8     = 135
    REG_CR1EQ   = 136
    REG_MAX     = 137

    # PPC instruction

    INS_INVALID    = 0
    INS_ADD        = 1
    INS_ADDC       = 2
    INS_ADDE       = 3
    INS_ADDI       = 4
    INS_ADDIC      = 5
    INS_ADDIS      = 6
    INS_ADDME      = 7
    INS_ADDZE      = 8
    INS_AND        = 9
    INS_ANDC       = 10
    INS_ANDIS      = 11
    INS_ANDI       = 12
    INS_B          = 13
    INS_BA         = 14
    INS_BCL        = 15
    INS_BCTR       = 16
    INS_BCTRL      = 17
    INS_BDNZ       = 18
    INS_BDNZA      = 19
    INS_BDNZL      = 20
    INS_BDNZLA     = 21
    INS_BDNZLR     = 22
    INS_BDNZLRL    = 23
    INS_BDZ        = 24
    INS_BDZA       = 25
    INS_BDZL       = 26
    INS_BDZLA      = 27
    INS_BDZLR      = 28
    INS_BDZLRL     = 29
    INS_BL         = 30
    INS_BLA        = 31
    INS_BLR        = 32
    INS_BLRL       = 33
    INS_CMPD       = 34
    INS_CMPDI      = 35
    INS_CMPLD      = 36
    INS_CMPLDI     = 37
    INS_CMPLW      = 38
    INS_CMPLWI     = 39
    INS_CMPW       = 40
    INS_CMPWI      = 41
    INS_CNTLZD     = 42
    INS_CNTLZW     = 43
    INS_CREQV      = 44
    INS_CRXOR      = 45
    INS_CRAND      = 46
    INS_CRANDC     = 47
    INS_CRNAND     = 48
    INS_CRNOR      = 49
    INS_CROR       = 50
    INS_CRORC      = 51
    INS_DCBA       = 52
    INS_DCBF       = 53
    INS_DCBI       = 54
    INS_DCBST      = 55
    INS_DCBT       = 56
    INS_DCBTST     = 57
    INS_DCBZ       = 58
    INS_DCBZL      = 59
    INS_DIVD       = 60
    INS_DIVDU      = 61
    INS_DIVW       = 62
    INS_DIVWU      = 63
    INS_DSS        = 64
    INS_DSSALL     = 65
    INS_DST        = 66
    INS_DSTST      = 67
    INS_DSTSTT     = 68
    INS_DSTT       = 69
    INS_EIEIO      = 70
    INS_EQV        = 71
    INS_EXTSB      = 72
    INS_EXTSH      = 73
    INS_EXTSW      = 74
    INS_FABS       = 75
    INS_FADD       = 76
    INS_FADDS      = 77
    INS_FCFID      = 78
    INS_FCFIDS     = 79
    INS_FCFIDU     = 80
    INS_FCFIDUS    = 81
    INS_FCMPU      = 82
    INS_FCPSGN     = 83
    INS_FCTID      = 84
    INS_FCTIDUZ    = 85
    INS_FCTIDZ     = 86
    INS_FCTIW      = 87
    INS_FCTIWUZ    = 88
    INS_FCTIWZ     = 89
    INS_FDIV       = 90
    INS_FDIVS      = 91
    INS_FMADD      = 92
    INS_FMADDS     = 93
    INS_FMSUB      = 94
    INS_FMSUBS     = 95
    INS_FMUL       = 96
    INS_FMULS      = 97
    INS_FNABS      = 98
    INS_FNEG       = 99
    INS_FNMADD     = 100
    INS_FNMADDS    = 101
    INS_FNMSUB     = 102
    INS_FNMSUBS    = 103
    INS_FRE        = 104
    INS_FRES       = 105
    INS_FRIM       = 106
    INS_FRIN       = 107
    INS_FRIP       = 108
    INS_FRIZ       = 109
    INS_FRSP       = 110
    INS_FRSQRTE    = 111
    INS_FRSQRTES   = 112
    INS_FSEL       = 113
    INS_FSQRT      = 114
    INS_FSQRTS     = 115
    INS_FSUB       = 116
    INS_FSUBS      = 117
    INS_ICBI       = 118
    INS_ISEL       = 119
    INS_ISYNC      = 120
    INS_LA         = 121
    INS_LBZ        = 122
    INS_LBZU       = 123
    INS_LBZUX      = 124
    INS_LBZX       = 125
    INS_LD         = 126
    INS_LDARX      = 127
    INS_LDBRX      = 128
    INS_LDU        = 129
    INS_LDUX       = 130
    INS_LDX        = 131
    INS_LFD        = 132
    INS_LFDU       = 133
    INS_LFDUX      = 134
    INS_LFDX       = 135
    INS_LFIWAX     = 136
    INS_LFIWZX     = 137
    INS_LFS        = 138
    INS_LFSU       = 139
    INS_LFSUX      = 140
    INS_LFSX       = 141
    INS_LHA        = 142
    INS_LHAU       = 143
    INS_LHAUX      = 144
    INS_LHAX       = 145
    INS_LHBRX      = 146
    INS_LHZ        = 147
    INS_LHZU       = 148
    INS_LHZUX      = 149
    INS_LHZX       = 150
    INS_LI         = 151
    INS_LIS        = 152
    INS_LMW        = 153
    INS_LVEBX      = 154
    INS_LVEHX      = 155
    INS_LVEWX      = 156
    INS_LVSL       = 157
    INS_LVSR       = 158
    INS_LVX        = 159
    INS_LVXL       = 160
    INS_LWA        = 161
    INS_LWARX      = 162
    INS_LWAUX      = 163
    INS_LWAX       = 164
    INS_LWBRX      = 165
    INS_LWZ        = 166
    INS_LWZU       = 167
    INS_LWZUX      = 168
    INS_LWZX       = 169
    INS_MCRF       = 170
    INS_MFCR       = 171
    INS_MFCTR      = 172
    INS_MFFS       = 173
    INS_MFLR       = 174
    INS_MFMSR      = 175
    INS_MFOCRF     = 176
    INS_MFSPR      = 177
    INS_MFTB       = 178
    INS_MFVSCR     = 179
    INS_MTCRF      = 180
    INS_MTCTR      = 181
    INS_MTFSB0     = 182
    INS_MTFSB1     = 183
    INS_MTFSF      = 184
    INS_MTLR       = 185
    INS_MTMSR      = 186
    INS_MTMSRD     = 187
    INS_MTOCRF     = 188
    INS_MTSPR      = 189
    INS_MTVSCR     = 190
    INS_MULHD      = 191
    INS_MULHDU     = 192
    INS_MULHW      = 193
    INS_MULHWU     = 194
    INS_MULLD      = 195
    INS_MULLI      = 196
    INS_MULLW      = 197
    INS_NAND       = 198
    INS_NEG        = 199
    INS_NOP        = 200
    INS_ORI        = 201
    INS_NOR        = 202
    INS_OR         = 203
    INS_ORC        = 204
    INS_ORIS       = 205
    INS_POPCNTD    = 206
    INS_POPCNTW    = 207
    INS_RLDCL      = 208
    INS_RLDCR      = 209
    INS_RLDIC      = 210
    INS_RLDICL     = 211
    INS_RLDICR     = 212
    INS_RLDIMI     = 213
    INS_RLWIMI     = 214
    INS_RLWINM     = 215
    INS_RLWNM      = 216
    INS_SC         = 217
    INS_SLBIA      = 218
    INS_SLBIE      = 219
    INS_SLBMFEE    = 220
    INS_SLBMTE     = 221
    INS_SLD        = 222
    INS_SLW        = 223
    INS_SRAD       = 224
    INS_SRADI      = 225
    INS_SRAW       = 226
    INS_SRAWI      = 227
    INS_SRD        = 228
    INS_SRW        = 229
    INS_STB        = 230
    INS_STBU       = 231
    INS_STBUX      = 232
    INS_STBX       = 233
    INS_STD        = 234
    INS_STDBRX     = 235
    INS_STDCX      = 236
    INS_STDU       = 237
    INS_STDUX      = 238
    INS_STDX       = 239
    INS_STFD       = 240
    INS_STFDU      = 241
    INS_STFDUX     = 242
    INS_STFDX      = 243
    INS_STFIWX     = 244
    INS_STFS       = 245
    INS_STFSU      = 246
    INS_STFSUX     = 247
    INS_STFSX      = 248
    INS_STH        = 249
    INS_STHBRX     = 250
    INS_STHU       = 251
    INS_STHUX      = 252
    INS_STHX       = 253
    INS_STMW       = 254
    INS_STVEBX     = 255
    INS_STVEHX     = 256
    INS_STVEWX     = 257
    INS_STVX       = 258
    INS_STVXL      = 259
    INS_STW        = 260
    INS_STWBRX     = 261
    INS_STWCX      = 262
    INS_STWU       = 263
    INS_STWUX      = 264
    INS_STWX       = 265
    INS_SUBF       = 266
    INS_SUBFC      = 267
    INS_SUBFE      = 268
    INS_SUBFIC     = 269
    INS_SUBFME     = 270
    INS_SUBFZE     = 271
    INS_SYNC       = 272
    INS_TD         = 273
    INS_TDI        = 274
    INS_TLBIE      = 275
    INS_TLBIEL     = 276
    INS_TLBSYNC    = 277
    INS_TRAP       = 278
    INS_TW         = 279
    INS_TWI        = 280
    INS_VADDCUW    = 281
    INS_VADDFP     = 282
    INS_VADDSBS    = 283
    INS_VADDSHS    = 284
    INS_VADDSWS    = 285
    INS_VADDUBM    = 286
    INS_VADDUBS    = 287
    INS_VADDUHM    = 288
    INS_VADDUHS    = 289
    INS_VADDUWM    = 290
    INS_VADDUWS    = 291
    INS_VAND       = 292
    INS_VANDC      = 293
    INS_VAVGSB     = 294
    INS_VAVGSH     = 295
    INS_VAVGSW     = 296
    INS_VAVGUB     = 297
    INS_VAVGUH     = 298
    INS_VAVGUW     = 299
    INS_VCFSX      = 300
    INS_VCFUX      = 301
    INS_VCMPBFP    = 302
    INS_VCMPEQFP   = 303
    INS_VCMPEQUB   = 304
    INS_VCMPEQUH   = 305
    INS_VCMPEQUW   = 306
    INS_VCMPGEFP   = 307
    INS_VCMPGTFP   = 308
    INS_VCMPGTSB   = 309
    INS_VCMPGTSH   = 310
    INS_VCMPGTSW   = 311
    INS_VCMPGTUB   = 312
    INS_VCMPGTUH   = 313
    INS_VCMPGTUW   = 314
    INS_VCTSXS     = 315
    INS_VCTUXS     = 316
    INS_VEXPTEFP   = 317
    INS_VLOGEFP    = 318
    INS_VMADDFP    = 319
    INS_VMAXFP     = 320
    INS_VMAXSB     = 321
    INS_VMAXSH     = 322
    INS_VMAXSW     = 323
    INS_VMAXUB     = 324
    INS_VMAXUH     = 325
    INS_VMAXUW     = 326
    INS_VMHADDSHS  = 327
    INS_VMHRADDSHS = 328
    INS_VMINFP     = 329
    INS_VMINSB     = 330
    INS_VMINSH     = 331
    INS_VMINSW     = 332
    INS_VMINUB     = 333
    INS_VMINUH     = 334
    INS_VMINUW     = 335
    INS_VMLADDUHM  = 336
    INS_VMRGHB     = 337
    INS_VMRGHH     = 338
    INS_VMRGHW     = 339
    INS_VMRGLB     = 340
    INS_VMRGLH     = 341
    INS_VMRGLW     = 342
    INS_VMSUMMBM   = 343
    INS_VMSUMSHM   = 344
    INS_VMSUMSHS   = 345
    INS_VMSUMUBM   = 346
    INS_VMSUMUHM   = 347
    INS_VMSUMUHS   = 348
    INS_VMULESB    = 349
    INS_VMULESH    = 350
    INS_VMULEUB    = 351
    INS_VMULEUH    = 352
    INS_VMULOSB    = 353
    INS_VMULOSH    = 354
    INS_VMULOUB    = 355
    INS_VMULOUH    = 356
    INS_VNMSUBFP   = 357
    INS_VNOR       = 358
    INS_VOR        = 359
    INS_VPERM      = 360
    INS_VPKPX      = 361
    INS_VPKSHSS    = 362
    INS_VPKSHUS    = 363
    INS_VPKSWSS    = 364
    INS_VPKSWUS    = 365
    INS_VPKUHUM    = 366
    INS_VPKUHUS    = 367
    INS_VPKUWUM    = 368
    INS_VPKUWUS    = 369
    INS_VREFP      = 370
    INS_VRFIM      = 371
    INS_VRFIN      = 372
    INS_VRFIP      = 373
    INS_VRFIZ      = 374
    INS_VRLB       = 375
    INS_VRLH       = 376
    INS_VRLW       = 377
    INS_VRSQRTEFP  = 378
    INS_VSEL       = 379
    INS_VSL        = 380
    INS_VSLB       = 381
    INS_VSLDOI     = 382
    INS_VSLH       = 383
    INS_VSLO       = 384
    INS_VSLW       = 385
    INS_VSPLTB     = 386
    INS_VSPLTH     = 387
    INS_VSPLTISB   = 388
    INS_VSPLTISH   = 389
    INS_VSPLTISW   = 390
    INS_VSPLTW     = 391
    INS_VSR        = 392
    INS_VSRAB      = 393
    INS_VSRAH      = 394
    INS_VSRAW      = 395
    INS_VSRB       = 396
    INS_VSRH       = 397
    INS_VSRO       = 398
    INS_VSRW       = 399
    INS_VSUBCUW    = 400
    INS_VSUBFP     = 401
    INS_VSUBSBS    = 402
    INS_VSUBSHS    = 403
    INS_VSUBSWS    = 404
    INS_VSUBUBM    = 405
    INS_VSUBUBS    = 406
    INS_VSUBUHM    = 407
    INS_VSUBUHS    = 408
    INS_VSUBUWM    = 409
    INS_VSUBUWS    = 410
    INS_VSUM2SWS   = 411
    INS_VSUM4SBS   = 412
    INS_VSUM4SHS   = 413
    INS_VSUM4UBS   = 414
    INS_VSUMSWS    = 415
    INS_VUPKHPX    = 416
    INS_VUPKHSB    = 417
    INS_VUPKHSH    = 418
    INS_VUPKLPX    = 419
    INS_VUPKLSB    = 420
    INS_VUPKLSH    = 421
    INS_VXOR       = 422
    INS_WAIT       = 423
    INS_XOR        = 424
    INS_XORI       = 425
    INS_XORIS      = 426
    INS_BC         = 427
    INS_BCA        = 428
    INS_BCCTR      = 429
    INS_BCCTRL     = 430
    INS_BCLA       = 431
    INS_BCLR       = 432
    INS_BCLRL      = 433
    INS_MAX        = 434

    # Group of PPC instructions

    GRP_INVALID = 0
    GRP_ALTIVEC = 1
    GRP_MODE32  = 2
    GRP_MODE64  = 3
    GRP_JUMP    = 4
    GRP_MAX     = 5

  end
end
