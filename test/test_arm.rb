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

  ARM_CODE = "\xED\xFF\xFF\xEB\x04\xe0\x2d\xe5\x00\x00\x00\x00\xe0\x83\x22\xe5\xf1\x02\x03\x0e\x00\x00\xa0\xe3\x02\x30\xc1\xe7\x00\x00\x53\xe3"
  ARM_CODE2 = "\xd1\xe8\x00\xf0\xf0\x24\x04\x07\x1f\x3c\xf2\xc0\x00\x00\x4f\xf0\x00\x01\x46\x6c"
  THUMB_CODE = "\x70\x47\xeb\x46\x83\xb0\xc9\x68\x1f\xb1"
  THUMB_CODE2 = "\x4f\xf0\x00\x01\xbd\xe8\x00\x88\xd1\xe8\x00\xf0"

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
      'comment' => "Thumb-2"
    ],
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.uint64 i
    Integer(i) & ((1<<64)-1)
  end

  def self.print_detail(cs, i, sio)


    if i.reads_reg?( 'sp' ) || i.reads_reg?( 12 ) || i.reads_reg?( REG_SP )
      print '[sp:r] '
      unless i.reads_reg?( 'sp' ) && i.reads_reg?( 12 ) && i.reads_reg?( REG_SP )
        fail "Error in reg read decomposition"
      end
    end

    if i.writes_reg?( 'lr' ) || i.writes_reg?( 10 ) || i.writes_reg?( REG_LR )
      print '[lr:w] '
      unless i.writes_reg?( 'lr' ) && i.writes_reg?( 10 ) && i.writes_reg?( REG_LR )
        fail "Error in reg write decomposition"
      end
    end

    if i.op_count > 0 then
      sio.puts "\top_count: #{i.op_count}"
      i.operands.each.with_index do |op,idx|
        if op[:type] == OP_REG
          sio.puts "\t\toperands[#{idx}].type: REG = #{cs.reg_name(op[:value][:reg])}"
        elsif op[:type] == OP_IMM
          sio.puts "\t\toperands[#{idx}].type: IMM = 0x#{self.uint64(op.value).to_s(16)}"
        elsif op[:type] == OP_FP
          sio.puts "\t\toperands[#{idx}].type: FP = 0x#{self.uint32(op[:value][:fp])}"
        elsif op[:type] == OP_CIMM
          sio.puts "\t\toperands[#{idx}].type: C-IMM = #{self.uint32(op[:value][:imm])}"
        elsif op[:type] == OP_PIMM
          sio.puts "\t\toperands[#{idx}].type: P-IMM = #{self.uint32(op[:value][:imm])}"
        elsif op[:type] == OP_MEM then
          sio.puts "\t\toperands[#{idx}].type: MEM"
          if op[:value][:mem][:base] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.base: REG = %s" % cs.reg_name(op[:value][:mem][:base])
          end
          if op[:value][:mem][:index] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.index: REG = %s" % cs.reg_name(op[:value][:mem][:index])
          end
          if op[:value][:mem][:scale] != 1 then
            sio.puts "\t\t\toperands[#{idx}].mem.scale = %u" % op[:value][:mem][:scale]
          end
          if op[:value][:mem][:disp] != 0 then
            sio.puts "\t\t\toperands[#{idx}].mem.disp: 0x#{self.uint32(op.value[:disp]).to_s(16)}"
          end
        end
        if op[:shift][:type] != SFT_INVALID &&
            op[:shift][:value] then
          sio.puts "\t\t\tShift: type = #{op[:shift][:type]}, value = #{op[:shift][:value]}"
        end
      end
    end
    if i.update_flags then
      sio.puts "\tUpdate-flags: True"
    end

    if i.writeback then
      sio.puts "\tWrite-back: True"
    end
    if not [CC_AL, CC_INVALID].include? i.cc then
      sio.puts "\tCode condition: #{i.cc}"
    end
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
    cs.decomposer = true
    cache = nil
    cs.disasm(p['code'], 0x1000).each {|i|
      ours.puts "0x#{i.address.to_s(16)}:\t#{i.mnemonic}\t#{i.op_str}"
      self.print_detail(cs, i, ours)
      cache = i
    }
    ours.printf("0x%x:\n", cache.address + cache.size)
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
