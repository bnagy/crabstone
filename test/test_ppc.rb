#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestPPC

  PPC_CODE = "\x80\x20\x00\x00\x80\x3f\x00\x00\x10\x43\x23\x0e\xd0\x44\x00\x80\x4c\x43\x22\x02\x2d\x03\x00\x80\x7c\x43\x20\x14\x7c\x43\x20\x93\x4f\x20\x00\x21\x4c\xc8\x00\x21"
  include Crabstone
  include Crabstone::PPC

  @platforms = [
    Hash[
      'arch' => ARCH_PPC,
      'mode' => MODE_BIG_ENDIAN,
      'code' => PPC_CODE,
      'comment' => "PPC-64"
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
    if insn.bc.nonzero?
      sio.puts("\tBranch code: %u" % insn.bc)
    end
    if insn.bh.nonzero?
      sio.puts("\tBranch hint: %u" % insn.bh)
    end
    if insn.update_cr0
      sio.puts("\tUpdate-CR0: True")
    end
    sio.puts
  end

  ours = StringIO.new

  begin
    cs    = Disassembler.new(0,0)
    print "PPC Test: Capstone v #{cs.version.join('.')} - "
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
    cs.disasm(p['code'], 0x1000) do |i|
      ours.puts "0x#{i.address.to_s(16)}:\t#{i.mnemonic}\t#{i.op_str}"
      self.print_detail(cs, i, ours)
      cache = i
    end
    cs.close

    ours.printf("0x%x:\n", cache.address + cache.size)
    ours.puts
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
