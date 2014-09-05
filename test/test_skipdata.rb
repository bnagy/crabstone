#! /usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestSkipdata

  include Crabstone

  X86_CODE32 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00\x00\x91\x92"
  RANDOM_CODE = "\xed\x00\x00\x00\x00\x1a\x5a\x0f\x1f\xff\xc2\x09\x80\x00\x00\x00\x07\xf7\xeb\x2a\xff\xff\x7f\x57\xe3\x01\xff\xff\x7f\x57\xeb\x00\xf0\x00\x00\x24\xb2\x4f\x00\x78"
  
  @platforms = [
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32,
      'code' => X86_CODE32,
      'comment' => "X86 32 (Intel syntax) - Skip data",
      'mnemonic' => nil,
      'callback' => nil
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_ARM,
      'code' => RANDOM_CODE,
      'comment' => "Arm - Skip data",
      'mnemonic' => nil,
      'callback' => nil
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32,
      'code' => X86_CODE32,
      'comment' => "X86 32 (Intel syntax) - Skip data with custom mnemonic",
      'mnemonic' => 'db',
      'callback' => nil
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_ARM,
      'code' => RANDOM_CODE,
      'comment' => "Arm - Skip data with callback",
      'mnemonic' => 'db',
      'callback' => lambda {|_,_| 2}
    ]
  ]

  def self.uint32 i
    Integer(i) & 0xffffffff
  end

  def self.uint64 i
    Integer(i) & ((1<<64)-1)
  end

  ours = StringIO.new

  begin
    cs = Disassembler.new(0,0)
    print "ARM64 Skipdata Test: Capstone v #{cs.version.join('.')} - "
  ensure
    cs.close
  end

  #Test through all modes and architectures
  @platforms.each do |p|
    ours.puts "****************"
    ours.puts "Platform: #{p['comment']}"
    ours.puts "Code: #{p['code'].bytes.map {|b| "0x%.2x" % b}.join(' ')} "
    ours.puts "Disasm:"
    cs = Disassembler.new(p['arch'], p['mode'])

    if p['syntax']
      cs.syntax = p['syntax']
    end

    cs.decomposer = true
    cache = nil

    if p['mnemonic']
      cs.skipdata p['mnemonic'], &(p['callback'])
    else
      # Even if callback is nil this turns on skipdata mode
      cs.skipdata &(p['callback'])
    end

    cs.disasm(p['code'], 0x1000).each {|insn|
      ours.puts "0x#{insn.address.to_s(16)}:\t#{insn.mnemonic}\t\t#{insn.op_str}"
      cache = insn.address + insn.size
    }
    ours.printf("0x%x:\n", cache)
    ours.puts

    cs.close
  end

  ours.rewind
  theirs = File.binread(__FILE__ + ".SPEC") rescue ''
  if ours.read == theirs
    puts "#{__FILE__}: PASS"
  else
    ours.rewind
    puts ours.read
    puts "#{__FILE__}: FAIL"
  end
end
