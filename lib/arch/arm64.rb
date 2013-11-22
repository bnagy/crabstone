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
        :operands, [Operand, 32]
      )
      
      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    # ARM64 operand shift type
    SFT_INVALID = 0
    SFT_LSL     = 1
    SFT_MSL     = 2
    SFT_LSR     = 3
    SFT_ASR     = 4
    SFT_ROR     = 5

    # ARM64 extension type (for operands)
    EXT_INVALID = 0
    EXT_UXTB    = 1
    EXT_UXTH    = 2
    EXT_UXTW    = 3
    EXT_UXTX    = 4
    EXT_SXTB    = 5
    EXT_SXTH    = 6
    EXT_SXTW    = 7
    EXT_SXTX    = 8

    # ARM64 code condition type
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
    CC_NV      = 16

    # Operand type
    OP_INVALID = 0  # Uninitialized.
    OP_REG     = 1   # Register operand.
    OP_CIMM    = 2   # C-Immediate operand.
    OP_IMM     = 3   # Immediate operand.
    OP_FP      = 4    # Floating-Point immediate operand.
    OP_MEM     = 5   # Memory operand

    # ARM registers
    REG_INVALID = 0
    REG_NZCV    = 1
    REG_WSP     = 2
    REG_WZR     = 3
    REG_SP      = 4
    REG_XZR     = 5
    REG_B0      = 6
    REG_B1      = 7
    REG_B2      = 8
    REG_B3      = 9
    REG_B4      = 10
    REG_B5      = 11
    REG_B6      = 12
    REG_B7      = 13
    REG_B8      = 14
    REG_B9      = 15
    REG_B10     = 16
    REG_B11     = 17
    REG_B12     = 18
    REG_B13     = 19
    REG_B14     = 20
    REG_B15     = 21
    REG_B16     = 22
    REG_B17     = 23
    REG_B18     = 24
    REG_B19     = 25
    REG_B20     = 26
    REG_B21     = 27
    REG_B22     = 28
    REG_B23     = 29
    REG_B24     = 30
    REG_B25     = 31
    REG_B26     = 32
    REG_B27     = 33
    REG_B28     = 34
    REG_B29     = 35
    REG_B30     = 36
    REG_B31     = 37
    REG_D0      = 38
    REG_D1      = 39
    REG_D2      = 40
    REG_D3      = 41
    REG_D4      = 42
    REG_D5      = 43
    REG_D6      = 44
    REG_D7      = 45
    REG_D8      = 46
    REG_D9      = 47
    REG_D10     = 48
    REG_D11     = 49
    REG_D12     = 50
    REG_D13     = 51
    REG_D14     = 52
    REG_D15     = 53
    REG_D16     = 54
    REG_D17     = 55
    REG_D18     = 56
    REG_D19     = 57
    REG_D20     = 58
    REG_D21     = 59
    REG_D22     = 60
    REG_D23     = 61
    REG_D24     = 62
    REG_D25     = 63
    REG_D26     = 64
    REG_D27     = 65
    REG_D28     = 66
    REG_D29     = 67
    REG_D30     = 68
    REG_D31     = 69
    REG_H0      = 70
    REG_H1      = 71
    REG_H2      = 72
    REG_H3      = 73
    REG_H4      = 74
    REG_H5      = 75
    REG_H6      = 76
    REG_H7      = 77
    REG_H8      = 78
    REG_H9      = 79
    REG_H10     = 80
    REG_H11     = 81
    REG_H12     = 82
    REG_H13     = 83
    REG_H14     = 84
    REG_H15     = 85
    REG_H16     = 86
    REG_H17     = 87
    REG_H18     = 88
    REG_H19     = 89
    REG_H20     = 90
    REG_H21     = 91
    REG_H22     = 92
    REG_H23     = 93
    REG_H24     = 94
    REG_H25     = 95
    REG_H26     = 96
    REG_H27     = 97
    REG_H28     = 98
    REG_H29     = 99
    REG_H30     = 100
    REG_H31     = 101
    REG_Q0      = 102
    REG_Q1      = 103
    REG_Q2      = 104
    REG_Q3      = 105
    REG_Q4      = 106
    REG_Q5      = 107
    REG_Q6      = 108
    REG_Q7      = 109
    REG_Q8      = 110
    REG_Q9      = 111
    REG_Q10     = 112
    REG_Q11     = 113
    REG_Q12     = 114
    REG_Q13     = 115
    REG_Q14     = 116
    REG_Q15     = 117
    REG_Q16     = 118
    REG_Q17     = 119
    REG_Q18     = 120
    REG_Q19     = 121
    REG_Q20     = 122
    REG_Q21     = 123
    REG_Q22     = 124
    REG_Q23     = 125
    REG_Q24     = 126
    REG_Q25     = 127
    REG_Q26     = 128
    REG_Q27     = 129
    REG_Q28     = 130
    REG_Q29     = 131
    REG_Q30     = 132
    REG_Q31     = 133
    REG_S0      = 134
    REG_S1      = 135
    REG_S2      = 136
    REG_S3      = 137
    REG_S4      = 138
    REG_S5      = 139
    REG_S6      = 140
    REG_S7      = 141
    REG_S8      = 142
    REG_S9      = 143
    REG_S10     = 144
    REG_S11     = 145
    REG_S12     = 146
    REG_S13     = 147
    REG_S14     = 148
    REG_S15     = 149
    REG_S16     = 150
    REG_S17     = 151
    REG_S18     = 152
    REG_S19     = 153
    REG_S20     = 154
    REG_S21     = 155
    REG_S22     = 156
    REG_S23     = 157
    REG_S24     = 158
    REG_S25     = 159
    REG_S26     = 160
    REG_S27     = 161
    REG_S28     = 162
    REG_S29     = 163
    REG_S30     = 164
    REG_S31     = 165
    REG_W0      = 166
    REG_W1      = 167
    REG_W2      = 168
    REG_W3      = 169
    REG_W4      = 170
    REG_W5      = 171
    REG_W6      = 172
    REG_W7      = 173
    REG_W8      = 174
    REG_W9      = 175
    REG_W10     = 176
    REG_W11     = 177
    REG_W12     = 178
    REG_W13     = 179
    REG_W14     = 180
    REG_W15     = 181
    REG_W16     = 182
    REG_W17     = 183
    REG_W18     = 184
    REG_W19     = 185
    REG_W20     = 186
    REG_W21     = 187
    REG_W22     = 188
    REG_W23     = 189
    REG_W24     = 190
    REG_W25     = 191
    REG_W26     = 192
    REG_W27     = 193
    REG_W28     = 194
    REG_W29     = 195
    REG_W30     = 196
    REG_X0      = 197
    REG_X1      = 198
    REG_X2      = 199
    REG_X3      = 200
    REG_X4      = 201
    REG_X5      = 202
    REG_X6      = 203
    REG_X7      = 204
    REG_X8      = 205
    REG_X9      = 206
    REG_X10     = 207
    REG_X11     = 208
    REG_X12     = 209
    REG_X13     = 210
    REG_X14     = 211
    REG_X15     = 212
    REG_X16     = 213
    REG_X17     = 214
    REG_X18     = 215
    REG_X19     = 216
    REG_X20     = 217
    REG_X21     = 218
    REG_X22     = 219
    REG_X23     = 220
    REG_X24     = 221
    REG_X25     = 222
    REG_X26     = 223
    REG_X27     = 224
    REG_X28     = 225
    REG_X29     = 226
    REG_X30     = 227

    # ARM64 instructions
    INS_INVALID   = 0
    INS_ADC       = 1
    INS_ADDHN2    = 2
    INS_ADDHN     = 3
    INS_ADDP      = 4
    INS_ADD       = 5
    INS_CMN       = 6
    INS_ADRP      = 7
    INS_ADR       = 8
    INS_AND       = 9
    INS_ASR       = 10
    INS_AT        = 11
    INS_BFI       = 12
    INS_BFM       = 13
    INS_BFXIL     = 14
    INS_BIC       = 15
    INS_BIF       = 16
    INS_BIT       = 17
    INS_BLR       = 18
    INS_BL        = 19
    INS_BRK       = 20
    INS_BR        = 21
    INS_BSL       = 22
    INS_B         = 23
    INS_CBNZ      = 24
    INS_CBZ       = 25
    INS_CCMN      = 26
    INS_CCMP      = 27
    INS_CLREX     = 28
    INS_CLS       = 29
    INS_CLZ       = 30
    INS_CMEQ      = 31
    INS_CMGE      = 32
    INS_CMGT      = 33
    INS_CMHI      = 34
    INS_CMHS      = 35
    INS_CMLE      = 36
    INS_CMLT      = 37
    INS_CMP       = 38
    INS_CMTST     = 39
    INS_CRC32B    = 40
    INS_CRC32CB   = 41
    INS_CRC32CH   = 42
    INS_CRC32CW   = 43
    INS_CRC32CX   = 44
    INS_CRC32H    = 45
    INS_CRC32W    = 46
    INS_CRC32X    = 47
    INS_CSEL      = 48
    INS_CSINC     = 49
    INS_CSINV     = 50
    INS_CSNEG     = 51
    INS_DCPS1     = 52
    INS_DCPS2     = 53
    INS_DCPS3     = 54
    INS_DC        = 55
    INS_DMB       = 56
    INS_DRPS      = 57
    INS_DSB       = 58
    INS_EON       = 59
    INS_EOR       = 60
    INS_ERET      = 61
    INS_EXTR      = 62
    INS_FABD      = 63
    INS_FABS      = 64
    INS_FACGE     = 65
    INS_FACGT     = 66
    INS_FADDP     = 67
    INS_FADD      = 68
    INS_FCCMPE    = 69
    INS_FCCMP     = 70
    INS_FCMEQ     = 71
    INS_FCMGE     = 72
    INS_FCMGT     = 73
    INS_FCMLE     = 74
    INS_FCMLT     = 75
    INS_FCMP      = 76
    INS_FCMPE     = 77
    INS_FCSEL     = 78
    INS_FCVTAS    = 79
    INS_FCVTAU    = 80
    INS_FCVTMS    = 81
    INS_FCVTMU    = 82
    INS_FCVTNS    = 83
    INS_FCVTNU    = 84
    INS_FCVTPS    = 85
    INS_FCVTPU    = 86
    INS_FCVTZS    = 87
    INS_FCVTZU    = 88
    INS_FCVT      = 89
    INS_FDIV      = 90
    INS_FMADD     = 91
    INS_FMAXNMP   = 92
    INS_FMAXNM    = 93
    INS_FMAXP     = 94
    INS_FMAX      = 95
    INS_FMINNMP   = 96
    INS_FMINNM    = 97
    INS_FMINP     = 98
    INS_FMIN      = 99
    INS_FMLA      = 100
    INS_FMLS      = 101
    INS_FMOV      = 102
    INS_FMSUB     = 103
    INS_FMULX     = 104
    INS_FMUL      = 105
    INS_FNEG      = 106
    INS_FNMADD    = 107
    INS_FNMSUB    = 108
    INS_FNMUL     = 109
    INS_FRECPS    = 110
    INS_FRINTA    = 111
    INS_FRINTI    = 112
    INS_FRINTM    = 113
    INS_FRINTN    = 114
    INS_FRINTP    = 115
    INS_FRINTX    = 116
    INS_FRINTZ    = 117
    INS_FRSQRTS   = 118
    INS_FSQRT     = 119
    INS_FSUB      = 120
    INS_HINT      = 121
    INS_HLT       = 122
    INS_HVC       = 123
    INS_IC        = 124
    INS_INS       = 125
    INS_ISB       = 126
    INS_LDARB     = 127
    INS_LDAR      = 128
    INS_LDARH     = 129
    INS_LDAXP     = 130
    INS_LDAXRB    = 131
    INS_LDAXR     = 132
    INS_LDAXRH    = 133
    INS_LDPSW     = 134
    INS_LDRSB     = 135
    INS_LDURSB    = 136
    INS_LDRSH     = 137
    INS_LDURSH    = 138
    INS_LDRSW     = 139
    INS_LDR       = 140
    INS_LDTRSB    = 141
    INS_LDTRSH    = 142
    INS_LDTRSW    = 143
    INS_LDURSW    = 144
    INS_LDXP      = 145
    INS_LDXRB     = 146
    INS_LDXR      = 147
    INS_LDXRH     = 148
    INS_LDRH      = 149
    INS_LDURH     = 150
    INS_STRH      = 151
    INS_STURH     = 152
    INS_LDTRH     = 153
    INS_STTRH     = 154
    INS_LDUR      = 155
    INS_STR       = 156
    INS_STUR      = 157
    INS_LDTR      = 158
    INS_STTR      = 159
    INS_LDRB      = 160
    INS_LDURB     = 161
    INS_STRB      = 162
    INS_STURB     = 163
    INS_LDTRB     = 164
    INS_STTRB     = 165
    INS_LDP       = 166
    INS_LDNP      = 167
    INS_STNP      = 168
    INS_STP       = 169
    INS_LSL       = 170
    INS_LSR       = 171
    INS_MADD      = 172
    INS_MLA       = 173
    INS_MLS       = 174
    INS_MOVI      = 175
    INS_MOVK      = 176
    INS_MOVN      = 177
    INS_MOVZ      = 178
    INS_MRS       = 179
    INS_MSR       = 180
    INS_MSUB      = 181
    INS_MUL       = 182
    INS_MVNI      = 183
    INS_MVN       = 184
    INS_ORN       = 185
    INS_ORR       = 186
    INS_PMULL2    = 187
    INS_PMULL     = 188
    INS_PMUL      = 189
    INS_PRFM      = 190
    INS_PRFUM     = 191
    INS_SQRSHRUN2 = 192
    INS_SQRSHRUN  = 193
    INS_SQSHRUN2  = 194
    INS_SQSHRUN   = 195
    INS_RADDHN2   = 196
    INS_RADDHN    = 197
    INS_RBIT      = 198
    INS_RET       = 199
    INS_REV16     = 200
    INS_REV32     = 201
    INS_REV       = 202
    INS_ROR       = 203
    INS_RSHRN2    = 204
    INS_RSHRN     = 205
    INS_RSUBHN2   = 206
    INS_RSUBHN    = 207
    INS_SABAL2    = 208
    INS_SABAL     = 209
    INS_SABA      = 210
    INS_SABDL2    = 211
    INS_SABDL     = 212
    INS_SABD      = 213
    INS_SADDL2    = 214
    INS_SADDL     = 215
    INS_SADDW2    = 216
    INS_SADDW     = 217
    INS_SBC       = 218
    INS_SBFIZ     = 219
    INS_SBFM      = 220
    INS_SBFX      = 221
    INS_SCVTF     = 222
    INS_SDIV      = 223
    INS_SHADD     = 224
    INS_SHL       = 225
    INS_SHRN2     = 226
    INS_SHRN      = 227
    INS_SHSUB     = 228
    INS_SLI       = 229
    INS_SMADDL    = 230
    INS_SMAXP     = 231
    INS_SMAX      = 232
    INS_SMC       = 233
    INS_SMINP     = 234
    INS_SMIN      = 235
    INS_SMLAL2    = 236
    INS_SMLAL     = 237
    INS_SMLSL2    = 238
    INS_SMLSL     = 239
    INS_SMOV      = 240
    INS_SMSUBL    = 241
    INS_SMULH     = 242
    INS_SMULL2    = 243
    INS_SMULL     = 244
    INS_SQADD     = 245
    INS_SQDMLAL2  = 246
    INS_SQDMLAL   = 247
    INS_SQDMLSL2  = 248
    INS_SQDMLSL   = 249
    INS_SQDMULH   = 250
    INS_SQDMULL2  = 251
    INS_SQDMULL   = 252
    INS_SQRDMULH  = 253
    INS_SQRSHL    = 254
    INS_SQRSHRN2  = 255
    INS_SQRSHRN   = 256
    INS_SQSHLU    = 257
    INS_SQSHL     = 258
    INS_SQSHRN2   = 259
    INS_SQSHRN    = 260
    INS_SQSUB     = 261
    INS_SRHADD    = 262
    INS_SRI       = 263
    INS_SRSHL     = 264
    INS_SRSHR     = 265
    INS_SRSRA     = 266
    INS_SSHLL2    = 267
    INS_SSHLL     = 268
    INS_SSHL      = 269
    INS_SSHR      = 270
    INS_SSRA      = 271
    INS_SSUBL2    = 272
    INS_SSUBL     = 273
    INS_SSUBW2    = 274
    INS_SSUBW     = 275
    INS_STLRB     = 276
    INS_STLR      = 277
    INS_STLRH     = 278
    INS_STLXP     = 279
    INS_STLXRB    = 280
    INS_STLXR     = 281
    INS_STLXRH    = 282
    INS_STXP      = 283
    INS_STXRB     = 284
    INS_STXR      = 285
    INS_STXRH     = 286
    INS_SUBHN2    = 287
    INS_SUBHN     = 288
    INS_SUB       = 289
    INS_SVC       = 290
    INS_SXTB      = 291
    INS_SXTH      = 292
    INS_SXTW      = 293
    INS_SYSL      = 294
    INS_SYS       = 295
    INS_TBNZ      = 296
    INS_TBZ       = 297
    INS_TLBI      = 298
    INS_TST       = 299
    INS_UABAL2    = 300
    INS_UABAL     = 301
    INS_UABA      = 302
    INS_UABDL2    = 303
    INS_UABDL     = 304
    INS_UABD      = 305
    INS_UADDL2    = 306
    INS_UADDL     = 307
    INS_UADDW2    = 308
    INS_UADDW     = 309
    INS_UBFIZ     = 310
    INS_UBFM      = 311
    INS_UBFX      = 312
    INS_UCVTF     = 313
    INS_UDIV      = 314
    INS_UHADD     = 315
    INS_UHSUB     = 316
    INS_UMADDL    = 317
    INS_UMAXP     = 318
    INS_UMAX      = 319
    INS_UMINP     = 320
    INS_UMIN      = 321
    INS_UMLAL2    = 322
    INS_UMLAL     = 323
    INS_UMLSL2    = 324
    INS_UMLSL     = 325
    INS_UMOV      = 326
    INS_UMSUBL    = 327
    INS_UMULH     = 328
    INS_UMULL2    = 329
    INS_UMULL     = 330
    INS_UQADD     = 331
    INS_UQRSHL    = 332
    INS_UQRSHRN2  = 333
    INS_UQRSHRN   = 334
    INS_UQSHL     = 335
    INS_UQSHRN2   = 336
    INS_UQSHRN    = 337
    INS_UQSUB     = 338
    INS_URHADD    = 339
    INS_URSHL     = 340
    INS_URSHR     = 341
    INS_URSRA     = 342
    INS_USHLL2    = 343
    INS_USHLL     = 344
    INS_USHL      = 345
    INS_USHR      = 346
    INS_USRA      = 347
    INS_USUBL2    = 348
    INS_USUBL     = 349
    INS_USUBW2    = 350
    INS_USUBW     = 351
    INS_UXTB      = 352
    INS_UXTH      = 353

    # ARM64 group of instructions
    GRP_INVALID = 0
    GRP_NEON    = 1
  end
end
