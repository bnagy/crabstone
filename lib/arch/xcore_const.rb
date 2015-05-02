# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

# THIS FILE WAS AUTO-GENERATED -- DO NOT EDIT!
# Command: ./genconst /Users/ben/src/capstone/bindings/python/capstone/
# 2015-05-02T13:24:01+12:00

module Crabstone
  module XCore

    # Operand type for instruction's operands
    
    OP_INVALID = 0
    OP_REG = 1
    OP_IMM = 2
    OP_MEM = 3
    
    # XCore registers
    
    REG_INVALID = 0
    REG_CP = 1
    REG_DP = 2
    REG_LR = 3
    REG_SP = 4
    REG_R0 = 5
    REG_R1 = 6
    REG_R2 = 7
    REG_R3 = 8
    REG_R4 = 9
    REG_R5 = 10
    REG_R6 = 11
    REG_R7 = 12
    REG_R8 = 13
    REG_R9 = 14
    REG_R10 = 15
    REG_R11 = 16
    
    # pseudo registers
    REG_PC = 17
    REG_SCP = 18
    REG_SSR = 19
    REG_ET = 20
    REG_ED = 21
    REG_SED = 22
    REG_KEP = 23
    REG_KSP = 24
    REG_ID = 25
    REG_ENDING = 26
    
    # XCore instruction
    
    INS_INVALID = 0
    INS_ADD = 1
    INS_ANDNOT = 2
    INS_AND = 3
    INS_ASHR = 4
    INS_BAU = 5
    INS_BITREV = 6
    INS_BLA = 7
    INS_BLAT = 8
    INS_BL = 9
    INS_BF = 10
    INS_BT = 11
    INS_BU = 12
    INS_BRU = 13
    INS_BYTEREV = 14
    INS_CHKCT = 15
    INS_CLRE = 16
    INS_CLRPT = 17
    INS_CLRSR = 18
    INS_CLZ = 19
    INS_CRC8 = 20
    INS_CRC32 = 21
    INS_DCALL = 22
    INS_DENTSP = 23
    INS_DGETREG = 24
    INS_DIVS = 25
    INS_DIVU = 26
    INS_DRESTSP = 27
    INS_DRET = 28
    INS_ECALLF = 29
    INS_ECALLT = 30
    INS_EDU = 31
    INS_EEF = 32
    INS_EET = 33
    INS_EEU = 34
    INS_ENDIN = 35
    INS_ENTSP = 36
    INS_EQ = 37
    INS_EXTDP = 38
    INS_EXTSP = 39
    INS_FREER = 40
    INS_FREET = 41
    INS_GETD = 42
    INS_GET = 43
    INS_GETN = 44
    INS_GETR = 45
    INS_GETSR = 46
    INS_GETST = 47
    INS_GETTS = 48
    INS_INCT = 49
    INS_INIT = 50
    INS_INPW = 51
    INS_INSHR = 52
    INS_INT = 53
    INS_IN = 54
    INS_KCALL = 55
    INS_KENTSP = 56
    INS_KRESTSP = 57
    INS_KRET = 58
    INS_LADD = 59
    INS_LD16S = 60
    INS_LD8U = 61
    INS_LDA16 = 62
    INS_LDAP = 63
    INS_LDAW = 64
    INS_LDC = 65
    INS_LDW = 66
    INS_LDIVU = 67
    INS_LMUL = 68
    INS_LSS = 69
    INS_LSUB = 70
    INS_LSU = 71
    INS_MACCS = 72
    INS_MACCU = 73
    INS_MJOIN = 74
    INS_MKMSK = 75
    INS_MSYNC = 76
    INS_MUL = 77
    INS_NEG = 78
    INS_NOT = 79
    INS_OR = 80
    INS_OUTCT = 81
    INS_OUTPW = 82
    INS_OUTSHR = 83
    INS_OUTT = 84
    INS_OUT = 85
    INS_PEEK = 86
    INS_REMS = 87
    INS_REMU = 88
    INS_RETSP = 89
    INS_SETCLK = 90
    INS_SET = 91
    INS_SETC = 92
    INS_SETD = 93
    INS_SETEV = 94
    INS_SETN = 95
    INS_SETPSC = 96
    INS_SETPT = 97
    INS_SETRDY = 98
    INS_SETSR = 99
    INS_SETTW = 100
    INS_SETV = 101
    INS_SEXT = 102
    INS_SHL = 103
    INS_SHR = 104
    INS_SSYNC = 105
    INS_ST16 = 106
    INS_ST8 = 107
    INS_STW = 108
    INS_SUB = 109
    INS_SYNCR = 110
    INS_TESTCT = 111
    INS_TESTLCL = 112
    INS_TESTWCT = 113
    INS_TSETMR = 114
    INS_START = 115
    INS_WAITEF = 116
    INS_WAITET = 117
    INS_WAITEU = 118
    INS_XOR = 119
    INS_ZEXT = 120
    INS_ENDING = 121
    
    # Group of XCore instructions
    
    GRP_INVALID = 0
    
    # Generic groups
    GRP_JUMP = 1
    GRP_ENDING = 2
  end
end
