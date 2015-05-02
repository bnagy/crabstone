# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

# THIS FILE WAS AUTO-GENERATED -- DO NOT EDIT!
# Command: ./genreg /Users/ben/src/capstone/bindings/python/capstone/
# 2015-05-02T13:24:08+12:00

module Crabstone
  module SysZ
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
      'CC' => 17,
      'F0' => 18,
      'F1' => 19,
      'F2' => 20,
      'F3' => 21,
      'F4' => 22,
      'F5' => 23,
      'F6' => 24,
      'F7' => 25,
      'F8' => 26,
      'F9' => 27,
      'F10' => 28,
      'F11' => 29,
      'F12' => 30,
      'F13' => 31,
      'F14' => 32,
      'F15' => 33,
      'R0L' => 34
    }

    ID_LOOKUP = REG_LOOKUP.invert

    # alias registers

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
