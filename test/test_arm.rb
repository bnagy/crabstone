#! /usr/bin/env ruby

# Ruby bindings for Crabstone.
# By Tan Sheng Di & Nguyen Anh Quynh, 2013

require 'crabstone'

CODE = "\xED\xFF\xFF\xEB\x04\xe0\x2d\xe5\x00\x00\x00\x00\xe0\x83\x22\xe5\xf1\x02\x03\x0e\x00\x00\xa0\xe3\x02\x30\xc1\xe7\x00\x00\x53\xe3"
CODE2 = "\x10\xf1\x10\xe7\x11\xf2\x31\xe7\xdc\xa1\x2e\xf3\xe8\x4e\x62\xf3"
THUMB_CODE = "\x70\x47\xeb\x46\x83\xb0\xc9\x68"
THUMB_CODE2 = "\x4f\xf0\x00\x01\xbd\xe8\x00\x88\xd1\xe8\x00\xf0"

include Crabstone
include Crabstone::ARM

@platforms = [
  Hash[
    'arch' => ARCH_ARM,
    'mode' => MODE_ARM,
    'code' => CODE,
    'comment' => "ARM"
  ],
  Hash[
    'arch' => ARCH_ARM,
    'mode' => MODE_THUMB,
    'code' => THUMB_CODE2,
    'comment' => "THUMB-2"
  ],
  Hash[
    'arch' => ARCH_ARM,
    'mode' => MODE_ARM,
    'code' => CODE2,
    'comment' => "ARM: Cortex-A15 + NEON"
  ],
  Hash[
    'arch' => ARCH_ARM,
    'mode' => MODE_THUMB,
    'code' => THUMB_CODE,
    'comment' => "THUMB"
  ],
]

def non_neg(value)
  value = value & 0xffffffff
  return value.to_s(16)
end

def print_detail(cs, i)
  if not [CC_AL, CC_INVALID].include? i.cc then
    puts "\tCode condition: #{i.cc}"
  end

  if i.update_flags then
    puts "\tUpdate-flags: True"
  end

  if i.writeback then
    puts "\tWriteback: True"
  end

  if i.op_count > 0 then
    puts "\top_count: #{i.op_count}"
    c = 0
    i.operands.each do |op|
      c += 1
      if op[:type] == OP_REG
        puts "\t\toperands[#{c}].type: REG = #{i.reg_name(op[:value][:reg])}"
      elsif op[:type] == OP_IMM
        puts "\t\toperands[#{c}].type: IMM = 0x#{non_neg(op[:value][:imm])}"
      elsif op[:type] == OP_FP
        puts "\t\toperands[#{c}].type: FP = 0x#{non_neg(op[:value][:fp])}"
      elsif op[:type] == OP_CIMM
        puts "\t\toperands[#{c}].type: C-IMM = 0x#{non_neg(op[:value][:imm])}"
      elsif op[:type] == OP_PIMM
        puts "\t\toperands[#{c}].type: P-IMM = 0x#{non_neg(op[:value][:imm])}"
      elsif op[:type] == OP_MEM then
        puts "\t\toperands[#{c}].type: MEM"
        if op[:value][:mem][:base] != 0 then
          puts "\t\t\toperands[#{c}].mem.base: REG = %s" % i.reg_name(op[:value][:mem][:base])
        end
        if op[:value][:mem][:index] != 0 then
          puts "\t\t\toperands[#{c}].mem.index: REG = %s" % i.reg_name(op[:value][:mem][:index])
        end
        if op[:value][:mem][:scale] != 1 then
          puts "\t\t\toperands[#{c}].mem.scale = %u" % op[:value][:mem][:scale]
        end
        if op[:value][:mem][:disp] != 0 then
          puts "\t\t\toperands[#{c}].mem.disp = %s" % non_neg(op[:value][:mem][:disp])
        end
      end
      if op[:shift][:type] != SFT_INVALID &&
          op[:shift][:value] then
        puts "\t\t\tShift: type = #{op[:shift][:type]}, value = #{op[:shift][:value]}"
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
