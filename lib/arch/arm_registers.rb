module Crabstone
  module ARM
    REG_LOOKUP = {
          'INVALID' => 0,
          'APSR' => 1,
          'APSR_NZCV' => 2,
          'CPSR' => 3,
          'FPEXC' => 4,
          'FPINST' => 5,
          'FPSCR' => 6,
          'FPSCR_NZCV' => 7,
          'FPSID' => 8,
          'ITSTATE' => 9,
          'LR' => 10,
          'PC' => 11,
          'SP' => 12,
          'SPSR' => 13,
          'D0' => 14,
          'D1' => 15,
          'D2' => 16,
          'D3' => 17,
          'D4' => 18,
          'D5' => 19,
          'D6' => 20,
          'D7' => 21,
          'D8' => 22,
          'D9' => 23,
          'D10' => 24,
          'D11' => 25,
          'D12' => 26,
          'D13' => 27,
          'D14' => 28,
          'D15' => 29,
          'D16' => 30,
          'D17' => 31,
          'D18' => 32,
          'D19' => 33,
          'D20' => 34,
          'D21' => 35,
          'D22' => 36,
          'D23' => 37,
          'D24' => 38,
          'D25' => 39,
          'D26' => 40,
          'D27' => 41,
          'D28' => 42,
          'D29' => 43,
          'D30' => 44,
          'D31' => 45,
          'FPINST2' => 46,
          'MVFR0' => 47,
          'MVFR1' => 48,
          'MVFR2' => 49,
          'Q0' => 50,
          'Q1' => 51,
          'Q2' => 52,
          'Q3' => 53,
          'Q4' => 54,
          'Q5' => 55,
          'Q6' => 56,
          'Q7' => 57,
          'Q8' => 58,
          'Q9' => 59,
          'Q10' => 60,
          'Q11' => 61,
          'Q12' => 62,
          'Q13' => 63,
          'Q14' => 64,
          'Q15' => 65,
          'R0' => 66,
          'R1' => 67,
          'R2' => 68,
          'R3' => 69,
          'R4' => 70,
          'R5' => 71,
          'R6' => 72,
          'R7' => 73,
          'R8' => 74,
          'R9' => 75,
          'R10' => 76,
          'R11' => 77,
          'R12' => 78,
          'S0' => 79,
          'S1' => 80,
          'S2' => 81,
          'S3' => 82,
          'S4' => 83,
          'S5' => 84,
          'S6' => 85,
          'S7' => 86,
          'S8' => 87,
          'S9' => 88,
          'S10' => 89,
          'S11' => 90,
          'S12' => 91,
          'S13' => 92,
          'S14' => 93,
          'S15' => 94,
          'S16' => 95,
          'S17' => 96,
          'S18' => 97,
          'S19' => 98,
          'S20' => 99,
          'S21' => 100,
          'S22' => 101,
          'S23' => 102,
          'S24' => 103,
          'S25' => 104,
          'S26' => 105,
          'S27' => 106,
          'S28' => 107,
          'S29' => 108,
          'S30' => 109,
          'S31' => 110
    }

    # alias registers
    REG_LOOKUP['R13'] = REG_LOOKUP['SP']
    REG_LOOKUP['R14'] = REG_LOOKUP['LR']
    REG_LOOKUP['R15'] = REG_LOOKUP['PC']
    REG_LOOKUP['SB' ] = REG_LOOKUP['R9']
    REG_LOOKUP['SL' ] = REG_LOOKUP['R10']
    REG_LOOKUP['FP' ] = REG_LOOKUP['R11']
    REG_LOOKUP['IP' ] = REG_LOOKUP['R12']
    
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
