# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

module Crabstone
  module MIPS

    class MemoryOperand < FFI::Struct
      layout(
        :base, :uint,
        :disp, :int64
      )
    end

    class OperandValue < FFI::Union
      layout(
        :reg, :uint,
        :imm, :long_long,
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

      def mem?
        self[:type] == OP_MEM
      end

      def valid?
        [OP_MEM, OP_IMM, OP_REG].include? self[:type]
      end
    end

    class Instruction < FFI::Struct
      layout(
        :op_count, :uint8,
        :operands, [Operand, 8]
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # Operand type for instruction's operands

    OP_INVALID = 0
    OP_REG = 1
    OP_IMM = 2
    OP_MEM = 3

    # MIPS registers

    REG_INVALID = 0
    REG_0 = 1
    REG_1 = 2
    REG_2 = 3
    REG_3 = 4
    REG_4 = 5
    REG_5 = 6
    REG_6 = 7
    REG_7 = 8
    REG_8 = 9
    REG_9 = 10
    REG_10 = 11
    REG_11 = 12
    REG_12 = 13
    REG_13 = 14
    REG_14 = 15
    REG_15 = 16
    REG_16 = 17
    REG_17 = 18
    REG_18 = 19
    REG_19 = 20
    REG_20 = 21
    REG_21 = 22
    REG_22 = 23
    REG_23 = 24
    REG_24 = 25
    REG_25 = 26
    REG_26 = 27
    REG_27 = 28
    REG_28 = 29
    REG_29 = 30
    REG_30 = 31
    REG_31 = 32
    REG_DSPCCOND = 33
    REG_DSPCARRY = 34
    REG_DSPEFI = 35
    REG_DSPOUTFLAG = 36
    REG_DSPOUTFLAG16_19 = 37
    REG_DSPOUTFLAG20 = 38
    REG_DSPOUTFLAG21 = 39
    REG_DSPOUTFLAG22 = 40
    REG_DSPOUTFLAG23 = 41
    REG_DSPPOS = 42
    REG_DSPSCOUNT = 43
    REG_AC0 = 44
    REG_AC1 = 45
    REG_AC2 = 46
    REG_AC3 = 47
    REG_F0 = 48
    REG_F1 = 49
    REG_F2 = 50
    REG_F3 = 51
    REG_F4 = 52
    REG_F5 = 53
    REG_F6 = 54
    REG_F7 = 55
    REG_F8 = 56
    REG_F9 = 57
    REG_F10 = 58
    REG_F11 = 59
    REG_F12 = 60
    REG_F13 = 61
    REG_F14 = 62
    REG_F15 = 63
    REG_F16 = 64
    REG_F17 = 65
    REG_F18 = 66
    REG_F19 = 67
    REG_F20 = 68
    REG_F21 = 69
    REG_F22 = 70
    REG_F23 = 71
    REG_F24 = 72
    REG_F25 = 73
    REG_F26 = 74
    REG_F27 = 75
    REG_F28 = 76
    REG_F29 = 77
    REG_F30 = 78
    REG_F31 = 79
    REG_FCC0 = 80
    REG_FCC1 = 81
    REG_FCC2 = 82
    REG_FCC3 = 83
    REG_FCC4 = 84
    REG_FCC5 = 85
    REG_FCC6 = 86
    REG_FCC7 = 87
    REG_W0 = 88
    REG_W1 = 89
    REG_W2 = 90
    REG_W3 = 91
    REG_W4 = 92
    REG_W5 = 93
    REG_W6 = 94
    REG_W7 = 95
    REG_W8 = 96
    REG_W9 = 97
    REG_W10 = 98
    REG_W11 = 99
    REG_W12 = 100
    REG_W13 = 101
    REG_W14 = 102
    REG_W15 = 103
    REG_W16 = 104
    REG_W17 = 105
    REG_W18 = 106
    REG_W19 = 107
    REG_W20 = 108
    REG_W21 = 109
    REG_W22 = 110
    REG_W23 = 111
    REG_W24 = 112
    REG_W25 = 113
    REG_W26 = 114
    REG_W27 = 115
    REG_W28 = 116
    REG_W29 = 117
    REG_W30 = 118
    REG_W31 = 119
    REG_HI = 120
    REG_LO = 121
    REG_PC = 122
    REG_MAX = 123
    REG_ZERO = REG_0
    REG_AT = REG_1
    REG_V0 = REG_2
    REG_V1 = REG_3
    REG_A0 = REG_4
    REG_A1 = REG_5
    REG_A2 = REG_6
    REG_A3 = REG_7
    REG_T0 = REG_8
    REG_T1 = REG_9
    REG_T2 = REG_10
    REG_T3 = REG_11
    REG_T4 = REG_12
    REG_T5 = REG_13
    REG_T6 = REG_14
    REG_T7 = REG_15
    REG_S0 = REG_16
    REG_S1 = REG_17
    REG_S2 = REG_18
    REG_S3 = REG_19
    REG_S4 = REG_20
    REG_S5 = REG_21
    REG_S6 = REG_22
    REG_S7 = REG_23
    REG_T8 = REG_24
    REG_T9 = REG_25
    REG_K0 = REG_26
    REG_K1 = REG_27
    REG_GP = REG_28
    REG_SP = REG_29
    REG_FP = REG_30
    REG_S8 = REG_30
    REG_RA = REG_31
    REG_HI0 = REG_AC0
    REG_HI1 = REG_AC1
    REG_HI2 = REG_AC2
    REG_HI3 = REG_AC3
    REG_LO0 = REG_HI0
    REG_LO1 = REG_HI1
    REG_LO2 = REG_HI2
    REG_LO3 = REG_HI3

    # MIPS instruction

    INS_INVALID = 0
    INS_ABSQ_S = 1
    INS_ADD = 2
    INS_ADDQH = 3
    INS_ADDQH_R = 4
    INS_ADDQ = 5
    INS_ADDQ_S = 6
    INS_ADDSC = 7
    INS_ADDS_A = 8
    INS_ADDS_S = 9
    INS_ADDS_U = 10
    INS_ADDUH = 11
    INS_ADDUH_R = 12
    INS_ADDU = 13
    INS_ADDU_S = 14
    INS_ADDVI = 15
    INS_ADDV = 16
    INS_ADDWC = 17
    INS_ADD_A = 18
    INS_ADDI = 19
    INS_ADDIU = 20
    INS_AND = 21
    INS_ANDI = 22
    INS_APPEND = 23
    INS_ASUB_S = 24
    INS_ASUB_U = 25
    INS_AVER_S = 26
    INS_AVER_U = 27
    INS_AVE_S = 28
    INS_AVE_U = 29
    INS_BALIGN = 30
    INS_BC1F = 31
    INS_BC1T = 32
    INS_BCLRI = 33
    INS_BCLR = 34
    INS_BEQ = 35
    INS_BGEZ = 36
    INS_BGEZAL = 37
    INS_BGTZ = 38
    INS_BINSLI = 39
    INS_BINSL = 40
    INS_BINSRI = 41
    INS_BINSR = 42
    INS_BITREV = 43
    INS_BLEZ = 44
    INS_BLTZ = 45
    INS_BLTZAL = 46
    INS_BMNZI = 47
    INS_BMNZ = 48
    INS_BMZI = 49
    INS_BMZ = 50
    INS_BNE = 51
    INS_BNEGI = 52
    INS_BNEG = 53
    INS_BNZ = 54
    INS_BPOSGE32 = 55
    INS_BREAK = 56
    INS_BSELI = 57
    INS_BSEL = 58
    INS_BSETI = 59
    INS_BSET = 60
    INS_BZ = 61
    INS_BEQZ = 62
    INS_B = 63
    INS_BNEZ = 64
    INS_BTEQZ = 65
    INS_BTNEZ = 66
    INS_CEIL = 67
    INS_CEQI = 68
    INS_CEQ = 69
    INS_CFC1 = 70
    INS_CFCMSA = 71
    INS_CLEI_S = 72
    INS_CLEI_U = 73
    INS_CLE_S = 74
    INS_CLE_U = 75
    INS_CLO = 76
    INS_CLTI_S = 77
    INS_CLTI_U = 78
    INS_CLT_S = 79
    INS_CLT_U = 80
    INS_CLZ = 81
    INS_CMPGDU = 82
    INS_CMPGU = 83
    INS_CMPU = 84
    INS_CMP = 85
    INS_COPY_S = 86
    INS_COPY_U = 87
    INS_CTC1 = 88
    INS_CTCMSA = 89
    INS_CVT = 90
    INS_C = 91
    INS_CMPI = 92
    INS_DADD = 93
    INS_DADDI = 94
    INS_DADDIU = 95
    INS_DADDU = 96
    INS_DCLO = 97
    INS_DCLZ = 98
    INS_DERET = 99
    INS_DEXT = 100
    INS_DEXTM = 101
    INS_DEXTU = 102
    INS_DI = 103
    INS_DINS = 104
    INS_DINSM = 105
    INS_DINSU = 106
    INS_DIV_S = 107
    INS_DIV_U = 108
    INS_DLSA = 109
    INS_DMFC0 = 110
    INS_DMFC1 = 111
    INS_DMFC2 = 112
    INS_DMTC0 = 113
    INS_DMTC1 = 114
    INS_DMTC2 = 115
    INS_DMULT = 116
    INS_DMULTU = 117
    INS_DOTP_S = 118
    INS_DOTP_U = 119
    INS_DPADD_S = 120
    INS_DPADD_U = 121
    INS_DPAQX_SA = 122
    INS_DPAQX_S = 123
    INS_DPAQ_SA = 124
    INS_DPAQ_S = 125
    INS_DPAU = 126
    INS_DPAX = 127
    INS_DPA = 128
    INS_DPSQX_SA = 129
    INS_DPSQX_S = 130
    INS_DPSQ_SA = 131
    INS_DPSQ_S = 132
    INS_DPSUB_S = 133
    INS_DPSUB_U = 134
    INS_DPSU = 135
    INS_DPSX = 136
    INS_DPS = 137
    INS_DROTR = 138
    INS_DROTR32 = 139
    INS_DROTRV = 140
    INS_DSBH = 141
    INS_DDIV = 142
    INS_DSHD = 143
    INS_DSLL = 144
    INS_DSLL32 = 145
    INS_DSLLV = 146
    INS_DSRA = 147
    INS_DSRA32 = 148
    INS_DSRAV = 149
    INS_DSRL = 150
    INS_DSRL32 = 151
    INS_DSRLV = 152
    INS_DSUBU = 153
    INS_DDIVU = 154
    INS_DIV = 155
    INS_DIVU = 156
    INS_EI = 157
    INS_ERET = 158
    INS_EXT = 159
    INS_EXTP = 160
    INS_EXTPDP = 161
    INS_EXTPDPV = 162
    INS_EXTPV = 163
    INS_EXTRV_RS = 164
    INS_EXTRV_R = 165
    INS_EXTRV_S = 166
    INS_EXTRV = 167
    INS_EXTR_RS = 168
    INS_EXTR_R = 169
    INS_EXTR_S = 170
    INS_EXTR = 171
    INS_ABS = 172
    INS_FADD = 173
    INS_FCAF = 174
    INS_FCEQ = 175
    INS_FCLASS = 176
    INS_FCLE = 177
    INS_FCLT = 178
    INS_FCNE = 179
    INS_FCOR = 180
    INS_FCUEQ = 181
    INS_FCULE = 182
    INS_FCULT = 183
    INS_FCUNE = 184
    INS_FCUN = 185
    INS_FDIV = 186
    INS_FEXDO = 187
    INS_FEXP2 = 188
    INS_FEXUPL = 189
    INS_FEXUPR = 190
    INS_FFINT_S = 191
    INS_FFINT_U = 192
    INS_FFQL = 193
    INS_FFQR = 194
    INS_FILL = 195
    INS_FLOG2 = 196
    INS_FLOOR = 197
    INS_FMADD = 198
    INS_FMAX_A = 199
    INS_FMAX = 200
    INS_FMIN_A = 201
    INS_FMIN = 202
    INS_MOV = 203
    INS_FMSUB = 204
    INS_FMUL = 205
    INS_MUL = 206
    INS_NEG = 207
    INS_FRCP = 208
    INS_FRINT = 209
    INS_FRSQRT = 210
    INS_FSAF = 211
    INS_FSEQ = 212
    INS_FSLE = 213
    INS_FSLT = 214
    INS_FSNE = 215
    INS_FSOR = 216
    INS_FSQRT = 217
    INS_SQRT = 218
    INS_FSUB = 219
    INS_SUB = 220
    INS_FSUEQ = 221
    INS_FSULE = 222
    INS_FSULT = 223
    INS_FSUNE = 224
    INS_FSUN = 225
    INS_FTINT_S = 226
    INS_FTINT_U = 227
    INS_FTQ = 228
    INS_FTRUNC_S = 229
    INS_FTRUNC_U = 230
    INS_HADD_S = 231
    INS_HADD_U = 232
    INS_HSUB_S = 233
    INS_HSUB_U = 234
    INS_ILVEV = 235
    INS_ILVL = 236
    INS_ILVOD = 237
    INS_ILVR = 238
    INS_INS = 239
    INS_INSERT = 240
    INS_INSV = 241
    INS_INSVE = 242
    INS_J = 243
    INS_JAL = 244
    INS_JALR = 245
    INS_JR = 246
    INS_JRC = 247
    INS_JALRC = 248
    INS_LB = 249
    INS_LBUX = 250
    INS_LBU = 251
    INS_LD = 252
    INS_LDC1 = 253
    INS_LDC2 = 254
    INS_LDI = 255
    INS_LDL = 256
    INS_LDR = 257
    INS_LDXC1 = 258
    INS_LH = 259
    INS_LHX = 260
    INS_LHU = 261
    INS_LL = 262
    INS_LLD = 263
    INS_LSA = 264
    INS_LUXC1 = 265
    INS_LUI = 266
    INS_LW = 267
    INS_LWC1 = 268
    INS_LWC2 = 269
    INS_LWL = 270
    INS_LWR = 271
    INS_LWU = 272
    INS_LWX = 273
    INS_LWXC1 = 274
    INS_LI = 275
    INS_MADD = 276
    INS_MADDR_Q = 277
    INS_MADDU = 278
    INS_MADDV = 279
    INS_MADD_Q = 280
    INS_MAQ_SA = 281
    INS_MAQ_S = 282
    INS_MAXI_S = 283
    INS_MAXI_U = 284
    INS_MAX_A = 285
    INS_MAX_S = 286
    INS_MAX_U = 287
    INS_MFC0 = 288
    INS_MFC1 = 289
    INS_MFC2 = 290
    INS_MFHC1 = 291
    INS_MFHI = 292
    INS_MFLO = 293
    INS_MINI_S = 294
    INS_MINI_U = 295
    INS_MIN_A = 296
    INS_MIN_S = 297
    INS_MIN_U = 298
    INS_MODSUB = 299
    INS_MOD_S = 300
    INS_MOD_U = 301
    INS_MOVE = 302
    INS_MOVF = 303
    INS_MOVN = 304
    INS_MOVT = 305
    INS_MOVZ = 306
    INS_MSUB = 307
    INS_MSUBR_Q = 308
    INS_MSUBU = 309
    INS_MSUBV = 310
    INS_MSUB_Q = 311
    INS_MTC0 = 312
    INS_MTC1 = 313
    INS_MTC2 = 314
    INS_MTHC1 = 315
    INS_MTHI = 316
    INS_MTHLIP = 317
    INS_MTLO = 318
    INS_MULEQ_S = 319
    INS_MULEU_S = 320
    INS_MULQ_RS = 321
    INS_MULQ_S = 322
    INS_MULR_Q = 323
    INS_MULSAQ_S = 324
    INS_MULSA = 325
    INS_MULT = 326
    INS_MULTU = 327
    INS_MULV = 328
    INS_MUL_Q = 329
    INS_MUL_S = 330
    INS_NLOC = 331
    INS_NLZC = 332
    INS_NMADD = 333
    INS_NMSUB = 334
    INS_NOR = 335
    INS_NORI = 336
    INS_NOT = 337
    INS_OR = 338
    INS_ORI = 339
    INS_PACKRL = 340
    INS_PCKEV = 341
    INS_PCKOD = 342
    INS_PCNT = 343
    INS_PICK = 344
    INS_PRECEQU = 345
    INS_PRECEQ = 346
    INS_PRECEU = 347
    INS_PRECRQU_S = 348
    INS_PRECRQ = 349
    INS_PRECRQ_RS = 350
    INS_PRECR = 351
    INS_PRECR_SRA = 352
    INS_PRECR_SRA_R = 353
    INS_PREPEND = 354
    INS_RADDU = 355
    INS_RDDSP = 356
    INS_RDHWR = 357
    INS_REPLV = 358
    INS_REPL = 359
    INS_ROTR = 360
    INS_ROTRV = 361
    INS_ROUND = 362
    INS_SAT_S = 363
    INS_SAT_U = 364
    INS_SB = 365
    INS_SC = 366
    INS_SCD = 367
    INS_SD = 368
    INS_SDC1 = 369
    INS_SDC2 = 370
    INS_SDL = 371
    INS_SDR = 372
    INS_SDXC1 = 373
    INS_SEB = 374
    INS_SEH = 375
    INS_SH = 376
    INS_SHF = 377
    INS_SHILO = 378
    INS_SHILOV = 379
    INS_SHLLV = 380
    INS_SHLLV_S = 381
    INS_SHLL = 382
    INS_SHLL_S = 383
    INS_SHRAV = 384
    INS_SHRAV_R = 385
    INS_SHRA = 386
    INS_SHRA_R = 387
    INS_SHRLV = 388
    INS_SHRL = 389
    INS_SLDI = 390
    INS_SLD = 391
    INS_SLL = 392
    INS_SLLI = 393
    INS_SLLV = 394
    INS_SLT = 395
    INS_SLTI = 396
    INS_SLTIU = 397
    INS_SLTU = 398
    INS_SPLATI = 399
    INS_SPLAT = 400
    INS_SRA = 401
    INS_SRAI = 402
    INS_SRARI = 403
    INS_SRAR = 404
    INS_SRAV = 405
    INS_SRL = 406
    INS_SRLI = 407
    INS_SRLRI = 408
    INS_SRLR = 409
    INS_SRLV = 410
    INS_ST = 411
    INS_SUBQH = 412
    INS_SUBQH_R = 413
    INS_SUBQ = 414
    INS_SUBQ_S = 415
    INS_SUBSUS_U = 416
    INS_SUBSUU_S = 417
    INS_SUBS_S = 418
    INS_SUBS_U = 419
    INS_SUBUH = 420
    INS_SUBUH_R = 421
    INS_SUBU = 422
    INS_SUBU_S = 423
    INS_SUBVI = 424
    INS_SUBV = 425
    INS_SUXC1 = 426
    INS_SW = 427
    INS_SWC1 = 428
    INS_SWC2 = 429
    INS_SWL = 430
    INS_SWR = 431
    INS_SWXC1 = 432
    INS_SYNC = 433
    INS_SYSCALL = 434
    INS_TEQ = 435
    INS_TEQI = 436
    INS_TGE = 437
    INS_TGEI = 438
    INS_TGEIU = 439
    INS_TGEU = 440
    INS_TLT = 441
    INS_TLTI = 442
    INS_TLTIU = 443
    INS_TLTU = 444
    INS_TNE = 445
    INS_TNEI = 446
    INS_TRUNC = 447
    INS_VSHF = 448
    INS_WAIT = 449
    INS_WRDSP = 450
    INS_WSBH = 451
    INS_XOR = 452
    INS_XORI = 453

    # some alias instructions
    INS_NOP = 454
    INS_NEGU = 455
    INS_MAX = 456

    # Group of MIPS instructions

    GRP_INVALID = 0
    GRP_BITCOUNT = 1
    GRP_DSP = 2
    GRP_DSPR2 = 3
    GRP_FPIDX = 4
    GRP_MSA = 5
    GRP_MIPS32R2 = 6
    GRP_MIPS64 = 7
    GRP_MIPS64R2 = 8
    GRP_SEINREG = 9
    GRP_STDENC = 10
    GRP_SWAP = 11
    GRP_MICROMIPS = 12
    GRP_MIPS16MODE = 13
    GRP_FP64BIT = 14
    GRP_NONANSFPMATH = 15
    GRP_NOTFP64BIT = 16
    GRP_NOTINMICROMIPS = 17
    GRP_NOTNACL = 18
    GRP_JUMP = 19
    GRP_MAX = 20
  end
end
