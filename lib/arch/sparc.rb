# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

module Crabstone
  module Sparc

    class MemoryOperand < FFI::Struct
      layout(
        :base, :uint8,
        :index, :uint8,
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
        :cc, :uint,
        :hint, :uint,
        :op_count, :uint8,
        :operands, [Operand, 4],
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end

    CC_INVALID = 0

    # Integer condition codes
    CC_ICC_A   = 8
    CC_ICC_N   = 0
    CC_ICC_NE  = 9
    CC_ICC_E   = 1
    CC_ICC_G   = 10
    CC_ICC_LE  = 2
    CC_ICC_GE  = 11
    CC_ICC_L   = 3
    CC_ICC_GU  = 12
    CC_ICC_LEU = 4
    CC_ICC_CC  = 13
    CC_ICC_CS  = 5
    CC_ICC_POS = 14
    CC_ICC_NEG = 6
    CC_ICC_VC  = 15
    CC_ICC_VS  = 7

    # Floating condition codes
    CC_FCC_A   = 8+16
    CC_FCC_N   = 0+16
    CC_FCC_U   = 7+16
    CC_FCC_G   = 6+16
    CC_FCC_UG  = 5+16
    CC_FCC_L   = 4+16
    CC_FCC_UL  = 3+16
    CC_FCC_LG  = 2+16
    CC_FCC_NE  = 1+16
    CC_FCC_E   = 9+16
    CC_FCC_UE  = 10+16
    CC_FCC_GE  = 11+16
    CC_FCC_UGE = 12+16
    CC_FCC_LE  = 13+16
    CC_FCC_ULE = 14+16
    CC_FCC_O   = 15+16

    # Branch hint

    HINT_INVALID = 0
    HINT_A       = 1<<0
    HINT_PT      = 1<<1
    HINT_PN      = 1<<2

    # Operand type for instruction's operands

    OP_INVALID = 0
    OP_REG     = 1
    OP_IMM     = 2
    OP_MEM     = 3

    # SPARC registers

    REG_INVALID = 0
    REG_F0      = 1
    REG_F1      = 2
    REG_F2      = 3
    REG_F3      = 4
    REG_F4      = 5
    REG_F5      = 6
    REG_F6      = 7
    REG_F7      = 8
    REG_F8      = 9
    REG_F9      = 10
    REG_F10     = 11
    REG_F11     = 12
    REG_F12     = 13
    REG_F13     = 14
    REG_F14     = 15
    REG_F15     = 16
    REG_F16     = 17
    REG_F17     = 18
    REG_F18     = 19
    REG_F19     = 20
    REG_F20     = 21
    REG_F21     = 22
    REG_F22     = 23
    REG_F23     = 24
    REG_F24     = 25
    REG_F25     = 26
    REG_F26     = 27
    REG_F27     = 28
    REG_F28     = 29
    REG_F29     = 30
    REG_F30     = 31
    REG_F31     = 32
    REG_F32     = 33
    REG_F34     = 34
    REG_F36     = 35
    REG_F38     = 36
    REG_F40     = 37
    REG_F42     = 38
    REG_F44     = 39
    REG_F46     = 40
    REG_F48     = 41
    REG_F50     = 42
    REG_F52     = 43
    REG_F54     = 44
    REG_F56     = 45
    REG_F58     = 46
    REG_F60     = 47
    REG_F62     = 48
    REG_FCC0    = 49
    REG_FCC1    = 50
    REG_FCC2    = 51
    REG_FCC3    = 52
    REG_FP      = 53
    REG_G0      = 54
    REG_G1      = 55
    REG_G2      = 56
    REG_G3      = 57
    REG_G4      = 58
    REG_G5      = 59
    REG_G6      = 60
    REG_G7      = 61
    REG_I0      = 62
    REG_I1      = 63
    REG_I2      = 64
    REG_I3      = 65
    REG_I4      = 66
    REG_I5      = 67
    REG_I7      = 68
    REG_ICC     = 69
    REG_L0      = 70
    REG_L1      = 71
    REG_L2      = 72
    REG_L3      = 73
    REG_L4      = 74
    REG_L5      = 75
    REG_L6      = 76
    REG_L7      = 77
    REG_O0      = 78
    REG_O1      = 79
    REG_O2      = 80
    REG_O3      = 81
    REG_O4      = 82
    REG_O5      = 83
    REG_O7      = 84
    REG_SP      = 85
    REG_Y       = 86
    REG_MAX     = 87
    REG_O6      = REG_SP
    REG_I6      = REG_FP

    # SPARC instruction

    INS_INVALID     = 0
    INS_ADDCC       = 1
    INS_ADDX        = 2
    INS_ADDXCC      = 3
    INS_ADDXC       = 4
    INS_ADDXCCC     = 5
    INS_ADD         = 6
    INS_ALIGNADDR   = 7
    INS_ALIGNADDRL  = 8
    INS_ANDCC       = 9
    INS_ANDNCC      = 10
    INS_ANDN        = 11
    INS_AND         = 12
    INS_ARRAY16     = 13
    INS_ARRAY32     = 14
    INS_ARRAY8      = 15
    INS_BA          = 16
    INS_B           = 17
    INS_JMP         = 18
    INS_BMASK       = 19
    INS_FB          = 20
    INS_BRGEZ       = 21
    INS_BRGZ        = 22
    INS_BRLEZ       = 23
    INS_BRLZ        = 24
    INS_BRNZ        = 25
    INS_BRZ         = 26
    INS_BSHUFFLE    = 27
    INS_CALL        = 28
    INS_CASX        = 29
    INS_CAS         = 30
    INS_CMASK16     = 31
    INS_CMASK32     = 32
    INS_CMASK8      = 33
    INS_CMP         = 34
    INS_EDGE16      = 35
    INS_EDGE16L     = 36
    INS_EDGE16LN    = 37
    INS_EDGE16N     = 38
    INS_EDGE32      = 39
    INS_EDGE32L     = 40
    INS_EDGE32LN    = 41
    INS_EDGE32N     = 42
    INS_EDGE8       = 43
    INS_EDGE8L      = 44
    INS_EDGE8LN     = 45
    INS_EDGE8N      = 46
    INS_FABSD       = 47
    INS_FABSQ       = 48
    INS_FABSS       = 49
    INS_FADDD       = 50
    INS_FADDQ       = 51
    INS_FADDS       = 52
    INS_FALIGNDATA  = 53
    INS_FAND        = 54
    INS_FANDNOT1    = 55
    INS_FANDNOT1S   = 56
    INS_FANDNOT2    = 57
    INS_FANDNOT2S   = 58
    INS_FANDS       = 59
    INS_FCHKSM16    = 60
    INS_FCMPD       = 61
    INS_FCMPEQ16    = 62
    INS_FCMPEQ32    = 63
    INS_FCMPGT16    = 64
    INS_FCMPGT32    = 65
    INS_FCMPLE16    = 66
    INS_FCMPLE32    = 67
    INS_FCMPNE16    = 68
    INS_FCMPNE32    = 69
    INS_FCMPQ       = 70
    INS_FCMPS       = 71
    INS_FDIVD       = 72
    INS_FDIVQ       = 73
    INS_FDIVS       = 74
    INS_FDMULQ      = 75
    INS_FDTOI       = 76
    INS_FDTOQ       = 77
    INS_FDTOS       = 78
    INS_FDTOX       = 79
    INS_FEXPAND     = 80
    INS_FHADDD      = 81
    INS_FHADDS      = 82
    INS_FHSUBD      = 83
    INS_FHSUBS      = 84
    INS_FITOD       = 85
    INS_FITOQ       = 86
    INS_FITOS       = 87
    INS_FLCMPD      = 88
    INS_FLCMPS      = 89
    INS_FLUSHW      = 90
    INS_FMEAN16     = 91
    INS_FMOVD       = 92
    INS_FMOVQ       = 93
    INS_FMOVRDGEZ   = 94
    INS_FMOVRQGEZ   = 95
    INS_FMOVRSGEZ   = 96
    INS_FMOVRDGZ    = 97
    INS_FMOVRQGZ    = 98
    INS_FMOVRSGZ    = 99
    INS_FMOVRDLEZ   = 100
    INS_FMOVRQLEZ   = 101
    INS_FMOVRSLEZ   = 102
    INS_FMOVRDLZ    = 103
    INS_FMOVRQLZ    = 104
    INS_FMOVRSLZ    = 105
    INS_FMOVRDNZ    = 106
    INS_FMOVRQNZ    = 107
    INS_FMOVRSNZ    = 108
    INS_FMOVRDZ     = 109
    INS_FMOVRQZ     = 110
    INS_FMOVRSZ     = 111
    INS_FMOVS       = 112
    INS_FMUL8SUX16  = 113
    INS_FMUL8ULX16  = 114
    INS_FMUL8X16    = 115
    INS_FMUL8X16AL  = 116
    INS_FMUL8X16AU  = 117
    INS_FMULD       = 118
    INS_FMULD8SUX16 = 119
    INS_FMULD8ULX16 = 120
    INS_FMULQ       = 121
    INS_FMULS       = 122
    INS_FNADDD      = 123
    INS_FNADDS      = 124
    INS_FNAND       = 125
    INS_FNANDS      = 126
    INS_FNEGD       = 127
    INS_FNEGQ       = 128
    INS_FNEGS       = 129
    INS_FNHADDD     = 130
    INS_FNHADDS     = 131
    INS_FNOR        = 132
    INS_FNORS       = 133
    INS_FNOT1       = 134
    INS_FNOT1S      = 135
    INS_FNOT2       = 136
    INS_FNOT2S      = 137
    INS_FONE        = 138
    INS_FONES       = 139
    INS_FOR         = 140
    INS_FORNOT1     = 141
    INS_FORNOT1S    = 142
    INS_FORNOT2     = 143
    INS_FORNOT2S    = 144
    INS_FORS        = 145
    INS_FPACK16     = 146
    INS_FPACK32     = 147
    INS_FPACKFIX    = 148
    INS_FPADD16     = 149
    INS_FPADD16S    = 150
    INS_FPADD32     = 151
    INS_FPADD32S    = 152
    INS_FPADD64     = 153
    INS_FPMERGE     = 154
    INS_FPSUB16     = 155
    INS_FPSUB16S    = 156
    INS_FPSUB32     = 157
    INS_FPSUB32S    = 158
    INS_FQTOD       = 159
    INS_FQTOI       = 160
    INS_FQTOS       = 161
    INS_FQTOX       = 162
    INS_FSLAS16     = 163
    INS_FSLAS32     = 164
    INS_FSLL16      = 165
    INS_FSLL32      = 166
    INS_FSMULD      = 167
    INS_FSQRTD      = 168
    INS_FSQRTQ      = 169
    INS_FSQRTS      = 170
    INS_FSRA16      = 171
    INS_FSRA32      = 172
    INS_FSRC1       = 173
    INS_FSRC1S      = 174
    INS_FSRC2       = 175
    INS_FSRC2S      = 176
    INS_FSRL16      = 177
    INS_FSRL32      = 178
    INS_FSTOD       = 179
    INS_FSTOI       = 180
    INS_FSTOQ       = 181
    INS_FSTOX       = 182
    INS_FSUBD       = 183
    INS_FSUBQ       = 184
    INS_FSUBS       = 185
    INS_FXNOR       = 186
    INS_FXNORS      = 187
    INS_FXOR        = 188
    INS_FXORS       = 189
    INS_FXTOD       = 190
    INS_FXTOQ       = 191
    INS_FXTOS       = 192
    INS_FZERO       = 193
    INS_FZEROS      = 194
    INS_JMPL        = 195
    INS_LDD         = 196
    INS_LD          = 197
    INS_LDQ         = 198
    INS_LDSB        = 199
    INS_LDSH        = 200
    INS_LDSW        = 201
    INS_LDUB        = 202
    INS_LDUH        = 203
    INS_LDX         = 204
    INS_LZCNT       = 205
    INS_MEMBAR      = 206
    INS_MOVDTOX     = 207
    INS_MOV         = 208
    INS_MOVRGEZ     = 209
    INS_MOVRGZ      = 210
    INS_MOVRLEZ     = 211
    INS_MOVRLZ      = 212
    INS_MOVRNZ      = 213
    INS_MOVRZ       = 214
    INS_MOVSTOSW    = 215
    INS_MOVSTOUW    = 216
    INS_MULX        = 217
    INS_NOP         = 218
    INS_ORCC        = 219
    INS_ORNCC       = 220
    INS_ORN         = 221
    INS_OR          = 222
    INS_PDIST       = 223
    INS_PDISTN      = 224
    INS_POPC        = 225
    INS_RD          = 226
    INS_RESTORE     = 227
    INS_RETT        = 228
    INS_SAVE        = 229
    INS_SDIVCC      = 230
    INS_SDIVX       = 231
    INS_SDIV        = 232
    INS_SETHI       = 233
    INS_SHUTDOWN    = 234
    INS_SIAM        = 235
    INS_SLLX        = 236
    INS_SLL         = 237
    INS_SMULCC      = 238
    INS_SMUL        = 239
    INS_SRAX        = 240
    INS_SRA         = 241
    INS_SRLX        = 242
    INS_SRL         = 243
    INS_STBAR       = 244
    INS_STB         = 245
    INS_STD         = 246
    INS_ST          = 247
    INS_STH         = 248
    INS_STQ         = 249
    INS_STX         = 250
    INS_SUBCC       = 251
    INS_SUBX        = 252
    INS_SUBXCC      = 253
    INS_SUB         = 254
    INS_SWAP        = 255
    INS_TA          = 256
    INS_TADDCCTV    = 257
    INS_TADDCC      = 258
    INS_T           = 259
    INS_TSUBCCTV    = 260
    INS_TSUBCC      = 261
    INS_UDIVCC      = 262
    INS_UDIVX       = 263
    INS_UDIV        = 264
    INS_UMULCC      = 265
    INS_UMULXHI     = 266
    INS_UMUL        = 267
    INS_UNIMP       = 268
    INS_FCMPED      = 269
    INS_FCMPEQ      = 270
    INS_FCMPES      = 271
    INS_WR          = 272
    INS_XMULX       = 273
    INS_XMULXHI     = 274
    INS_XNORCC      = 275
    INS_XNOR        = 276
    INS_XORCC       = 277
    INS_XOR         = 278
    INS_MAX         = 279

    # Group of SPARC instructions

    GRP_INVALID  = 0
    GRP_HARDQUAD = 1
    GRP_V9       = 2
    GRP_VIS      = 3
    GRP_VIS2     = 4
    GRP_VIS3     = 5
    GRP_32BIT    = 6
    GRP_64BIT    = 7
    GRP_JUMP     = 8
    GRP_MAX      = 9


  end
end
