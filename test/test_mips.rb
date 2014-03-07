#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestMIPS
  MIPS_CODE = "\x0C\x10\x00\x97\x00\x00\x00\x00\x24\x02\x00\x0c\x8f\xa2\x00\x00\x34\x21\x34\x56"
  MIPS_CODE2 = "\x56\x34\x21\x34\xc2\x17\x01\x00"
  include Crabstone
  include Crabstone::MIPS

  @platforms = [
    Hash[
      'arch' => ARCH_MIPS,
      'mode' => MODE_32 + MODE_BIG_ENDIAN,
      'code' => MIPS_CODE,
      'comment' => "MIPS-32 (Big-endian)"
    ],
    Hash[
      'arch' => ARCH_MIPS,
      'mode' => MODE_64+ MODE_LITTLE_ENDIAN,
      'code' => MIPS_CODE2,
      'comment' => "MIPS-64-EL (Little-endian)"
    ]
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.print_detail cs, insn, sio
    if insn.op_count > 0
      if insn.writes_reg? :ra
        print "[w:ra] "
      end
      sio.puts "\top_count: #{insn.op_count}"
      insn.operands.each_with_index do |op,idx|
        case op[:type]
        when OP_REG
          sio.puts "\t\toperands[#{idx}].type: REG = #{cs.reg_name(op.value)}"
        when OP_IMM
          sio.puts "\t\toperands[#{idx}].type: IMM = 0x#{self.uint32(op.value).to_s(16)}"
        when OP_MEM
          sio.puts "\t\toperands[#{idx}].type: MEM"
          if op.value[:base].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % cs.reg_name(op.value[:base])
          end
          if op.value[:disp].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x%x" % (self.uint32(op.value[:disp]))
          end
        end
      end
    end
    sio.puts
  end

  ours = StringIO.new

  begin
    cs    = Disassembler.new(0,0)
    print "MIPS Test: Capstone v #{cs.version.join('.')} - "
  ensure
    cs.close
  end

  #Test through all modes and architectures
  @platforms.each do |p|
    ours.puts "****************"
    ours.puts "Platform: #{p['comment']}"
    ours.puts "Code:#{p['code'].bytes.map {|b| "0x%.2x" % b}.join(' ')} "
    ours.puts "Disasm:"

    cs    = Disassembler.new(p['arch'], p['mode'])
    cs.decomposer = true
    cache = nil

    cs.disasm(p['code'], 0x1000).each {|insn|
      ours.puts "0x#{insn.address.to_s(16)}:\t#{insn.mnemonic}\t#{insn.op_str}"
      self.print_detail(cs, insn, ours)
      cache = insn.address + insn.size
    }

    cs.close
    ours.printf("0x%x:\n", cache)
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
