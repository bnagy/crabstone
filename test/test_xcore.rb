#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestXCore

  XCORE_CODE = "\xfe\x0f\xfe\x17\x13\x17\xc6\xfe\xec\x17\x97\xf8\xec\x4f\x1f\xfd\xec\x37\x07\xf2\x45\x5b\xf9\xfa\x02\x06\x1b\x10\x09\xfd\xec\xa7"

  include Crabstone
  include Crabstone::XCore

  @platforms = [
    Hash[
      'arch' => ARCH_XCORE,
      'mode' => MODE_BIG_ENDIAN,
      'code' => XCORE_CODE,
      'comment' => "XCore"
    ],
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.print_detail cs, insn, sio
    if insn.op_count > 0
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
          if op.value[:index].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % cs.reg_name(op.value[:index])
          end
          if op.value[:disp].nonzero?
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x%x" % (self.uint32(op.value[:disp]))
          end
          if op.value[:direct] != 1
            sio.puts "\t\t\toperands[#{idx}].mem.direct: -1"
          end
        end
      end
    end
    sio.puts
  end

  ours = StringIO.new

  begin
    cs    = Disassembler.new(0,0)
    print "XCore Test: Capstone v #{cs.version.join('.')} - "
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
    ours.rewind
    puts ours.read
    puts "#{__FILE__}: FAIL"
  end
end
