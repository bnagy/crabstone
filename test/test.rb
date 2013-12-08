#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module Test

  include Crabstone

  X86_CODE16 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00"
  X86_CODE32 = "\x8d\x4c\x32\x08\x01\xd8\x81\xc6\x34\x12\x00\x00"
  X86_CODE64 = "\x55\x48\x8b\x05\xb8\x13\x00\x00"
  ARM_CODE = "\xED\xFF\xFF\xEB\x04\xe0\x2d\xe5\x00\x00\x00\x00\xe0\x83\x22\xe5\xf1\x02\x03\x0e\x00\x00\xa0\xe3\x02\x30\xc1\xe7\x00\x00\x53\xe3"
  ARM_CODE2 = "\x10\xf1\x10\xe7\x11\xf2\x31\xe7\xdc\xa1\x2e\xf3\xe8\x4e\x62\xf3"
  THUMB_CODE = "\x70\x47\xeb\x46\x83\xb0\xc9\x68"
  THUMB_CODE2 = "\x4f\xf0\x00\x01\xbd\xe8\x00\x88\xd1\xe8\x00\xf0"
  MIPS_CODE = "\x0C\x10\x00\x97\x00\x00\x00\x00\x24\x02\x00\x0c\x8f\xa2\x00\x00\x34\x21\x34\x56"
  MIPS_CODE2 = "\x56\x34\x21\x34\xc2\x17\x01\x00"
  ARM64_CODE = "\x21\x7c\x02\x9b\x21\x7c\x00\x53\x00\x40\x21\x4b\xe1\x0b\x40\xb9"

  @platforms = [
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_16,
      'code' => X86_CODE16,
      'comment' => "X86 16bit (Intel syntax)"
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32,
      'code' => X86_CODE32,
      'comment' => "X86 32bit (ATT syntax)",
      'syntax' => :att,
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_32,
      'code' => X86_CODE32,
      'comment' => "X86 32 (Intel syntax)"
    ],
    Hash[
      'arch' => ARCH_X86,
      'mode' => MODE_64,
      'code' => X86_CODE64,
      'comment' => "X86 64 (Intel syntax)"
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_ARM,
      'code' => ARM_CODE,
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
      'code' => ARM_CODE2,
      'comment' => "ARM: Cortex-A15 + NEON"
    ],
    Hash[
      'arch' => ARCH_ARM,
      'mode' => MODE_THUMB,
      'code' => THUMB_CODE,
      'comment' => "THUMB"
    ],
    Hash[
      'arch' => ARCH_MIPS,
      'mode' => MODE_32 + MODE_BIG_ENDIAN,
      'code' => MIPS_CODE,
      'comment' => "MIPS-32 (Big-endian)"
    ],
    Hash[
      'arch' => ARCH_MIPS,
      'mode' => MODE_64 + MODE_LITTLE_ENDIAN,
      'code' => MIPS_CODE2,
      'comment' => "MIPS-64-EL (Little-endian)"
    ],
    Hash[
      'arch' => ARCH_ARM64,
      'mode' => MODE_ARM,
      'code' => ARM64_CODE,
      'comment' => "ARM-64"
    ],
  ]

  ours = StringIO.new

  begin
    cs    = Disassembler.new(0,0)
    print "Basic Test: Capstone v #{cs.version.join('.')} - "
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
    cache = nil
    cs.disasm(p['code'], 0x1000).each do |i|
      ours.printf("0x%x:\t%s\t\t%s\n",i.address, i.mnemonic, i.op_str)
      cache = i
    end
    cs.close
    ours.printf("0x%x:\n", cache.address + cache.size);
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
