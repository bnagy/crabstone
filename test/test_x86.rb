#!/usr/bin/env ruby

# Ruby bindings for Crabstone.
# By Tan Sheng Di & Nguyen Anh Quynh, 2013

require 'crabstone'

X86_CODE16 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00\x05\x23\x01\x00\x00\x36\x8b\x84\x91\x23\x01\x00\x00\x41\xa1\x13\x48\x6d\x3a"
X86_CODE32 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00\x05\x23\x01\x00\x00\x36\x8b\x84\x91\x23\x01\x00\x00\x41\xa1\x13\x48\x6d\x3a"
X86_CODE64 = "\x55\x48\x8b\x05\xb8\x13\x00\x00"

include Crabstone
include Crabstone::X86

@platforms = [
  Hash[
    'arch' => ARCH_X86,
    'mode' => MODE_16,
    'code' => X86_CODE16,
    'comment' => "X86 16bit (Intel syntax)"
  ],
  Hash[
    'arch' => ARCH_X86,
    'mode' => MODE_32 + MODE_SYNTAX_ATT,
    'code' => X86_CODE32,
    'comment' => "X86 32bit (ATT syntax)"
  ],
  Hash[
    'arch' => ARCH_X86,
    'mode' => MODE_32,
    'code' => X86_CODE32,
    'comment' => "X86 32 (Intel syntax)"
  ],
  Hash[
    'arch' => ARCH_X86,
    'mode' => MODE_64,
    'code' => X86_CODE64,
    'comment' => "X86 64 (Intel syntax)"
  ]
]

def non_neg(value)
  value = value & 0xffffffff
  return value.to_s(16)
end

def readable(code)
  size = code.size
  code2 = code.clone
  0.step((size*5)-1,5) do |i|
    code2[i] = "0x%02x " % code2.getbyte(i)
  end
  return code2
end

def print_detail(cs, i)
  if i.segment != REG_INVALID then
    puts "\tSegment override: #{i.segment}"
  end

  if (count=i.op_count(OP_IMM)).nonzero?
    puts "\timm_count: #{count}"
    i.operands.select {|op| op[:type] == OP_IMM}.each_with_index {|op,j|
      puts "\t\timms[#{j}] = 0x#{op[:value][:imm].to_s(16)}"
    }
  end

  if i.op_count > 0 then
    puts "\top_count: #{i.op_count}"
    i.operands.each_with_index do |op,c|
      if op[:type] == OP_REG
        puts "\t\toperands[#{c}].type: REG = #{i.reg_name(op[:value][:reg])}"
      elsif op[:type] == OP_IMM
        puts "\t\toperands[#{c}].type: IMM = 0x#{non_neg(op[:value][:imm])}"
      elsif op[:type] == OP_FP
        puts "\t\toperands[#{c}].type: FP = 0x#{non_neg(op[:value][:fp])}"
      elsif op[:type] == OP_MEM
        puts "\t\toperands[#{c}].type: MEM"
        if op[:value][:mem][:base].nonzero?
          puts "\t\t\toperands[#{c}].mem.base: REG = %s" % i.reg_name(op[:value][:mem][:base])
        end
        if op[:value][:mem][:index].nonzero?
          puts "\t\t\toperands[#{c}].mem.index: REG = %s" % i.reg_name(op[:value][:mem][:index])
        end
        if op[:value][:mem][:scale] != 1
          puts "\t\t\toperands[#{c}].mem.scale = %u" % op[:value][:mem][:scale]
        end
        if op[:value][:mem][:disp].nonzero?
          puts "\t\t\toperands[#{c}].mem.disp = %s" % non_neg(op[:value][:mem][:disp])
        end
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
  res = cs.disasm(p['code'], 0x1000)
  res.each do |i|
    puts "0x#{i.address.to_s(16)}: #{i.mnemonic}\t#{i.operand_string}"
    print_detail(cs, i)
  end
end
