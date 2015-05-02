# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

# THIS FILE WAS AUTO-GENERATED -- DO NOT EDIT!
# Command: ./genreg /Users/ben/src/capstone/bindings/python/capstone/
# 2015-05-02T13:24:08+12:00

module Crabstone
  module Sparc
    REG_LOOKUP = {
      'INVALID' => 0,
      'F0' => 1,
      'F1' => 2,
      'F2' => 3,
      'F3' => 4,
      'F4' => 5,
      'F5' => 6,
      'F6' => 7,
      'F7' => 8,
      'F8' => 9,
      'F9' => 10,
      'F10' => 11,
      'F11' => 12,
      'F12' => 13,
      'F13' => 14,
      'F14' => 15,
      'F15' => 16,
      'F16' => 17,
      'F17' => 18,
      'F18' => 19,
      'F19' => 20,
      'F20' => 21,
      'F21' => 22,
      'F22' => 23,
      'F23' => 24,
      'F24' => 25,
      'F25' => 26,
      'F26' => 27,
      'F27' => 28,
      'F28' => 29,
      'F29' => 30,
      'F30' => 31,
      'F31' => 32,
      'F32' => 33,
      'F34' => 34,
      'F36' => 35,
      'F38' => 36,
      'F40' => 37,
      'F42' => 38,
      'F44' => 39,
      'F46' => 40,
      'F48' => 41,
      'F50' => 42,
      'F52' => 43,
      'F54' => 44,
      'F56' => 45,
      'F58' => 46,
      'F60' => 47,
      'F62' => 48,
      'FCC0' => 49,
      'FCC1' => 50,
      'FCC2' => 51,
      'FCC3' => 52,
      'FP' => 53,
      'G0' => 54,
      'G1' => 55,
      'G2' => 56,
      'G3' => 57,
      'G4' => 58,
      'G5' => 59,
      'G6' => 60,
      'G7' => 61,
      'I0' => 62,
      'I1' => 63,
      'I2' => 64,
      'I3' => 65,
      'I4' => 66,
      'I5' => 67,
      'I7' => 68,
      'ICC' => 69,
      'L0' => 70,
      'L1' => 71,
      'L2' => 72,
      'L3' => 73,
      'L4' => 74,
      'L5' => 75,
      'L6' => 76,
      'L7' => 77,
      'O0' => 78,
      'O1' => 79,
      'O2' => 80,
      'O3' => 81,
      'O4' => 82,
      'O5' => 83,
      'O7' => 84,
      'SP' => 85,
      'Y' => 86,
      'XCC' => 87
    }

    ID_LOOKUP = REG_LOOKUP.invert

    # alias registers
    REG_LOOKUP['O6'] = REG_LOOKUP['SP']
    REG_LOOKUP['I6'] = REG_LOOKUP['FP']

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
