#! /usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestARM

  include Crabstone
  include Crabstone::ARM

  ARM_CODE     = "\xED\xFF\xFF\xEB\x04\xe0\x2d\xe5\x00\x00\x00\x00\xe0\x83\x22\xe5\xf1\x02\x03\x0e\x00\x00\xa0\xe3\x02\x30\xc1\xe7\x00\x00\x53\xe3\x00\x02\x01\xf1\x05\x40\xd0\xe8\xf4\x80\x00\x00"
  ARM_CODE2    = "\xd1\xe8\x00\xf0\xf0\x24\x04\x07\x1f\x3c\xf2\xc0\x00\x00\x4f\xf0\x00\x01\x46\x6c"
  THUMB_CODE   = "\x70\x47\xeb\x46\x83\xb0\xc9\x68\x1f\xb1\x30\xbf\xaf\xf3\x20\x84"
  THUMB_CODE2  = "\x4f\xf0\x00\x01\xbd\xe8\x00\x88\xd1\xe8\x00\xf0\x18\xbf\xad\xbf\xf3\xff\x0b\x0c\x86\xf3\x00\x89\x80\xf3\x00\x8c\x4f\xfa\x99\xf6\xd0\xff\xa2\x01"
  THUMB_MCLASS = "\xef\xf3\x02\x80"
  ARMV8        = "\xe0\x3b\xb2\xee\x42\x00\x01\xe1\x51\xf0\x7f\xf5"

  @platforms = [
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_ARM,
      'code' => ARM_CODE,
      'comment' => "ARM"
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_THUMB,
      'code' => THUMB_CODE,
      'comment' => "Thumb"
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_THUMB,
      'code' => ARM_CODE2,
      'comment' => "Thumb-mixed"
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_THUMB,
      'code' => THUMB_CODE2,
      'comment' => "Thumb-2 & register named with numbers",
      'syntax' => :no_regname
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_THUMB + MODE_MCLASS,
      'code' => THUMB_MCLASS,
      'comment' => "Thumb-MClass",
      'syntax' => :no_regname
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_ARM + MODE_V8,
      'code' => ARMV8,
      'comment' => "Arm-V8",
      'syntax' => :no_regname
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
        when OP_PIMM
          sio.puts "\t\toperands[#{idx}].type: P-IMM = #{self.uint32(op[:value][:imm])}"
        when OP_SETEND
          if op.value == SETEND_BE
            sio.puts "\t\toperands[#{idx}].type: SETEND = be"
          else
            sio.puts "\t\toperands[#{idx}].type: SETEND = le"
          end
        when OP_SYSREG
          sio.puts "\t\toperands[#{idx}].type: SYSREG = #{op.value}"
        when OP_MEM
          sio.puts "\t\toperands[#{idx}].type: MEM"
          if op[:value][:mem][:base] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % cs.reg_name(op.value[:base])
          end
          if op[:value][:mem][:index] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % cs.reg_name(op.value[:index])
          end
          if op[:value][:mem][:scale] != 1 then
            sio.puts "\t\t\toperands[#{idx}].mem.scale = %u" % op[:value][:mem][:scale]
          end
          if op[:value][:mem][:disp] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x#{self.uint32(op.value[:disp]).to_s(16)}"
          end
        else
          # unknown type - test will fail anyway
        end

        if op[:shift][:type].nonzero? && op[:shift][:value]
          sio.puts "\t\t\tShift: #{op[:shift][:type]} = #{op[:shift][:value]}"
        end

        if op[:vector_index] != -1
          sio.puts "\t\toperands[#{idx}].vector_index = #{op[:vector_index]}"
        end

        if op[:subtracted]
          sio.puts "\t\tSubtracted: True\n"
        end

      end
    end

    if not [CC_AL, CC_INVALID].include? i.cc
      sio.puts "\tCode condition: #{i.cc}"
    end
    sio.puts "\tUpdate-flags: True" if i.update_flags
    sio.puts "\tWrite-back: True" if i.writeback
    sio.puts "\tCPSI-mode: #{i.cps_mode}" if i.cps_mode.nonzero?
    sio.puts "\tCPSI-flag: #{i.cps_flag}" if i.cps_flag.nonzero?
    sio.puts "\tVector-data: #{i.vector_data}" if i.vector_data.nonzero?
    sio.puts "\tVector-size: #{i.vector_size}" if i.vector_size.nonzero?
    sio.puts "\tUser-mode: True" if i.usermode
    sio.puts "\tMemory-barrier: #{i.mem_barrier}" if i.mem_barrier.nonzero?

    sio.puts

  end

  ours = StringIO.new

  begin
    cs = Disassembler.new(0,0)
    print "ARM Test: Capstone v #{cs.version.join('.')} - "
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
    cs.disasm(p['code'], 0x1000).each {|insn|
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
