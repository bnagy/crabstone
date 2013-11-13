#!/usr/bin/env ruby

# Ruby bindings for Crabstone.
# By Tan Sheng Di & Nguyen Anh Quynh, 2013

require 'crabstone'

CODE = "\x21\x7c\x02\x9b\x21\x7c\x00\x53\x00\x40\x21\x4b\xe1\x0b\x40\xb9\x20\x04\x81\xda\x20\x08\x02\x8b"

include Crabstone
include Crabstone::ARM64

@platforms = [
  Hash[
    'arch' => ARCH_ARM64,
    'mode' => 0,
    'code' => CODE,
    'comment' => "ARM-64"
  ]
]

def non_neg(value)
  value = value & 0xffffffff
  return value.to_s(16)
end

def print_detail(cs, i)
  if not [CC_AL, CC_INVALID].include? i.cc
    puts "\tCode condition: #{i.cc}"
  end

  if i.update_flags
    puts "\tUpdate-flags: True"
  end

  if i.writeback
    puts "\tWriteback: True"
  end

  if i.op_count > 0
    puts "\top_count: #{i.op_count}"
    i.operands.each_with_index do |op,idx|
      case op[:type]
      when OP_REG
        puts "\t\toperands[#{idx}].type: REG = #{i.reg_name(op[:value][:reg])}"
      when OP_IMM
        puts "\t\toperands[#{idx}].type: IMM = 0x#{non_neg(op[:value][:imm])}"
      when OP_FP
        puts "\t\toperands[#{idx}].type: FP = 0x#{non_neg(op[:value][:fp])}"
      when OP_CIMM
        puts "\t\toperands[#{idx}].type: C-IMM = 0x#{non_neg(op[:value][:imm])}"
      when OP_MEM
        puts "\t\toperands[#{idx}].type: MEM"
        if op[:value][:mem][:base].nonzero?
          puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % i.reg_name(op[:value][:mem][:base])
        end
        if op[:value][:mem][:index].nonzero?
          puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % i.reg_name(op[:value][:mem][:index])
        end
        if op[:value][:mem][:disp].nonzero?
          puts "\t\t\toperands[#{idx}].mem.disp = %s" % non_neg(op[:value][:mem][:disp])
        end
      end
      if op[:shift][:type] != SFT_INVALID && op[:shift][:value]
        puts "\t\t\tShift: type = #{op[:shift][:type]}, value = #{op[:shift][:value]}"
      end
      if op[:ext] != EXT_INVALID
        puts "\t\t\tExt: #{op[:ext]}"
      end
    end
  end
  puts
end

#Test through all modes and architectures
@platforms.each do |p|
  puts "**********"
  puts "Platforms: #{p['comment']}"
  cs = Disassembler.new(p['arch'], p['mode'])
  cs.disasm(p['code'], 0x1000).each do |i|
    puts "0x#{i.address.to_s(16)}: #{i.mnemonic}\t#{i.operand_string}"
    print_detail(cs, i)
  end
end
