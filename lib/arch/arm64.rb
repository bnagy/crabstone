# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

module Crabstone
  module ARM64


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
        :disp, :int32
      )
    end

    class OperandValue < FFI::Union
      layout(
        :reg, :uint,
        :imm, :int32,
        :fp, :double,
        :mem, MemoryOperand
      )
    end

    class Operand < FFI::Struct

      layout(
        :shift, OperandShift,
        :ext, :uint,
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

      def shift_type
        self[:shift][:type]
      end

      def shift_value
        self[:shift][:value]
      end

      def shift?
        self[:shift][:type] != SFT_INVALID
      end

      def ext?
        self[:ext] != EXT_INVALID
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

      def mem?
        self[:type] == OP_MEM
      end

      def fp?
        self[:type] == OP_FP
      end

      def valid?
        [OP_MEM, OP_IMM, OP_CIMM, OP_FP, OP_REG].include? self[:type]
      end

    end

    class Instruction < FFI::Struct
      layout(
        :cc, :uint,
        :writeback, :bool,
        :update_flags, :bool,
        :op_count, :uint8,
        :operands, [Operand, 8]
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # ARM64 shift type

    SFT_INVALID = 0
    SFT_LSL = 1
    SFT_MSL = 2
    SFT_LSR = 3
    SFT_ASR = 4
    SFT_ROR = 5

    # ARM64 extender type

    EXT_INVALID = 0
    EXT_UXTB = 1
    EXT_UXTH = 2
    EXT_UXTW = 3
    EXT_UXTX = 4
    EXT_SXTB = 5
    EXT_SXTH = 6
    EXT_SXTW = 7
    EXT_SXTX = 8

    # ARM64 condition code

    CC_INVALID = 0
    CC_EQ = 1
    CC_NE = 2
    CC_HS = 3
    CC_LO = 4
    CC_MI = 5
    CC_PL = 6
    CC_VS = 7
    CC_VC = 8
    CC_HI = 9
    CC_LS = 10
    CC_GE = 11
    CC_LT = 12
    CC_GT = 13
    CC_LE = 14
    CC_AL = 15
    CC_NV = 16

    # Operand type for instruction's operands

    OP_INVALID = 0
    OP_REG = 1
    OP_CIMM = 2
    OP_IMM = 3
    OP_FP = 4
    OP_MEM = 5

    # ARM64 registers

    REG_INVALID = 0
    REG_NZCV = 1
    REG_WSP = 2
    REG_SP = 3
    REG_B0 = 4
    REG_B1 = 5
    REG_B2 = 6
    REG_B3 = 7
    REG_B4 = 8
    REG_B5 = 9
    REG_B6 = 10
    REG_B7 = 11
    REG_B8 = 12
    REG_B9 = 13
    REG_B10 = 14
    REG_B11 = 15
    REG_B12 = 16
    REG_B13 = 17
    REG_B14 = 18
    REG_B15 = 19
    REG_B16 = 20
    REG_B17 = 21
    REG_B18 = 22
    REG_B19 = 23
    REG_B20 = 24
    REG_B21 = 25
    REG_B22 = 26
    REG_B23 = 27
    REG_B24 = 28
    REG_B25 = 29
    REG_B26 = 30
    REG_B27 = 31
    REG_B28 = 32
    REG_B29 = 33
    REG_B30 = 34
    REG_B31 = 35
    REG_D0 = 36
    REG_D1 = 37
    REG_D2 = 38
    REG_D3 = 39
    REG_D4 = 40
    REG_D5 = 41
    REG_D6 = 42
    REG_D7 = 43
    REG_D8 = 44
    REG_D9 = 45
    REG_D10 = 46
    REG_D11 = 47
    REG_D12 = 48
    REG_D13 = 49
    REG_D14 = 50
    REG_D15 = 51
    REG_D16 = 52
    REG_D17 = 53
    REG_D18 = 54
    REG_D19 = 55
    REG_D20 = 56
    REG_D21 = 57
    REG_D22 = 58
    REG_D23 = 59
    REG_D24 = 60
    REG_D25 = 61
    REG_D26 = 62
    REG_D27 = 63
    REG_D28 = 64
    REG_D29 = 65
    REG_D30 = 66
    REG_D31 = 67
    REG_H0 = 68
    REG_H1 = 69
    REG_H2 = 70
    REG_H3 = 71
    REG_H4 = 72
    REG_H5 = 73
    REG_H6 = 74
    REG_H7 = 75
    REG_H8 = 76
    REG_H9 = 77
    REG_H10 = 78
    REG_H11 = 79
    REG_H12 = 80
    REG_H13 = 81
    REG_H14 = 82
    REG_H15 = 83
    REG_H16 = 84
    REG_H17 = 85
    REG_H18 = 86
    REG_H19 = 87
    REG_H20 = 88
    REG_H21 = 89
    REG_H22 = 90
    REG_H23 = 91
    REG_H24 = 92
    REG_H25 = 93
    REG_H26 = 94
    REG_H27 = 95
    REG_H28 = 96
    REG_H29 = 97
    REG_H30 = 98
    REG_H31 = 99
    REG_Q0 = 100
    REG_Q1 = 101
    REG_Q2 = 102
    REG_Q3 = 103
    REG_Q4 = 104
    REG_Q5 = 105
    REG_Q6 = 106
    REG_Q7 = 107
    REG_Q8 = 108
    REG_Q9 = 109
    REG_Q10 = 110
    REG_Q11 = 111
    REG_Q12 = 112
    REG_Q13 = 113
    REG_Q14 = 114
    REG_Q15 = 115
    REG_Q16 = 116
    REG_Q17 = 117
    REG_Q18 = 118
    REG_Q19 = 119
    REG_Q20 = 120
    REG_Q21 = 121
    REG_Q22 = 122
    REG_Q23 = 123
    REG_Q24 = 124
    REG_Q25 = 125
    REG_Q26 = 126
    REG_Q27 = 127
    REG_Q28 = 128
    REG_Q29 = 129
    REG_Q30 = 130
    REG_Q31 = 131
    REG_S0 = 132
    REG_S1 = 133
    REG_S2 = 134
    REG_S3 = 135
    REG_S4 = 136
    REG_S5 = 137
    REG_S6 = 138
    REG_S7 = 139
    REG_S8 = 140
    REG_S9 = 141
    REG_S10 = 142
    REG_S11 = 143
    REG_S12 = 144
    REG_S13 = 145
    REG_S14 = 146
    REG_S15 = 147
    REG_S16 = 148
    REG_S17 = 149
    REG_S18 = 150
    REG_S19 = 151
    REG_S20 = 152
    REG_S21 = 153
    REG_S22 = 154
    REG_S23 = 155
    REG_S24 = 156
    REG_S25 = 157
    REG_S26 = 158
    REG_S27 = 159
    REG_S28 = 160
    REG_S29 = 161
    REG_S30 = 162
    REG_S31 = 163
    REG_W0 = 164
    REG_W1 = 165
    REG_W2 = 166
    REG_W3 = 167
    REG_W4 = 168
    REG_W5 = 169
    REG_W6 = 170
    REG_W7 = 171
    REG_W8 = 172
    REG_W9 = 173
    REG_W10 = 174
    REG_W11 = 175
    REG_W12 = 176
    REG_W13 = 177
    REG_W14 = 178
    REG_W15 = 179
    REG_W16 = 180
    REG_W17 = 181
    REG_W18 = 182
    REG_W19 = 183
    REG_W20 = 184
    REG_W21 = 185
    REG_W22 = 186
    REG_W23 = 187
    REG_W24 = 188
    REG_W25 = 189
    REG_W26 = 190
    REG_W27 = 191
    REG_W28 = 192
    REG_W29 = 193
    REG_W30 = 194
    REG_X0 = 195
    REG_X1 = 196
    REG_X2 = 197
    REG_X3 = 198
    REG_X4 = 199
    REG_X5 = 200
    REG_X6 = 201
    REG_X7 = 202
    REG_X8 = 203
    REG_X9 = 204
    REG_X10 = 205
    REG_X11 = 206
    REG_X12 = 207
    REG_X13 = 208
    REG_X14 = 209
    REG_X15 = 210
    REG_X16 = 211
    REG_X17 = 212
    REG_X18 = 213
    REG_X19 = 214
    REG_X20 = 215
    REG_X21 = 216
    REG_X22 = 217
    REG_X23 = 218
    REG_X24 = 219
    REG_X25 = 220
    REG_X26 = 221
    REG_X27 = 222
    REG_X28 = 223
    REG_X29 = 224
    REG_X30 = 225
    REG_MAX = 226

    # alias registers
    REG_IP1 = REG_X16
    REG_IP0 = REG_X17
    REG_FP = REG_X29
    REG_LR = REG_X30
    REG_XZR = REG_SP
    REG_WZR = REG_WSP

    # ARM64 instruction

    INS_INVALID = 0
    INS_ABS = 1
    INS_ADC = 2
    INS_ADDHN2 = 3
    INS_ADDHN = 4
    INS_ADDP = 5
    INS_ADDV = 6
    INS_ADD = 7
    INS_CMN = 8
    INS_ADRP = 9
    INS_ADR = 10
    INS_AESD = 11
    INS_AESE = 12
    INS_AESIMC = 13
    INS_AESMC = 14
    INS_AND = 15
    INS_ASR = 16
    INS_AT = 17
    INS_BFI = 18
    INS_BFM = 19
    INS_BFXIL = 20
    INS_BIC = 21
    INS_BIF = 22
    INS_BIT = 23
    INS_BLR = 24
    INS_BL = 25
    INS_BRK = 26
    INS_BR = 27
    INS_BSL = 28
    INS_B = 29
    INS_CBNZ = 30
    INS_CBZ = 31
    INS_CCMN = 32
    INS_CCMP = 33
    INS_CLREX = 34
    INS_CLS = 35
    INS_CLZ = 36
    INS_CMEQ = 37
    INS_CMGE = 38
    INS_CMGT = 39
    INS_CMHI = 40
    INS_CMHS = 41
    INS_CMLE = 42
    INS_CMLT = 43
    INS_CMP = 44
    INS_CMTST = 45
    INS_CNT = 46
    INS_CRC32B = 47
    INS_CRC32CB = 48
    INS_CRC32CH = 49
    INS_CRC32CW = 50
    INS_CRC32CX = 51
    INS_CRC32H = 52
    INS_CRC32W = 53
    INS_CRC32X = 54
    INS_CSEL = 55
    INS_CSINC = 56
    INS_CSINV = 57
    INS_CSNEG = 58
    INS_DCPS1 = 59
    INS_DCPS2 = 60
    INS_DCPS3 = 61
    INS_DC = 62
    INS_DMB = 63
    INS_DRPS = 64
    INS_DSB = 65
    INS_DUP = 66
    INS_EON = 67
    INS_EOR = 68
    INS_ERET = 69
    INS_EXTR = 70
    INS_EXT = 71
    INS_FABD = 72
    INS_FABS = 73
    INS_FACGE = 74
    INS_FACGT = 75
    INS_FADDP = 76
    INS_FADD = 77
    INS_FCCMPE = 78
    INS_FCCMP = 79
    INS_FCMEQ = 80
    INS_FCMGE = 81
    INS_FCMGT = 82
    INS_FCMLE = 83
    INS_FCMLT = 84
    INS_FCMP = 85
    INS_FCMPE = 86
    INS_FCSEL = 87
    INS_FCVTAS = 88
    INS_FCVTAU = 89
    INS_FCVTL = 90
    INS_FCVTL2 = 91
    INS_FCVTMS = 92
    INS_FCVTMU = 93
    INS_FCVTN = 94
    INS_FCVTN2 = 95
    INS_FCVTNS = 96
    INS_FCVTNU = 97
    INS_FCVTPS = 98
    INS_FCVTPU = 99
    INS_FCVTXN = 100
    INS_FCVTXN2 = 101
    INS_FCVTZS = 102
    INS_FCVTZU = 103
    INS_FCVT = 104
    INS_FDIV = 105
    INS_FMADD = 106
    INS_FMAXNMP = 107
    INS_FMAXNMV = 108
    INS_FMAXNM = 109
    INS_FMAXP = 110
    INS_FMAXV = 111
    INS_FMAX = 112
    INS_FMINNMP = 113
    INS_FMINNMV = 114
    INS_FMINNM = 115
    INS_FMINP = 116
    INS_FMINV = 117
    INS_FMIN = 118
    INS_FMLA = 119
    INS_FMLS = 120
    INS_FMOV = 121
    INS_FMSUB = 122
    INS_FMULX = 123
    INS_FMUL = 124
    INS_FNEG = 125
    INS_FNMADD = 126
    INS_FNMSUB = 127
    INS_FNMUL = 128
    INS_FRECPE = 129
    INS_FRECPS = 130
    INS_FRECPX = 131
    INS_FRINTA = 132
    INS_FRINTI = 133
    INS_FRINTM = 134
    INS_FRINTN = 135
    INS_FRINTP = 136
    INS_FRINTX = 137
    INS_FRINTZ = 138
    INS_FRSQRTE = 139
    INS_FRSQRTS = 140
    INS_FSQRT = 141
    INS_FSUB = 142
    INS_HINT = 143
    INS_HLT = 144
    INS_HVC = 145
    INS_IC = 146
    INS_INS = 147
    INS_ISB = 148
    INS_LD1 = 149
    INS_LD1R = 150
    INS_LD2 = 151
    INS_LD2R = 152
    INS_LD3 = 153
    INS_LD3R = 154
    INS_LD4 = 155
    INS_LD4R = 156
    INS_LDARB = 157
    INS_LDAR = 158
    INS_LDARH = 159
    INS_LDAXP = 160
    INS_LDAXRB = 161
    INS_LDAXR = 162
    INS_LDAXRH = 163
    INS_LDPSW = 164
    INS_LDRSB = 165
    INS_LDURSB = 166
    INS_LDRSH = 167
    INS_LDURSH = 168
    INS_LDRSW = 169
    INS_LDR = 170
    INS_LDTRSB = 171
    INS_LDTRSH = 172
    INS_LDTRSW = 173
    INS_LDURSW = 174
    INS_LDXP = 175
    INS_LDXRB = 176
    INS_LDXR = 177
    INS_LDXRH = 178
    INS_LDRH = 179
    INS_LDURH = 180
    INS_STRH = 181
    INS_STURH = 182
    INS_LDTRH = 183
    INS_STTRH = 184
    INS_LDUR = 185
    INS_STR = 186
    INS_STUR = 187
    INS_LDTR = 188
    INS_STTR = 189
    INS_LDRB = 190
    INS_LDURB = 191
    INS_STRB = 192
    INS_STURB = 193
    INS_LDTRB = 194
    INS_STTRB = 195
    INS_LDP = 196
    INS_LDNP = 197
    INS_STNP = 198
    INS_STP = 199
    INS_LSL = 200
    INS_LSR = 201
    INS_MADD = 202
    INS_MLA = 203
    INS_MLS = 204
    INS_MOVI = 205
    INS_MOVK = 206
    INS_MOVN = 207
    INS_MOVZ = 208
    INS_MRS = 209
    INS_MSR = 210
    INS_MSUB = 211
    INS_MUL = 212
    INS_MVNI = 213
    INS_MVN = 214
    INS_NEG = 215
    INS_NOT = 216
    INS_ORN = 217
    INS_ORR = 218
    INS_PMULL2 = 219
    INS_PMULL = 220
    INS_PMUL = 221
    INS_PRFM = 222
    INS_PRFUM = 223
    INS_SQRSHRUN2 = 224
    INS_SQRSHRUN = 225
    INS_SQSHRUN2 = 226
    INS_SQSHRUN = 227
    INS_RADDHN2 = 228
    INS_RADDHN = 229
    INS_RBIT = 230
    INS_RET = 231
    INS_REV16 = 232
    INS_REV32 = 233
    INS_REV64 = 234
    INS_REV = 235
    INS_ROR = 236
    INS_RSHRN2 = 237
    INS_RSHRN = 238
    INS_RSUBHN2 = 239
    INS_RSUBHN = 240
    INS_SABAL2 = 241
    INS_SABAL = 242
    INS_SABA = 243
    INS_SABDL2 = 244
    INS_SABDL = 245
    INS_SABD = 246
    INS_SADALP = 247
    INS_SADDL2 = 248
    INS_SADDLP = 249
    INS_SADDLV = 250
    INS_SADDL = 251
    INS_SADDW2 = 252
    INS_SADDW = 253
    INS_SBC = 254
    INS_SBFIZ = 255
    INS_SBFM = 256
    INS_SBFX = 257
    INS_SCVTF = 258
    INS_SDIV = 259
    INS_SHA1C = 260
    INS_SHA1H = 261
    INS_SHA1M = 262
    INS_SHA1P = 263
    INS_SHA1SU0 = 264
    INS_SHA1SU1 = 265
    INS_SHA256H = 266
    INS_SHA256H2 = 267
    INS_SHA256SU0 = 268
    INS_SHA256SU1 = 269
    INS_SHADD = 270
    INS_SHLL2 = 271
    INS_SHLL = 272
    INS_SHL = 273
    INS_SHRN2 = 274
    INS_SHRN = 275
    INS_SHSUB = 276
    INS_SLI = 277
    INS_SMADDL = 278
    INS_SMAXP = 279
    INS_SMAXV = 280
    INS_SMAX = 281
    INS_SMC = 282
    INS_SMINP = 283
    INS_SMINV = 284
    INS_SMIN = 285
    INS_SMLAL2 = 286
    INS_SMLAL = 287
    INS_SMLSL2 = 288
    INS_SMLSL = 289
    INS_SMOV = 290
    INS_SMSUBL = 291
    INS_SMULH = 292
    INS_SMULL2 = 293
    INS_SMULL = 294
    INS_SQABS = 295
    INS_SQADD = 296
    INS_SQDMLAL2 = 297
    INS_SQDMLAL = 298
    INS_SQDMLSL2 = 299
    INS_SQDMLSL = 300
    INS_SQDMULH = 301
    INS_SQDMULL2 = 302
    INS_SQDMULL = 303
    INS_SQNEG = 304
    INS_SQRDMULH = 305
    INS_SQRSHL = 306
    INS_SQRSHRN = 307
    INS_SQRSHRN2 = 308
    INS_SQSHLU = 309
    INS_SQSHL = 310
    INS_SQSHRN = 311
    INS_SQSHRN2 = 312
    INS_SQSUB = 313
    INS_SQXTN = 314
    INS_SQXTN2 = 315
    INS_SQXTUN = 316
    INS_SQXTUN2 = 317
    INS_SRHADD = 318
    INS_SRI = 319
    INS_SRSHL = 320
    INS_SRSHR = 321
    INS_SRSRA = 322
    INS_SSHLL2 = 323
    INS_SSHLL = 324
    INS_SSHL = 325
    INS_SSHR = 326
    INS_SSRA = 327
    INS_SSUBL2 = 328
    INS_SSUBL = 329
    INS_SSUBW2 = 330
    INS_SSUBW = 331
    INS_ST1 = 332
    INS_ST2 = 333
    INS_ST3 = 334
    INS_ST4 = 335
    INS_STLRB = 336
    INS_STLR = 337
    INS_STLRH = 338
    INS_STLXP = 339
    INS_STLXRB = 340
    INS_STLXR = 341
    INS_STLXRH = 342
    INS_STXP = 343
    INS_STXRB = 344
    INS_STXR = 345
    INS_STXRH = 346
    INS_SUBHN2 = 347
    INS_SUBHN = 348
    INS_SUB = 349
    INS_SUQADD = 350
    INS_SVC = 351
    INS_SXTB = 352
    INS_SXTH = 353
    INS_SXTW = 354
    INS_SYSL = 355
    INS_SYS = 356
    INS_TBL = 357
    INS_TBNZ = 358
    INS_TBX = 359
    INS_TBZ = 360
    INS_TLBI = 361
    INS_TRN1 = 362
    INS_TRN2 = 363
    INS_TST = 364
    INS_UABAL2 = 365
    INS_UABAL = 366
    INS_UABA = 367
    INS_UABDL2 = 368
    INS_UABDL = 369
    INS_UABD = 370
    INS_UADALP = 371
    INS_UADDL2 = 372
    INS_UADDLP = 373
    INS_UADDLV = 374
    INS_UADDL = 375
    INS_UADDW2 = 376
    INS_UADDW = 377
    INS_UBFIZ = 378
    INS_UBFM = 379
    INS_UBFX = 380
    INS_UCVTF = 381
    INS_UDIV = 382
    INS_UHADD = 383
    INS_UHSUB = 384
    INS_UMADDL = 385
    INS_UMAXP = 386
    INS_UMAXV = 387
    INS_UMAX = 388
    INS_UMINP = 389
    INS_UMINV = 390
    INS_UMIN = 391
    INS_UMLAL2 = 392
    INS_UMLAL = 393
    INS_UMLSL2 = 394
    INS_UMLSL = 395
    INS_UMOV = 396
    INS_UMSUBL = 397
    INS_UMULH = 398
    INS_UMULL2 = 399
    INS_UMULL = 400
    INS_UQADD = 401
    INS_UQRSHL = 402
    INS_UQRSHRN = 403
    INS_UQRSHRN2 = 404
    INS_UQSHL = 405
    INS_UQSHRN = 406
    INS_UQSHRN2 = 407
    INS_UQSUB = 408
    INS_UQXTN = 409
    INS_UQXTN2 = 410
    INS_URECPE = 411
    INS_URHADD = 412
    INS_URSHL = 413
    INS_URSHR = 414
    INS_URSQRTE = 415
    INS_URSRA = 416
    INS_USHLL2 = 417
    INS_USHLL = 418
    INS_USHL = 419
    INS_USHR = 420
    INS_USQADD = 421
    INS_USRA = 422
    INS_USUBL2 = 423
    INS_USUBL = 424
    INS_USUBW2 = 425
    INS_USUBW = 426
    INS_UXTB = 427
    INS_UXTH = 428
    INS_UZP1 = 429
    INS_UZP2 = 430
    INS_XTN = 431
    INS_XTN2 = 432
    INS_ZIP1 = 433
    INS_ZIP2 = 434
    INS_MNEG = 435
    INS_UMNEGL = 436
    INS_SMNEGL = 437
    INS_MOV = 438
    INS_NOP = 439
    INS_YIELD = 440
    INS_WFE = 441
    INS_WFI = 442
    INS_SEV = 443
    INS_SEVL = 444
    INS_NGC = 445
    INS_MAX = 446

    # Group of ARM64 instructions

    GRP_INVALID = 0
    GRP_CRYPTO = 1
    GRP_FPARMV8 = 2
    GRP_NEON = 3
    GRP_JUMP = 4
    GRP_MAX = 5
  end
end
