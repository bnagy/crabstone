#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
include Crabstone

arm = (
  "\xED\xFF\xFF\xEB\x04\xe0\x2d\xe5\x00\x00\x00\x00\xe0\x83\x22" <<
  "\xe5\xf1\x02\x03\x0e\x00\x00\xa0\xe3\x02\x30\xc1\xe7\x00\x00\x53\xe3"
)

begin
  
  cs = Disassembler.new(ARCH_ARM, MODE_ARM)
  puts "Hello from Capstone v #{cs.version.join('.')}!"
  puts "Disasm:"

  begin
    cs.decomposer = true
    cs.disasm(arm, 0x1000).each {|i|
      printf("0x%x:\t%s\t\t%s\n",i.address, i.mnemonic, i.op_str)
    }
    # disasm is a Crabstone::Disassembly object that mixes in Enumerable
    disasm = cs.disasm(arm, 0x1000)
    # insns is now an Array of Crabstone::Instructions, with an ObjectSpace
    # finalizer proc attached to the Array itself. Try not to do this unless
    # you REALLY REALLY HAVE TO, because there are all kinds of horrible
    # things that can go wrong, especially if you start keeping refs to any of
    # the Instructions inside the array.
    insns = disasm.insns
    # disasm, on the other hand, is lazy, and doesn't call into C until it has
    # to. It automatically frees resources. However, it WILL make a new C call
    # to cs_disasm_ex every time you invoke an Enumerable method like this.
    puts disasm.map {|i| "0x%x:\t%s\t\t%s\n" % [i.address, i.mnemonic, i.op_str]}

  rescue
    fail "Disassembly error: #{$!} #{$@}"
  ensure
    cs.close
  end

rescue
  fail "Unable to open engine: #{$!}"
end
