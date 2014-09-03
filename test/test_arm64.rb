#! /usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestARM64

  include Crabstone
  include Crabstone::ARM64

  ARM64_CODE = "\x09\x00\x38\xd5\xbf\x40\x00\xd5\x0c\x05\x13\xd5\x20\x50\x02\x0e\x20\xe4\x3d\x0f\x00\x18\xa0\x5f\xa2\x00\xae\x9e\x9f\x37\x03\xd5\xbf\x33\x03\xd5\xdf\x3f\x03\xd5\x21\x7c\x02\x9b\x21\x7c\x00\x53\x00\x40\x21\x4b\xe1\x0b\x40\xb9\x20\x04\x81\xda\x20\x08\x02\x8b\x10\x5b\xe8\x3c"

  @platforms = [
    Hash[
      'arch' => ARCH_ARM64,
      'mode' => MODE_ARM,
      'code' => ARM64_CODE,
      'comment' => "ARM64"
    ],
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.uint64 i
    Integer(i) & ((1<<64)-1)
  end

  def self.print_detail(cs, i, sio)

    # Sanity checks for register equivalency (string, const or numeric literal)
    if i.reads_reg?( 'sp' ) || i.reads_reg?( 12 ) || i.reads_reg?( REG_SP )
      unless i.reads_reg?( 'sp' ) && i.reads_reg?( 12 ) && i.reads_reg?( REG_SP )
        fail "Error in reg read decomposition"
      end
    end
    if i.writes_reg?( 'lr' ) || i.writes_reg?( 10 ) || i.writes_reg?( REG_LR )
      unless i.writes_reg?( 'lr' ) && i.writes_reg?( 10 ) && i.writes_reg?( REG_LR )
        fail "Error in reg write decomposition"
      end
    end

    if i.op_count > 0 then
      sio.puts "\top_count: #{i.op_count}"
      i.operands.each.with_index do |op,idx|

        case op[:type]
        when OP_REG
          sio.puts "\t\toperands[#{idx}].type: REG = #{cs.reg_name(op[:value][:reg])}"
        when OP_IMM
          sio.puts "\t\toperands[#{idx}].type: IMM = 0x#{self.uint64(op.value).to_s(16)}"
        when OP_FP
          sio.puts "\t\toperands[#{idx}].type: FP = 0x#{self.uint32(op[:value][:fp])}"
        when OP_CIMM
          sio.puts "\t\toperands[#{idx}].type: C-IMM = #{self.uint32(op[:value][:imm])}"
        when OP_MEM
          sio.puts "\t\toperands[#{idx}].type: MEM"
          if op[:value][:mem][:base].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % cs.reg_name(op.value[:base])
          end
          if op[:value][:mem][:index].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % cs.reg_name(op.value[:index])
          end
          if op[:value][:mem][:disp].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x#{self.uint32(op.value[:disp]).to_s(16)}"
          end
        when OP_REG_MRS
          sio.puts "\t\toperands[#{idx}].type: REG_MRS = 0x#{op.value}\n"
        when OP_REG_MSR
          sio.puts "\t\toperands[#{idx}].type: REG_MSR = 0x#{op[:value][:reg]}\n"
        when OP_PSTATE
          sio.puts "\t\toperands[#{idx}].type: PSTATE = 0x#{uint32(op.value)}\n"
        when OP_SYS
          sio.puts "\t\toperands[#{idx}].type: SYS = 0x#{uint32(op.value)}\n"
        when OP_PREFETCH
          sio.puts "\t\toperands[#{idx}].type: PREFETCH = 0x#{uint32(op.value)}\n"
        when OP_BARRIER
          sio.puts "\t\toperands[#{idx}].type: BARRIER = 0x#{uint32(op.value)}\n"
        else
          # unknown type - test will fail anyway
        end

        sio.puts "\t\t\tShift: type = #{op.shift_type}, value = #{op.shift_value}\n" if op.shift?
        sio.puts "\t\t\tVector Arrangement Specifier: 0x#{uint32(op[:vas])}\n" if op[:vas].nonzero?
        sio.puts "\t\t\tVector Element Size Specifier: #{op[:vess]}\n" if op[:vess].nonzero?
        sio.puts"\t\t\tVector Index: #{op[:vector_index]}\n" if op[:vector_index] != -1
        sio.puts "\t\t\tExt: #{op[:ext]}\n" if op[:ext].nonzero?
      end
    end

    sio.puts "\tUpdate-flags: True" if i.update_flags
    sio.puts "\tWrite-back: True" if i.writeback
    if not [CC_AL, CC_INVALID].include? i.cc
      sio.puts "\tCode-condition: #{i.cc}"
    end

    sio.puts

  end

  ours = StringIO.new

  begin
    cs = Disassembler.new(0,0)
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
    cs = Disassembler.new(p['arch'], p['mode'])

    if p['syntax']
      cs.syntax = p['syntax']
    end

    cs.decomposer = true
    cache = nil
    cs.disasm(p['code'], 0x2c).each {|insn|
      ours.puts "0x#{insn.address.to_s(16)}:\t#{insn.mnemonic}\t#{insn.op_str}"
      self.print_detail(cs, insn, ours)
      cache = insn.address + insn.size
    }
    ours.printf("0x%x:\n", cache)
    ours.puts

    cs.close
  end

  ours.rewind
  theirs = File.binread(__FILE__ + ".SPEC")
  if ours.read == theirs
    puts "#{__FILE__}: PASS"
  else
    ours.rewind
    puts ours.read
    puts "#{__FILE__}: FAIL"
  end
end
