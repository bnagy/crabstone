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
        :operands, [Operand, 32]
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # Operand type
    OP_INVALID = 0   # Uninitialized.
    OP_REG     = 1   # Register operand.
    OP_IMM     = 2   # Immediate operand.
    OP_MEM     = 3   # Memory operand.

    # Registers
    REG_0               = 0
    REG_ZERO            = REG_0
    REG_1               = 1
    REG_AT              = REG_1
    REG_2               = 2
    REG_V0              = REG_2
    REG_3               = 3
    REG_V1              = REG_3
    REG_4               = 4
    REG_A0              = REG_4
    REG_5               = 5
    REG_A1              = REG_5
    REG_6               = 6
    REG_A2              = REG_6
    REG_7               = 7
    REG_A3              = REG_7
    REG_8               = 8
    REG_T0              = REG_8
    REG_9               = 9
    REG_T1              = REG_9
    REG_10              = 10
    REG_T2              = REG_10
    REG_11              = 11
    REG_T3              = REG_11
    REG_12              = 12
    REG_T4              = REG_12
    REG_13              = 13
    REG_T5              = REG_13
    REG_14              = 14
    REG_T6              = REG_14
    REG_15              = 15
    REG_T7              = REG_15
    REG_16              = 16
    REG_S0              = REG_16
    REG_17              = 17
    REG_S1              = REG_17
    REG_18              = 18
    REG_S2              = REG_18
    REG_19              = 19
    REG_S3              = REG_19
    REG_20              = 20
    REG_S4              = REG_20
    REG_21              = 21
    REG_S5              = REG_21
    REG_22              = 22
    REG_S6              = REG_22
    REG_23              = 23
    REG_S7              = REG_23
    REG_24              = 24
    REG_T8              = REG_24
    REG_25              = 25
    REG_T9              = REG_25
    REG_26              = 26
    REG_K0              = REG_26
    REG_27              = 27
    REG_K1              = REG_27
    REG_28              = 28
    REG_GP              = REG_28
    REG_29              = 29
    REG_SP              = REG_29
    REG_30              = 30
    REG_FP              = REG_30
    REG_S8              = REG_30
    REG_31              = 31
    REG_RA              = REG_31
    REG_DSPCCOND        = 32
    REG_DSPCARRY        = 33
    REG_DSPEFI          = 34
    REG_DSPOUTFLAG      = 35
    REG_DSPOUTFLAG16_19 = 36
    REG_DSPOUTFLAG20    = 37
    REG_DSPOUTFLAG21    = 38
    REG_DSPOUTFLAG22    = 39
    REG_DSPOUTFLAG23    = 40
    REG_DSPPOS          = 41
    REG_DSPSCOUNT       = 42
    REG_AC0             = 43
    REG_HI0             = REG_AC0
    REG_AC1             = 44
    REG_HI1             = REG_AC1
    REG_AC2             = 45
    REG_HI2             = REG_AC2
    REG_AC3             = 46
    REG_HI3             = REG_AC3
    REG_LO0             = REG_HI0
    REG_LO1             = REG_HI1
    REG_LO2             = REG_HI2
    REG_LO3             = REG_HI3
    REG_F0              = 47
    REG_F1              = 48
    REG_F2              = 49
    REG_F3              = 50
    REG_F4              = 51
    REG_F5              = 52
    REG_F6              = 53
    REG_F7              = 54
    REG_F8              = 55
    REG_F9              = 56
    REG_F10             = 57
    REG_F11             = 58
    REG_F12             = 59
    REG_F13             = 60
    REG_F14             = 61
    REG_F15             = 62
    REG_F16             = 63
    REG_F17             = 64
    REG_F18             = 65
    REG_F19             = 66
    REG_F20             = 67
    REG_F21             = 68
    REG_F22             = 69
    REG_F23             = 70
    REG_F24             = 71
    REG_F25             = 72
    REG_F26             = 73
    REG_F27             = 74
    REG_F28             = 75
    REG_F29             = 76
    REG_F30             = 77
    REG_F31             = 78
    REG_FCC0            = 79
    REG_FCC1            = 80
    REG_FCC2            = 81
    REG_FCC3            = 82
    REG_FCC4            = 83
    REG_FCC5            = 84
    REG_FCC6            = 85
    REG_FCC7            = 86
    REG_W0              = 87
    REG_W1              = 88
    REG_W2              = 89
    REG_W3              = 90
    REG_W4              = 91
    REG_W5              = 92
    REG_W6              = 93
    REG_W7              = 94
    REG_W8              = 95
    REG_W9              = 96
    REG_W10             = 97
    REG_W11             = 98
    REG_W12             = 99
    REG_W13             = 100
    REG_W14             = 101
    REG_W15             = 102
    REG_W16             = 103
    REG_W17             = 104
    REG_W18             = 105
    REG_W19             = 106
    REG_W20             = 107
    REG_W21             = 108
    REG_W22             = 109
    REG_W23             = 110
    REG_W24             = 111
    REG_W25             = 112
    REG_W26             = 113
    REG_W27             = 114
    REG_W28             = 115
    REG_W29             = 116
    REG_W30             = 117
    REG_W31             = 118
    REG_MAX             = 119

    # Instructions
    INS_INVALID     = 0
    INS_ABSQ_S      = 1
    INS_ADD         = 2
    INS_ADDQH       = 3
    INS_ADDQH_R     = 4
    INS_ADDQ        = 5
    INS_ADDQ_S      = 6
    INS_ADDSC       = 7
    INS_ADDS_A      = 8
    INS_ADDS_S      = 9
    INS_ADDS_U      = 10
    INS_ADDUH       = 11
    INS_ADDUH_R     = 12
    INS_ADDU        = 13
    INS_ADDU_S      = 14
    INS_ADDVI       = 15
    INS_ADDV        = 16
    INS_ADDWC       = 17
    INS_ADD_A       = 18
    INS_ADDI        = 19
    INS_ADDIU       = 20
    INS_AND         = 21
    INS_ANDI        = 22
    INS_APPEND      = 23
    INS_ASUB_S      = 24
    INS_ASUB_U      = 25
    INS_AVER_S      = 26
    INS_AVER_U      = 27
    INS_AVE_S       = 28
    INS_AVE_U       = 29
    INS_BALIGN      = 30
    INS_BC1F        = 31
    INS_BC1T        = 32
    INS_BCLRI       = 33
    INS_BCLR        = 34
    INS_BEQ         = 35
    INS_BGEZ        = 36
    INS_BGEZAL      = 37
    INS_BGTZ        = 38
    INS_BINSLI      = 39
    INS_BINSL       = 40
    INS_BINSRI      = 41
    INS_BINSR       = 42
    INS_BITREV      = 43
    INS_BLEZ        = 44
    INS_BLTZ        = 45
    INS_BLTZAL      = 46
    INS_BMNZI       = 47
    INS_BMNZ        = 48
    INS_BMZI        = 49
    INS_BMZ         = 50
    INS_BNE         = 51
    INS_BNEGI       = 52
    INS_BNEG        = 53
    INS_BNZ         = 54
    INS_BPOSGE32    = 55
    INS_BREAK       = 56
    INS_BSELI       = 57
    INS_BSEL        = 58
    INS_BSETI       = 59
    INS_BSET        = 60
    INS_BZ          = 61
    INS_BEQZ        = 62
    INS_B           = 63
    INS_BNEZ        = 64
    INS_BTEQZ       = 65
    INS_BTNEZ       = 66
    INS_CEIL        = 67
    INS_CEQI        = 68
    INS_CEQ         = 69
    INS_CFC1        = 70
    INS_CFCMSA      = 71
    INS_CLEI_S      = 72
    INS_CLEI_U      = 73
    INS_CLE_S       = 74
    INS_CLE_U       = 75
    INS_CLO         = 76
    INS_CLTI_S      = 77
    INS_CLTI_U      = 78
    INS_CLT_S       = 79
    INS_CLT_U       = 80
    INS_CLZ         = 81
    INS_CMPGDU      = 82
    INS_CMPGU       = 83
    INS_CMPU        = 84
    INS_CMP         = 85
    INS_COPY_S      = 86
    INS_COPY_U      = 87
    INS_CTC1        = 88
    INS_CTCMSA      = 89
    INS_CVT         = 90
    INS_C           = 91
    INS_CMPI        = 92
    INS_DADD        = 93
    INS_DADDI       = 94
    INS_DADDIU      = 95
    INS_DADDU       = 96
    INS_DCLO        = 97
    INS_DCLZ        = 98
    INS_DERET       = 99
    INS_DEXT        = 100
    INS_DEXTM       = 101
    INS_DEXTU       = 102
    INS_DI          = 103
    INS_DINS        = 104
    INS_DINSM       = 105
    INS_DINSU       = 106
    INS_DIV_S       = 107
    INS_DIV_U       = 108
    INS_DMFC0       = 109
    INS_DMFC1       = 110
    INS_DMFC2       = 111
    INS_DMTC0       = 112
    INS_DMTC1       = 113
    INS_DMTC2       = 114
    INS_DMULT       = 115
    INS_DMULTU      = 116
    INS_DOTP_S      = 117
    INS_DOTP_U      = 118
    INS_DPADD_S     = 119
    INS_DPADD_U     = 120
    INS_DPAQX_SA    = 121
    INS_DPAQX_S     = 122
    INS_DPAQ_SA     = 123
    INS_DPAQ_S      = 124
    INS_DPAU        = 125
    INS_DPAX        = 126
    INS_DPA         = 127
    INS_DPSQX_SA    = 128
    INS_DPSQX_S     = 129
    INS_DPSQ_SA     = 130
    INS_DPSQ_S      = 131
    INS_DPSUB_S     = 132
    INS_DPSUB_U     = 133
    INS_DPSU        = 134
    INS_DPSX        = 135
    INS_DPS         = 136
    INS_DROTR       = 137
    INS_DROTR32     = 138
    INS_DROTRV      = 139
    INS_DSBH        = 140
    INS_DDIV        = 141
    INS_DSHD        = 142
    INS_DSLL        = 143
    INS_DSLL32      = 144
    INS_DSLLV       = 145
    INS_DSRA        = 146
    INS_DSRA32      = 147
    INS_DSRAV       = 148
    INS_DSRL        = 149
    INS_DSRL32      = 150
    INS_DSRLV       = 151
    INS_DSUBU       = 152
    INS_DDIVU       = 153
    INS_DIV         = 154
    INS_DIVU        = 155
    INS_EI          = 156
    INS_ERET        = 157
    INS_EXT         = 158
    INS_EXTP        = 159
    INS_EXTPDP      = 160
    INS_EXTPDPV     = 161
    INS_EXTPV       = 162
    INS_EXTRV_RS    = 163
    INS_EXTRV_R     = 164
    INS_EXTRV_S     = 165
    INS_EXTRV       = 166
    INS_EXTR_RS     = 167
    INS_EXTR_R      = 168
    INS_EXTR_S      = 169
    INS_EXTR        = 170
    INS_ABS         = 171
    INS_FADD        = 172
    INS_FCAF        = 173
    INS_FCEQ        = 174
    INS_FCLASS      = 175
    INS_FCLE        = 176
    INS_FCLT        = 177
    INS_FCNE        = 178
    INS_FCOR        = 179
    INS_FCUEQ       = 180
    INS_FCULE       = 181
    INS_FCULT       = 182
    INS_FCUNE       = 183
    INS_FCUN        = 184
    INS_FDIV        = 185
    INS_FEXDO       = 186
    INS_FEXP2       = 187
    INS_FEXUPL      = 188
    INS_FEXUPR      = 189
    INS_FFINT_S     = 190
    INS_FFINT_U     = 191
    INS_FFQL        = 192
    INS_FFQR        = 193
    INS_FILL        = 194
    INS_FLOG2       = 195
    INS_FLOOR       = 196
    INS_FMADD       = 197
    INS_FMAX_A      = 198
    INS_FMAX        = 199
    INS_FMIN_A      = 200
    INS_FMIN        = 201
    INS_MOV         = 202
    INS_FMSUB       = 203
    INS_FMUL        = 204
    INS_MUL         = 205
    INS_NEG         = 206
    INS_FRCP        = 207
    INS_FRINT       = 208
    INS_FRSQRT      = 209
    INS_FSAF        = 210
    INS_FSEQ        = 211
    INS_FSLE        = 212
    INS_FSLT        = 213
    INS_FSNE        = 214
    INS_FSOR        = 215
    INS_FSQRT       = 216
    INS_SQRT        = 217
    INS_FSUB        = 218
    INS_SUB         = 219
    INS_FSUEQ       = 220
    INS_FSULE       = 221
    INS_FSULT       = 222
    INS_FSUNE       = 223
    INS_FSUN        = 224
    INS_FTINT_S     = 225
    INS_FTINT_U     = 226
    INS_FTQ         = 227
    INS_FTRUNC_S    = 228
    INS_FTRUNC_U    = 229
    INS_HADD_S      = 230
    INS_HADD_U      = 231
    INS_HSUB_S      = 232
    INS_HSUB_U      = 233
    INS_ILVEV       = 234
    INS_ILVL        = 235
    INS_ILVOD       = 236
    INS_ILVR        = 237
    INS_INS         = 238
    INS_INSERT      = 239
    INS_INSV        = 240
    INS_INSVE       = 241
    INS_J           = 242
    INS_JAL         = 243
    INS_JALR        = 244
    INS_JR          = 245
    INS_JRC         = 246
    INS_JALRC       = 247
    INS_LB          = 248
    INS_LBUX        = 249
    INS_LBU         = 250
    INS_LD          = 251
    INS_LDC1        = 252
    INS_LDC2        = 253
    INS_LDI         = 254
    INS_LDL         = 255
    INS_LDR         = 256
    INS_LDXC1       = 257
    INS_LH          = 258
    INS_LHX         = 259
    INS_LHU         = 260
    INS_LL          = 261
    INS_LLD         = 262
    INS_LSA         = 263
    INS_LUXC1       = 264
    INS_LUI         = 265
    INS_LW          = 266
    INS_LWC1        = 267
    INS_LWC2        = 268
    INS_LWL         = 269
    INS_LWR         = 270
    INS_LWX         = 271
    INS_LWXC1       = 272
    INS_LWU         = 273
    INS_LI          = 274
    INS_MADD        = 275
    INS_MADDR_Q     = 276
    INS_MADDU       = 277
    INS_MADDV       = 278
    INS_MADD_Q      = 279
    INS_MAQ_SA      = 280
    INS_MAQ_S       = 281
    INS_MAXI_S      = 282
    INS_MAXI_U      = 283
    INS_MAX_A       = 284
    INS_MAX_S       = 285
    INS_MAX_U       = 286
    INS_MFC0        = 287
    INS_MFC1        = 288
    INS_MFC2        = 289
    INS_MFHC1       = 290
    INS_MFHI        = 291
    INS_MFLO        = 292
    INS_MINI_S      = 293
    INS_MINI_U      = 294
    INS_MIN_A       = 295
    INS_MIN_S       = 296
    INS_MIN_U       = 297
    INS_MODSUB      = 298
    INS_MOD_S       = 299
    INS_MOD_U       = 300
    INS_MOVE        = 301
    INS_MOVF        = 302
    INS_MOVN        = 303
    INS_MOVT        = 304
    INS_MOVZ        = 305
    INS_MSUB        = 306
    INS_MSUBR_Q     = 307
    INS_MSUBU       = 308
    INS_MSUBV       = 309
    INS_MSUB_Q      = 310
    INS_MTC0        = 311
    INS_MTC1        = 312
    INS_MTC2        = 313
    INS_MTHC1       = 314
    INS_MTHI        = 315
    INS_MTHLIP      = 316
    INS_MTLO        = 317
    INS_MULEQ_S     = 318
    INS_MULEU_S     = 319
    INS_MULQ_RS     = 320
    INS_MULQ_S      = 321
    INS_MULR_Q      = 322
    INS_MULSAQ_S    = 323
    INS_MULSA       = 324
    INS_MULT        = 325
    INS_MULTU       = 326
    INS_MULV        = 327
    INS_MUL_Q       = 328
    INS_MUL_S       = 329
    INS_NLOC        = 330
    INS_NLZC        = 331
    INS_NMADD       = 332
    INS_NMSUB       = 333
    INS_NOR         = 334
    INS_NORI        = 335
    INS_NOT         = 336
    INS_OR          = 337
    INS_ORI         = 338
    INS_PACKRL      = 339
    INS_PCKEV       = 340
    INS_PCKOD       = 341
    INS_PCNT        = 342
    INS_PICK        = 343
    INS_PRECEQU     = 344
    INS_PRECEQ      = 345
    INS_PRECEU      = 346
    INS_PRECRQU_S   = 347
    INS_PRECRQ      = 348
    INS_PRECRQ_RS   = 349
    INS_PRECR       = 350
    INS_PRECR_SRA   = 351
    INS_PRECR_SRA_R = 352
    INS_PREPEND     = 353
    INS_RADDU       = 354
    INS_RDDSP       = 355
    INS_RDHWR       = 356
    INS_REPLV       = 357
    INS_REPL        = 358
    INS_ROTR        = 359
    INS_ROTRV       = 360
    INS_ROUND       = 361
    INS_RESTORE     = 362
    INS_SAT_S       = 363
    INS_SAT_U       = 364
    INS_SB          = 365
    INS_SC          = 366
    INS_SCD         = 367
    INS_SD          = 368
    INS_SDC1        = 369
    INS_SDC2        = 370
    INS_SDL         = 371
    INS_SDR         = 372
    INS_SDXC1       = 373
    INS_SEB         = 374
    INS_SEH         = 375
    INS_SH          = 376
    INS_SHF         = 377
    INS_SHILO       = 378
    INS_SHILOV      = 379
    INS_SHLLV       = 380
    INS_SHLLV_S     = 381
    INS_SHLL        = 382
    INS_SHLL_S      = 383
    INS_SHRAV       = 384
    INS_SHRAV_R     = 385
    INS_SHRA        = 386
    INS_SHRA_R      = 387
    INS_SHRLV       = 388
    INS_SHRL        = 389
    INS_SLDI        = 390
    INS_SLD         = 391
    INS_SLL         = 392
    INS_SLLI        = 393
    INS_SLLV        = 394
    INS_SLT         = 395
    INS_SLTI        = 396
    INS_SLTIU       = 397
    INS_SLTU        = 398
    INS_SPLATI      = 399
    INS_SPLAT       = 400
    INS_SRA         = 401
    INS_SRAI        = 402
    INS_SRARI       = 403
    INS_SRAR        = 404
    INS_SRAV        = 405
    INS_SRL         = 406
    INS_SRLI        = 407
    INS_SRLRI       = 408
    INS_SRLR        = 409
    INS_SRLV        = 410
    INS_ST          = 411
    INS_SUBQH       = 412
    INS_SUBQH_R     = 413
    INS_SUBQ        = 414
    INS_SUBQ_S      = 415
    INS_SUBSUS_U    = 416
    INS_SUBSUU_S    = 417
    INS_SUBS_S      = 418
    INS_SUBS_U      = 419
    INS_SUBUH       = 420
    INS_SUBUH_R     = 421
    INS_SUBU        = 422
    INS_SUBU_S      = 423
    INS_SUBVI       = 424
    INS_SUBV        = 425
    INS_SUXC1       = 426
    INS_SW          = 427
    INS_SWC1        = 428
    INS_SWC2        = 429
    INS_SWL         = 430
    INS_SWR         = 431
    INS_SWXC1       = 432
    INS_SYNC        = 433
    INS_SYSCALL     = 434
    INS_SAVE        = 435
    INS_TEQ         = 436
    INS_TEQI        = 437
    INS_TGE         = 438
    INS_TGEI        = 439
    INS_TGEIU       = 440
    INS_TGEU        = 441
    INS_TLT         = 442
    INS_TLTI        = 443
    INS_TLTU        = 444
    INS_TNE         = 445
    INS_TNEI        = 446
    INS_TRUNC       = 447
    INS_TLTIU       = 448
    INS_VSHF        = 449
    INS_WAIT        = 450
    INS_WRDSP       = 451
    INS_WSBH        = 452
    INS_XOR         = 453
    INS_XORI        = 454
    INS_NOP         = 455
    INS_MAX         = 456

    # Groups
    GRP_INVALID      = 0
    GRP_BITCOUNT     = 1
    GRP_DSP          = 2
    GRP_DSPR2        = 3
    GRP_FPIDX        = 4
    GRP_MSA          = 5
    GRP_MIPS32R2     = 6
    GRP_MIPS64       = 7
    GRP_MIPS64R2     = 8
    GRP_SEINREG      = 9
    GRP_STDENC       = 10
    GRP_SWAP         = 11
    GRP_MICROMIPS    = 12
    GRP_MIPS16MODE   = 13
    GRP_FP64BIT      = 14
    GRP_NONANSFPMATH = 15
    GRP_NOTFP64BIT   = 16
    GRP_RELOCSTATIC  = 17
    GRP_MAX          = 18

  end
end
