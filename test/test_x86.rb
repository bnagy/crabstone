#!/usr/bin/env ruby

# Library by Ngyuen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# © 2013 COSEINC

# This is UGLY, but it's ported C test code, sorry. :(

require 'crabstone'
require 'stringio'

module TestX86
  X86_CODE16 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00\x05\x23\x01\x00\x00\x36\x8b\x84\x91\x23\x01\x00\x00\x41\x8d\x84\x39\x89\x67\x00\x00\x8d\x87\x89\x67\x00\x00\xb4\xc6"
  X86_CODE32 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00\x05\x23\x01\x00\x00\x36\x8b\x84\x91\x23\x01\x00\x00\x41\x8d\x84\x39\x89\x67\x00\x00\x8d\x87\x89\x67\x00\x00\xb4\xc6"
  X86_CODE64 = "\x55\x48\x8b\x05\xb8\x13\x00\x00"

  include Crabstone
  include Crabstone::X86

  @platforms = [

    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32 + MODE_SYNTAX_ATT,
      'code' => X86_CODE32,
      'comment' => "X86 32 (AT&T syntax)"
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32,
      'code' => X86_CODE32,
      'comment' => "X86 32 (Intel syntax)"
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_16,
      'code' => X86_CODE16,
      'comment' => "X86 16bit (Intel syntax)"
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_64,
      'code' => X86_CODE64,
      'comment' => "X86 64 (Intel syntax)"
    ]
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.uint64 i
    Integer(i) & 0xffffffffffffffff
  end

  def self.print_detail(cs, i, mode, stringio)

    stringio.puts("\tPrefix:#{i.prefix.to_a.map {|b| "0x%.2x" % b}.join(' ')} ")

    if i.segment != REG_INVALID then
      stringio.puts "\tSegment override: #{i.reg_name(i.segment)}"
    end
    stringio.puts("\tOpcode:#{i.opcode.to_a.map {|b| "0x%.2x" % b}.join(' ')} ")
    stringio.printf("\top_size: %u, addr_size: %u, disp_size: %u, imm_size: %u\n", i.op_size, i.addr_size, i.disp_size, i.imm_size);
    stringio.printf("\tmodrm: 0x%x\n", i.modrm)
    stringio.printf("\tdisp: 0x%x\n", (self.uint32(i.disp)))

    #   // SIB is not available in 16-bit mode
    unless mode == MODE_16
      stringio.printf("\tsib: 0x%x\n", i.sib)
      unless i.sib_index == REG_INVALID
        stringio.printf(
          "\tsib_index: %s, sib_scale: %u, sib_base: %s\n",
          i.reg_name(i.sib_index),
          i.sib_scale,
          i.reg_name(i.sib_base)
        )
      end
    end

    if (count=i.op_count(OP_IMM)).nonzero?
      stringio.puts "\timm_count: #{count}"
      i.operands.select(&:imm?).each_with_index {|op,j|
        stringio.puts "\t\timms[#{j+1}]: 0x#{op.value.to_s(16)}"
      }
    end

    if i.op_count > 0 then
      stringio.puts "\top_count: #{i.op_count}"
      i.operands.each_with_index do |op,c|
        if op.reg?
          stringio.puts "\t\toperands[#{c}].type: REG = #{i.reg_name(op.value)}"
        elsif op.imm?
          stringio.puts "\t\toperands[#{c}].type: IMM = 0x#{op.value.to_s(16)}"
        elsif op.fp?
          stringio.puts "\t\toperands[#{c}].type: FP = 0x#{(self.uint32(op.value))}"
        elsif op.mem?
          stringio.puts "\t\toperands[#{c}].type: MEM"
          if op.value[:base].nonzero?
            stringio.puts "\t\t\toperands[#{c}].mem.base: REG = %s" % i.reg_name(op.value[:base])
          end
          if op.value[:index].nonzero?
            stringio.puts "\t\t\toperands[#{c}].mem.index: REG = %s" % i.reg_name(op.value[:index])
          end
          if op.value[:scale] != 1
            stringio.puts "\t\t\toperands[#{c}].mem.scale: %u" % op.value[:scale]
          end
          if op.value[:disp].nonzero?
            stringio.puts "\t\t\toperands[#{c}].mem.disp: 0x%x" % (self.uint64(op.value[:disp]))
          end
        end
      end
    end
    stringio.puts
  end

  ours = StringIO.new

  #Test through all modes and architectures
  @platforms.each do |p|
    ours.puts "****************"
    ours.puts "Platform: #{p['comment']}"
    ours.puts "Code:#{p['code'].bytes.map {|b| "0x%.2x" % b}.join(' ')} "
    ours.puts "Disasm:"

    cs    = Disassembler.new(p['arch'], p['mode'])
    res   = cs.disasm(p['code'], 0x1000)
    cache = nil
    res.each do |i|
      ours.puts "0x#{i.address.to_s(16)}:\t#{i.mnemonic}\t#{i.operand_string}"
      self.print_detail(cs, i, cs.mode, ours)
      cache = i
    end

    ours.printf("0x%x:\n", cache.address + cache.size)
    ours.puts
  end

  ours.rewind
  theirs = File.binread(__FILE__ + ".SPEC")
  if ours.read == theirs
    puts "#{__FILE__}: PASS"
  else
    puts "#{__FILE__}: FAIL"
  end
end
