# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

# THIS FILE WAS AUTO-GENERATED -- DO NOT EDIT!
# Command: ./genreg /Users/ben/src/capstone/bindings/python/capstone/
# 2015-05-02T13:24:08+12:00

module Crabstone
  module XCore
    REG_LOOKUP = {
      'INVALID' => 0,
      'CP' => 1,
      'DP' => 2,
      'LR' => 3,
      'SP' => 4,
      'R0' => 5,
      'R1' => 6,
      'R2' => 7,
      'R3' => 8,
      'R4' => 9,
      'R5' => 10,
      'R6' => 11,
      'R7' => 12,
      'R8' => 13,
      'R9' => 14,
      'R10' => 15,
      'R11' => 16,
      'PC' => 17,
      'SCP' => 18,
      'SSR' => 19,
      'ET' => 20,
      'ED' => 21,
      'SED' => 22,
      'KEP' => 23,
      'KSP' => 24,
      'ID' => 25
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
