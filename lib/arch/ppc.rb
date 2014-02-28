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
    BC_LT = (0<<5)|12
    BC_LE = (1<<5)|4
    BC_EQ = (2<<5)|12
    BC_GE = (0<<5)|4
    BC_GT = (1<<5)|12
    BC_NE = (2<<5)|4
    BC_UN = (3<<5)|12
    BC_NU = (3<<5)|4
    BC_LT_MINUS = (0<<5)|14
    BC_LE_MINUS = (1<<5)|6
    BC_EQ_MINUS = (2<<5)|14
    BC_GE_MINUS = (0<<5)|6
    BC_GT_MINUS = (1<<5)|14
    BC_NE_MINUS = (2<<5)|6
    BC_UN_MINUS = (3<<5)|14
    BC_NU_MINUS = (3<<5)|6
    BC_LT_PLUS = (0<<5)|15
    BC_LE_PLUS = (1<<5)|7
    BC_EQ_PLUS = (2<<5)|15
    BC_GE_PLUS = (0<<5)|7
    BC_GT_PLUS = (1<<5)|15
    BC_NE_PLUS = (2<<5)|7
    BC_UN_PLUS = (3<<5)|15
    BC_NU_PLUS = (3<<5)|7

    # PPC branch hint for some branch instructions

    BH_NO = 0
    BH_PLUS = 1
    BH_MINUS = 2

    # Operand type for instruction's operands

    OP_INVALID = 0
    OP_REG = 1
    OP_IMM = 2
    OP_MEM = 3

    # PPC registers

    REG_INVALID = 0
    REG_CARRY = 1
    REG_CR0 = 2
    REG_CR1 = 3
    REG_CR2 = 4
    REG_CR3 = 5
    REG_CR4 = 6
    REG_CR5 = 7
    REG_CR6 = 8
    REG_CR7 = 9
    REG_CR8 = 10
    REG_CR9 = 11
    REG_CR10 = 12
    REG_CR11 = 13
    REG_CR12 = 14
    REG_CR13 = 15
    REG_CR14 = 16
    REG_CR15 = 17
    REG_CR16 = 18
    REG_CR17 = 19
    REG_CR18 = 20
    REG_CR19 = 21
    REG_CR20 = 22
    REG_CR21 = 23
    REG_CR22 = 24
    REG_CR23 = 25
    REG_CR24 = 26
    REG_CR25 = 27
    REG_CR26 = 28
    REG_CR27 = 29
    REG_CR28 = 30
    REG_CR29 = 31
    REG_CR30 = 32
    REG_CR31 = 33
    REG_CTR = 34
    REG_F0 = 35
    REG_F1 = 36
    REG_F2 = 37
    REG_F3 = 38
    REG_F4 = 39
    REG_F5 = 40
    REG_F6 = 41
    REG_F7 = 42
    REG_F8 = 43
    REG_F9 = 44
    REG_F10 = 45
    REG_F11 = 46
    REG_F12 = 47
    REG_F13 = 48
    REG_F14 = 49
    REG_F15 = 50
    REG_F16 = 51
    REG_F17 = 52
    REG_F18 = 53
    REG_F19 = 54
    REG_F20 = 55
    REG_F21 = 56
    REG_F22 = 57
    REG_F23 = 58
    REG_F24 = 59
    REG_F25 = 60
    REG_F26 = 61
    REG_F27 = 62
    REG_F28 = 63
    REG_F29 = 64
    REG_F30 = 65
    REG_F31 = 66
    REG_LR = 67
    REG_R0 = 68
    REG_R1 = 69
    REG_R2 = 70
    REG_R3 = 71
    REG_R4 = 72
    REG_R5 = 73
    REG_R6 = 74
    REG_R7 = 75
    REG_R8 = 76
    REG_R9 = 77
    REG_R10 = 78
    REG_R11 = 79
    REG_R12 = 80
    REG_R13 = 81
    REG_R14 = 82
    REG_R15 = 83
    REG_R16 = 84
    REG_R17 = 85
    REG_R18 = 86
    REG_R19 = 87
    REG_R20 = 88
    REG_R21 = 89
    REG_R22 = 90
    REG_R23 = 91
    REG_R24 = 92
    REG_R25 = 93
    REG_R26 = 94
    REG_R27 = 95
    REG_R28 = 96
    REG_R29 = 97
    REG_R30 = 98
    REG_R31 = 99
    REG_V0 = 100
    REG_V1 = 101
    REG_V2 = 102
    REG_V3 = 103
    REG_V4 = 104
    REG_V5 = 105
    REG_V6 = 106
    REG_V7 = 107
    REG_V8 = 108
    REG_V9 = 109
    REG_V10 = 110
    REG_V11 = 111
    REG_V12 = 112
    REG_V13 = 113
    REG_V14 = 114
    REG_V15 = 115
    REG_V16 = 116
    REG_V17 = 117
    REG_V18 = 118
    REG_V19 = 119
    REG_V20 = 120
    REG_V21 = 121
    REG_V22 = 122
    REG_V23 = 123
    REG_V24 = 124
    REG_V25 = 125
    REG_V26 = 126
    REG_V27 = 127
    REG_V28 = 128
    REG_V29 = 129
    REG_V30 = 130
    REG_V31 = 131
    REG_VRSAVE = 132
    REG_RM = 133
    REG_CTR8 = 134
    REG_LR8 = 135
    REG_CR1EQ = 136
    REG_MAX = 137

    # PPC instruction

    INS_INVALID = 0
    INS_ADD = 1
    INS_ADDC = 2
    INS_ADDE = 3
    INS_ADDI = 4
    INS_ADDIC = 5
    INS_ADDIS = 6
    INS_ADDME = 7
    INS_ADDZE = 8
    INS_AND = 9
    INS_ANDC = 10
    INS_ANDIS = 11
    INS_ANDI = 12
    INS_B = 13
    INS_BA = 14
    INS_BCL = 15
    INS_BCTR = 16
    INS_BCTRL = 17
    INS_BDNZ = 18
    INS_BDNZA = 19
    INS_BDNZL = 20
    INS_BDNZLA = 21
    INS_BDNZLR = 22
    INS_BDNZLRL = 23
    INS_BDZ = 24
    INS_BDZA = 25
    INS_BDZL = 26
    INS_BDZLA = 27
    INS_BDZLR = 28
    INS_BDZLRL = 29
    INS_BL = 30
    INS_BLA = 31
    INS_BLR = 32
    INS_BLRL = 33
    INS_CMPD = 34
    INS_CMPDI = 35
    INS_CMPLD = 36
    INS_CMPLDI = 37
    INS_CMPLW = 38
    INS_CMPLWI = 39
    INS_CMPW = 40
    INS_CMPWI = 41
    INS_CNTLZD = 42
    INS_CNTLZW = 43
    INS_CREQV = 44
    INS_CRXOR = 45
    INS_CRAND = 46
    INS_CRANDC = 47
    INS_CRNAND = 48
    INS_CRNOR = 49
    INS_CROR = 50
    INS_CRORC = 51
    INS_DCBA = 52
    INS_DCBF = 53
    INS_DCBI = 54
    INS_DCBST = 55
    INS_DCBT = 56
    INS_DCBTST = 57
    INS_DCBZ = 58
    INS_DCBZL = 59
    INS_DIVD = 60
    INS_DIVDU = 61
    INS_DIVW = 62
    INS_DIVWU = 63
    INS_DSS = 64
    INS_DSSALL = 65
    INS_DST = 66
    INS_DSTST = 67
    INS_DSTSTT = 68
    INS_DSTT = 69
    INS_EIEIO = 70
    INS_EQV = 71
    INS_EXTSB = 72
    INS_EXTSH = 73
    INS_EXTSW = 74
    INS_FABS = 75
    INS_FADD = 76
    INS_FADDS = 77
    INS_FCFID = 78
    INS_FCFIDS = 79
    INS_FCFIDU = 80
    INS_FCFIDUS = 81
    INS_FCMPU = 82
    INS_FCPSGN = 83
    INS_FCTID = 84
    INS_FCTIDUZ = 85
    INS_FCTIDZ = 86
    INS_FCTIW = 87
    INS_FCTIWUZ = 88
    INS_FCTIWZ = 89
    INS_FDIV = 90
    INS_FDIVS = 91
    INS_FMADD = 92
    INS_FMADDS = 93
    INS_FMR = 94
    INS_FMSUB = 95
    INS_FMSUBS = 96
    INS_FMUL = 97
    INS_FMULS = 98
    INS_FNABS = 99
    INS_FNEG = 100
    INS_FNMADD = 101
    INS_FNMADDS = 102
    INS_FNMSUB = 103
    INS_FNMSUBS = 104
    INS_FRE = 105
    INS_FRES = 106
    INS_FRIM = 107
    INS_FRIN = 108
    INS_FRIP = 109
    INS_FRIZ = 110
    INS_FRSP = 111
    INS_FRSQRTE = 112
    INS_FRSQRTES = 113
    INS_FSEL = 114
    INS_FSQRT = 115
    INS_FSQRTS = 116
    INS_FSUB = 117
    INS_FSUBS = 118
    INS_ICBI = 119
    INS_ISEL = 120
    INS_ISYNC = 121
    INS_LA = 122
    INS_LBZ = 123
    INS_LBZU = 124
    INS_LBZUX = 125
    INS_LBZX = 126
    INS_LD = 127
    INS_LDARX = 128
    INS_LDBRX = 129
    INS_LDU = 130
    INS_LDUX = 131
    INS_LDX = 132
    INS_LFD = 133
    INS_LFDU = 134
    INS_LFDUX = 135
    INS_LFDX = 136
    INS_LFIWAX = 137
    INS_LFIWZX = 138
    INS_LFS = 139
    INS_LFSU = 140
    INS_LFSUX = 141
    INS_LFSX = 142
    INS_LHA = 143
    INS_LHAU = 144
    INS_LHAUX = 145
    INS_LHAX = 146
    INS_LHBRX = 147
    INS_LHZ = 148
    INS_LHZU = 149
    INS_LHZUX = 150
    INS_LHZX = 151
    INS_LI = 152
    INS_LIS = 153
    INS_LMW = 154
    INS_LVEBX = 155
    INS_LVEHX = 156
    INS_LVEWX = 157
    INS_LVSL = 158
    INS_LVSR = 159
    INS_LVX = 160
    INS_LVXL = 161
    INS_LWA = 162
    INS_LWARX = 163
    INS_LWAUX = 164
    INS_LWAX = 165
    INS_LWBRX = 166
    INS_LWZ = 167
    INS_LWZU = 168
    INS_LWZUX = 169
    INS_LWZX = 170
    INS_MCRF = 171
    INS_MFCR = 172
    INS_MFCTR = 173
    INS_MFFS = 174
    INS_MFLR = 175
    INS_MFMSR = 176
    INS_MFOCRF = 177
    INS_MFSPR = 178
    INS_MFTB = 179
    INS_MFVSCR = 180
    INS_MSYNC = 181
    INS_MTCRF = 182
    INS_MTCTR = 183
    INS_MTFSB0 = 184
    INS_MTFSB1 = 185
    INS_MTFSF = 186
    INS_MTLR = 187
    INS_MTMSR = 188
    INS_MTMSRD = 189
    INS_MTOCRF = 190
    INS_MTSPR = 191
    INS_MTVSCR = 192
    INS_MULHD = 193
    INS_MULHDU = 194
    INS_MULHW = 195
    INS_MULHWU = 196
    INS_MULLD = 197
    INS_MULLI = 198
    INS_MULLW = 199
    INS_NAND = 200
    INS_NEG = 201
    INS_NOP = 202
    INS_ORI = 203
    INS_NOR = 204
    INS_OR = 205
    INS_ORC = 206
    INS_ORIS = 207
    INS_POPCNTD = 208
    INS_POPCNTW = 209
    INS_RLDCL = 210
    INS_RLDCR = 211
    INS_RLDIC = 212
    INS_RLDICL = 213
    INS_RLDICR = 214
    INS_RLDIMI = 215
    INS_RLWIMI = 216
    INS_RLWINM = 217
    INS_RLWNM = 218
    INS_SC = 219
    INS_SLBIA = 220
    INS_SLBIE = 221
    INS_SLBMFEE = 222
    INS_SLBMTE = 223
    INS_SLD = 224
    INS_SLW = 225
    INS_SRAD = 226
    INS_SRADI = 227
    INS_SRAW = 228
    INS_SRAWI = 229
    INS_SRD = 230
    INS_SRW = 231
    INS_STB = 232
    INS_STBU = 233
    INS_STBUX = 234
    INS_STBX = 235
    INS_STD = 236
    INS_STDBRX = 237
    INS_STDCX = 238
    INS_STDU = 239
    INS_STDUX = 240
    INS_STDX = 241
    INS_STFD = 242
    INS_STFDU = 243
    INS_STFDUX = 244
    INS_STFDX = 245
    INS_STFIWX = 246
    INS_STFS = 247
    INS_STFSU = 248
    INS_STFSUX = 249
    INS_STFSX = 250
    INS_STH = 251
    INS_STHBRX = 252
    INS_STHU = 253
    INS_STHUX = 254
    INS_STHX = 255
    INS_STMW = 256
    INS_STVEBX = 257
    INS_STVEHX = 258
    INS_STVEWX = 259
    INS_STVX = 260
    INS_STVXL = 261
    INS_STW = 262
    INS_STWBRX = 263
    INS_STWCX = 264
    INS_STWU = 265
    INS_STWUX = 266
    INS_STWX = 267
    INS_SUBF = 268
    INS_SUBFC = 269
    INS_SUBFE = 270
    INS_SUBFIC = 271
    INS_SUBFME = 272
    INS_SUBFZE = 273
    INS_SYNC = 274
    INS_TD = 275
    INS_TDI = 276
    INS_TLBIE = 277
    INS_TLBIEL = 278
    INS_TLBSYNC = 279
    INS_TRAP = 280
    INS_TW = 281
    INS_TWI = 282
    INS_VADDCUW = 283
    INS_VADDFP = 284
    INS_VADDSBS = 285
    INS_VADDSHS = 286
    INS_VADDSWS = 287
    INS_VADDUBM = 288
    INS_VADDUBS = 289
    INS_VADDUHM = 290
    INS_VADDUHS = 291
    INS_VADDUWM = 292
    INS_VADDUWS = 293
    INS_VAND = 294
    INS_VANDC = 295
    INS_VAVGSB = 296
    INS_VAVGSH = 297
    INS_VAVGSW = 298
    INS_VAVGUB = 299
    INS_VAVGUH = 300
    INS_VAVGUW = 301
    INS_VCFSX = 302
    INS_VCFUX = 303
    INS_VCMPBFP = 304
    INS_VCMPEQFP = 305
    INS_VCMPEQUB = 306
    INS_VCMPEQUH = 307
    INS_VCMPEQUW = 308
    INS_VCMPGEFP = 309
    INS_VCMPGTFP = 310
    INS_VCMPGTSB = 311
    INS_VCMPGTSH = 312
    INS_VCMPGTSW = 313
    INS_VCMPGTUB = 314
    INS_VCMPGTUH = 315
    INS_VCMPGTUW = 316
    INS_VCTSXS = 317
    INS_VCTUXS = 318
    INS_VEXPTEFP = 319
    INS_VLOGEFP = 320
    INS_VMADDFP = 321
    INS_VMAXFP = 322
    INS_VMAXSB = 323
    INS_VMAXSH = 324
    INS_VMAXSW = 325
    INS_VMAXUB = 326
    INS_VMAXUH = 327
    INS_VMAXUW = 328
    INS_VMHADDSHS = 329
    INS_VMHRADDSHS = 330
    INS_VMINFP = 331
    INS_VMINSB = 332
    INS_VMINSH = 333
    INS_VMINSW = 334
    INS_VMINUB = 335
    INS_VMINUH = 336
    INS_VMINUW = 337
    INS_VMLADDUHM = 338
    INS_VMRGHB = 339
    INS_VMRGHH = 340
    INS_VMRGHW = 341
    INS_VMRGLB = 342
    INS_VMRGLH = 343
    INS_VMRGLW = 344
    INS_VMSUMMBM = 345
    INS_VMSUMSHM = 346
    INS_VMSUMSHS = 347
    INS_VMSUMUBM = 348
    INS_VMSUMUHM = 349
    INS_VMSUMUHS = 350
    INS_VMULESB = 351
    INS_VMULESH = 352
    INS_VMULEUB = 353
    INS_VMULEUH = 354
    INS_VMULOSB = 355
    INS_VMULOSH = 356
    INS_VMULOUB = 357
    INS_VMULOUH = 358
    INS_VNMSUBFP = 359
    INS_VNOR = 360
    INS_VOR = 361
    INS_VPERM = 362
    INS_VPKPX = 363
    INS_VPKSHSS = 364
    INS_VPKSHUS = 365
    INS_VPKSWSS = 366
    INS_VPKSWUS = 367
    INS_VPKUHUM = 368
    INS_VPKUHUS = 369
    INS_VPKUWUM = 370
    INS_VPKUWUS = 371
    INS_VREFP = 372
    INS_VRFIM = 373
    INS_VRFIN = 374
    INS_VRFIP = 375
    INS_VRFIZ = 376
    INS_VRLB = 377
    INS_VRLH = 378
    INS_VRLW = 379
    INS_VRSQRTEFP = 380
    INS_VSEL = 381
    INS_VSL = 382
    INS_VSLB = 383
    INS_VSLDOI = 384
    INS_VSLH = 385
    INS_VSLO = 386
    INS_VSLW = 387
    INS_VSPLTB = 388
    INS_VSPLTH = 389
    INS_VSPLTISB = 390
    INS_VSPLTISH = 391
    INS_VSPLTISW = 392
    INS_VSPLTW = 393
    INS_VSR = 394
    INS_VSRAB = 395
    INS_VSRAH = 396
    INS_VSRAW = 397
    INS_VSRB = 398
    INS_VSRH = 399
    INS_VSRO = 400
    INS_VSRW = 401
    INS_VSUBCUW = 402
    INS_VSUBFP = 403
    INS_VSUBSBS = 404
    INS_VSUBSHS = 405
    INS_VSUBSWS = 406
    INS_VSUBUBM = 407
    INS_VSUBUBS = 408
    INS_VSUBUHM = 409
    INS_VSUBUHS = 410
    INS_VSUBUWM = 411
    INS_VSUBUWS = 412
    INS_VSUM2SWS = 413
    INS_VSUM4SBS = 414
    INS_VSUM4SHS = 415
    INS_VSUM4UBS = 416
    INS_VSUMSWS = 417
    INS_VUPKHPX = 418
    INS_VUPKHSB = 419
    INS_VUPKHSH = 420
    INS_VUPKLPX = 421
    INS_VUPKLSB = 422
    INS_VUPKLSH = 423
    INS_VXOR = 424
    INS_WAIT = 425
    INS_XOR = 426
    INS_XORI = 427
    INS_XORIS = 428
    INS_BC = 429
    INS_BCA = 430
    INS_BCCTR = 431
    INS_BCCTRL = 432
    INS_BCLA = 433
    INS_BCLR = 434
    INS_BCLRL = 435
    INS_MAX = 436

    # Group of PPC instructions

    GRP_INVALID = 0
    GRP_ALTIVEC = 1
    GRP_MODE32 = 2
    GRP_MODE64 = 3
    GRP_BOOKE = 4
    GRP_NOTBOOKE = 5
    GRP_JUMP = 6
    GRP_MAX = 7
  
  end
end
