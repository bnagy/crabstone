#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestARM64
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

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.print_detail cs, insn, sio


    if insn.update_flags
      sio.puts "\tUpdate-flags: True"
    end

    if insn.writeback
      sio.puts "\tWriteback: True"
    end

    if insn.reads_reg?( 'x0' ) || insn.reads_reg?( 197 ) || insn.reads_reg?( REG_X0 )
      print '[x0:r] '
      unless insn.reads_reg?( 'x0' ) && insn.reads_reg?( 197 ) && insn.reads_reg?( REG_X0 )
        fail "Error in reg read decomposition"
      end
    end

    if insn.writes_reg?( 'x0' ) || insn.writes_reg?( 197 ) || insn.writes_reg?( REG_X0 )
      print '[x0:w] '
      unless insn.writes_reg?( 'x0' ) && insn.writes_reg?( 197 ) && insn.writes_reg?( REG_X0 )
        fail "Error in reg write decomposition"
      end
    end

    if insn.op_count > 0
      sio.puts "\top_count: #{insn.op_count}"
      insn.operands.each_with_index do |op,idx|
        case op[:type]
        when OP_REG
          sio.puts "\t\toperands[#{idx}].type: REG = #{cs.reg_name(op.value)}"
        when OP_IMM
          sio.puts "\t\toperands[#{idx}].type: IMM = 0x#{self.uint32(op.value)}"
        when OP_FP
          sio.puts "\t\toperands[#{idx}].type: FP = 0x#{self.uint32(op.value)}"
        when OP_CIMM
          sio.puts "\t\toperands[#{idx}].type: C-IMM = 0x#{self.uint32(op.value)}"
        when OP_MEM
          sio.puts "\t\toperands[#{idx}].type: MEM"
          if op.value[:base].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % cs.reg_name(op.value[:base])
          end
          if op.value[:index].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % cs.reg_name(op.value[:index])
          end
          if op.value[:disp].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x%x" % (self.uint32(op.value[:disp]))
          end
        end
        if op.shift?
          sio.puts "\t\t\tShift: type = #{op.shift_type}, value = #{op.shift_value}"
        end
        if op.ext?
          sio.puts "\t\t\tExt: #{op[:ext]}"
        end
      end
    end
    if not [CC_AL, CC_INVALID].include? insn.cc
      sio.printf("\tCode condition: %u\n", insn.cc)
    end
    sio.puts
  end

  ours = StringIO.new

  begin
    cs    = Disassembler.new(0,0)
    print "ARM64 Test: Capstone v #{cs.version.join('.')} - "
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
    cs.disasm(p['code'], 0x2c).each {|i|
      ours.puts "0x#{i.address.to_s(16)}:\t#{i.mnemonic}\t#{i.op_str}"
      self.print_detail(cs, i, ours)
      cache = i
    }
    cs.close

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
