#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module Test

  include Crabstone

  # These need to be maintained by hand, but I actually just copy them over
  # from the Go binding. It's just a very quick check to catch developer
  # error.
  # TODO: Work out why I can't get the C constants with ffi/tools/const_generator
  @checks = {
    Crabstone::ARM64 => Hash[
      :reg_max => 226,
      :ins_max => 446,
      :grp_max => 5,
    ],
    Crabstone::ARM => Hash[
      :reg_max => 111,
      :ins_max => 422,
      :grp_max => 33,
    ],
    Crabstone::MIPS => Hash[
      :reg_max => 123,
      :ins_max => 456,
      :grp_max => 20,
    ],
    Crabstone::PPC => Hash[
      :reg_max => 137,
      :ins_max => 436,
      :grp_max => 7,
    ],
    Crabstone::SysZ => Hash[
      :reg_max => 35,
      :ins_max => 679,
      :grp_max => 7,
    ],
    Crabstone::Sparc => Hash[
      :reg_max => 87,
      :ins_max => 279,
      :grp_max => 9,
    ],
    Crabstone::X86 => Hash[
      :reg_max => 233,
      :ins_max => 1258,
      :grp_max => 35,
    ],
  }

  begin
    cs    = Disassembler.new(0,0)
    print "Sanity Check: Capstone v #{cs.version.join('.')}\n"
  ensure
    cs.close rescue nil
  end

  #Test through all modes and architectures
  @checks.each do |klass, checklist|
    if klass::REG_MAX != checklist[:reg_max] ||
        klass::INS_MAX != checklist[:ins_max] ||
        klass::GRP_MAX != checklist[:grp_max]
      puts "\t#{__FILE__}: #{klass}: FAIL"
    else
      puts "\t#{__FILE__}: #{klass}: PASS"
    end

  end


end
