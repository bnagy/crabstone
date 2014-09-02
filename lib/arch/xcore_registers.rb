module Crabstone
  module XCore
    REG_LOOKUP = {
      "INVALID" => 0,
      "R0"      => 1,
      "R1"      => 2,
      "R2"      => 3,
      "R3"      => 4,
      "R4"      => 5,
      "R5"      => 6,
      "R6"      => 7,
      "R7"      => 8,
      "R8"      => 9,
      "R9"      => 10,
      "R10"     => 11,
      "R11"     => 12,
      "R12"     => 13,
      "R13"     => 14,
      "R14"     => 15,
      "R15"     => 16,
      "CC"      => 17,
      "F0"      => 18,
      "F1"      => 19,
      "F2"      => 20,
      "F3"      => 21,
      "F4"      => 22,
      "F5"      => 23,
      "F6"      => 24,
      "F7"      => 25,
      "F8"      => 26,
      "F9"      => 27,
      "F10"     => 28,
      "F11"     => 29,
      "F12"     => 30,
      "F13"     => 31,
      "F14"     => 32,
      "F15"     => 33,
      "R0L"     => 34,
      "MAX"     => 35
    }

    ID_LOOKUP = REG_LOOKUP.invert
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
