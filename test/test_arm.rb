#! /usr/bin/env ruby

# Library by Ngyuen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC

require 'crabstone'
require 'stringio'

module TestARM

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

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.print_detail(cs, i, sio)
    if not [CC_AL, CC_INVALID].include? i.cc then
      sio.puts "\tCode condition: #{i.cc}"
    end

    if i.update_flags then
      sio.puts "\tUpdate-flags: True"
    end

    if i.writeback then
      sio.puts "\tWriteback: True"
    end

    if i.op_count > 0 then
      sio.puts "\top_count: #{i.op_count}"
      c = 0
      i.operands.each do |op|
        c += 1
        if op[:type] == OP_REG
          sio.puts "\t\toperands[#{c}].type: REG = #{i.reg_name(op[:value][:reg])}"
        elsif op[:type] == OP_IMM
          sio.puts "\t\toperands[#{c}].type: IMM = 0x#{self.uint32(op[:value][:imm])}"
        elsif op[:type] == OP_FP
          sio.puts "\t\toperands[#{c}].type: FP = 0x#{self.uint32(op[:value][:fp])}"
        elsif op[:type] == OP_CIMM
          sio.puts "\t\toperands[#{c}].type: C-IMM = 0x#{self.uint32(op[:value][:imm])}"
        elsif op[:type] == OP_PIMM
          sio.puts "\t\toperands[#{c}].type: P-IMM = 0x#{self.uint32(op[:value][:imm])}"
        elsif op[:type] == OP_MEM then
          sio.puts "\t\toperands[#{c}].type: MEM"
          if op[:value][:mem][:base] != 0 then
            sio.puts "\t\t\toperands[#{c}].mem.base: REG = %s" % i.reg_name(op[:value][:mem][:base])
          end
          if op[:value][:mem][:index] != 0 then
            sio.puts "\t\t\toperands[#{c}].mem.index: REG = %s" % i.reg_name(op[:value][:mem][:index])
          end
          if op[:value][:mem][:scale] != 1 then
            sio.puts "\t\t\toperands[#{c}].mem.scale = %u" % op[:value][:mem][:scale]
          end
          if op[:value][:mem][:disp] != 0 then
            sio.puts "\t\t\toperands[#{c}].mem.disp = %s" % self.uint32(op[:value][:mem][:disp])
          end
        end
        if op[:shift][:type] != SFT_INVALID &&
            op[:shift][:value] then
          sio.puts "\t\t\tShift: type = #{op[:shift][:type]}, value = #{op[:shift][:value]}"
        end
      end
    end
    sio.puts
  end

  ours = StringIO.new

  #Test through all modes and architectures
  @platforms.each do |p|
    ours.puts "**********"
    ours.puts "Platforms: #{p['comment']}"
    cs = Disassembler.new(p['arch'], p['mode'])
    cs.disasm(p['code'], 0x1000).each do |i|
      ours.puts "0x#{i.address.to_s(16)}: #{i.mnemonic}\t#{i.operand_string}"
      self.print_detail(cs, i, ours)
    end
  end

  ours.rewind
  theirs = File.binread(__FILE__ + ".SPEC")
  if ours.read == theirs
    puts "#{__FILE__}: PASS"
  else
    puts "#{__FILE__}: FAIL"
  end
end
