# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

# THIS FILE WAS AUTO-GENERATED -- DO NOT EDIT!
# Command: ./genreg /Users/ben/src/capstone/bindings/python/capstone/
# 2015-05-02T13:24:07+12:00

module Crabstone
  module MIPS
    REG_LOOKUP = {
      'INVALID' => 0,
      '0' => 1,
      '1' => 2,
      '2' => 3,
      '3' => 4,
      '4' => 5,
      '5' => 6,
      '6' => 7,
      '7' => 8,
      '8' => 9,
      '9' => 10,
      '10' => 11,
      '11' => 12,
      '12' => 13,
      '13' => 14,
      '14' => 15,
      '15' => 16,
      '16' => 17,
      '17' => 18,
      '18' => 19,
      '19' => 20,
      '20' => 21,
      '21' => 22,
      '22' => 23,
      '23' => 24,
      '24' => 25,
      '25' => 26,
      '26' => 27,
      '27' => 28,
      '28' => 29,
      '29' => 30,
      '30' => 31,
      '31' => 32,
      'DSPCCOND' => 33,
      'DSPCARRY' => 34,
      'DSPEFI' => 35,
      'DSPOUTFLAG' => 36,
      'DSPOUTFLAG16_19' => 37,
      'DSPOUTFLAG20' => 38,
      'DSPOUTFLAG21' => 39,
      'DSPOUTFLAG22' => 40,
      'DSPOUTFLAG23' => 41,
      'DSPPOS' => 42,
      'DSPSCOUNT' => 43,
      'AC0' => 44,
      'AC1' => 45,
      'AC2' => 46,
      'AC3' => 47,
      'CC0' => 48,
      'CC1' => 49,
      'CC2' => 50,
      'CC3' => 51,
      'CC4' => 52,
      'CC5' => 53,
      'CC6' => 54,
      'CC7' => 55,
      'F0' => 56,
      'F1' => 57,
      'F2' => 58,
      'F3' => 59,
      'F4' => 60,
      'F5' => 61,
      'F6' => 62,
      'F7' => 63,
      'F8' => 64,
      'F9' => 65,
      'F10' => 66,
      'F11' => 67,
      'F12' => 68,
      'F13' => 69,
      'F14' => 70,
      'F15' => 71,
      'F16' => 72,
      'F17' => 73,
      'F18' => 74,
      'F19' => 75,
      'F20' => 76,
      'F21' => 77,
      'F22' => 78,
      'F23' => 79,
      'F24' => 80,
      'F25' => 81,
      'F26' => 82,
      'F27' => 83,
      'F28' => 84,
      'F29' => 85,
      'F30' => 86,
      'F31' => 87,
      'FCC0' => 88,
      'FCC1' => 89,
      'FCC2' => 90,
      'FCC3' => 91,
      'FCC4' => 92,
      'FCC5' => 93,
      'FCC6' => 94,
      'FCC7' => 95,
      'W0' => 96,
      'W1' => 97,
      'W2' => 98,
      'W3' => 99,
      'W4' => 100,
      'W5' => 101,
      'W6' => 102,
      'W7' => 103,
      'W8' => 104,
      'W9' => 105,
      'W10' => 106,
      'W11' => 107,
      'W12' => 108,
      'W13' => 109,
      'W14' => 110,
      'W15' => 111,
      'W16' => 112,
      'W17' => 113,
      'W18' => 114,
      'W19' => 115,
      'W20' => 116,
      'W21' => 117,
      'W22' => 118,
      'W23' => 119,
      'W24' => 120,
      'W25' => 121,
      'W26' => 122,
      'W27' => 123,
      'W28' => 124,
      'W29' => 125,
      'W30' => 126,
      'W31' => 127,
      'HI' => 128,
      'LO' => 129,
      'P0' => 130,
      'P1' => 131,
      'P2' => 132,
      'MPL0' => 133,
      'MPL1' => 134,
      'MPL2' => 135
    }

    ID_LOOKUP = REG_LOOKUP.invert

    # alias registers
    REG_LOOKUP['ZERO'] = REG_LOOKUP['0']
    REG_LOOKUP['AT'] = REG_LOOKUP['1']
    REG_LOOKUP['V0'] = REG_LOOKUP['2']
    REG_LOOKUP['V1'] = REG_LOOKUP['3']
    REG_LOOKUP['A0'] = REG_LOOKUP['4']
    REG_LOOKUP['A1'] = REG_LOOKUP['5']
    REG_LOOKUP['A2'] = REG_LOOKUP['6']
    REG_LOOKUP['A3'] = REG_LOOKUP['7']
    REG_LOOKUP['T0'] = REG_LOOKUP['8']
    REG_LOOKUP['T1'] = REG_LOOKUP['9']
    REG_LOOKUP['T2'] = REG_LOOKUP['10']
    REG_LOOKUP['T3'] = REG_LOOKUP['11']
    REG_LOOKUP['T4'] = REG_LOOKUP['12']
    REG_LOOKUP['T5'] = REG_LOOKUP['13']
    REG_LOOKUP['T6'] = REG_LOOKUP['14']
    REG_LOOKUP['T7'] = REG_LOOKUP['15']
    REG_LOOKUP['S0'] = REG_LOOKUP['16']
    REG_LOOKUP['S1'] = REG_LOOKUP['17']
    REG_LOOKUP['S2'] = REG_LOOKUP['18']
    REG_LOOKUP['S3'] = REG_LOOKUP['19']
    REG_LOOKUP['S4'] = REG_LOOKUP['20']
    REG_LOOKUP['S5'] = REG_LOOKUP['21']
    REG_LOOKUP['S6'] = REG_LOOKUP['22']
    REG_LOOKUP['S7'] = REG_LOOKUP['23']
    REG_LOOKUP['T8'] = REG_LOOKUP['24']
    REG_LOOKUP['T9'] = REG_LOOKUP['25']
    REG_LOOKUP['K0'] = REG_LOOKUP['26']
    REG_LOOKUP['K1'] = REG_LOOKUP['27']
    REG_LOOKUP['GP'] = REG_LOOKUP['28']
    REG_LOOKUP['SP'] = REG_LOOKUP['29']
    REG_LOOKUP['FP'] = REG_LOOKUP['30']
    REG_LOOKUP['S8'] = REG_LOOKUP['30']
    REG_LOOKUP['RA'] = REG_LOOKUP['31']
    REG_LOOKUP['HI0'] = REG_LOOKUP['AC0']
    REG_LOOKUP['HI1'] = REG_LOOKUP['AC1']
    REG_LOOKUP['HI2'] = REG_LOOKUP['AC2']
    REG_LOOKUP['HI3'] = REG_LOOKUP['AC3']
    REG_LOOKUP['LO0'] = REG_LOOKUP['HI0']
    REG_LOOKUP['LO1'] = REG_LOOKUP['HI1']
    REG_LOOKUP['LO2'] = REG_LOOKUP['HI2']
    REG_LOOKUP['LO3'] = REG_LOOKUP['HI3']

    SYM_LOOKUP = Hash[REG_LOOKUP.map {|k,v| [k.downcase.to_sym,v]}]

    def self.register reg
      return reg if ID_LOOKUP[reg]
      return SYM_LOOKUP[reg] if SYM_LOOKUP[reg]
      if reg.respond_to? :upcase
        return REG_LOOKUP[reg.upcase] || REG_LOOKUP['INVALID']
      end
      REG_LOOKUP['INVALID']
    end

  end
end
