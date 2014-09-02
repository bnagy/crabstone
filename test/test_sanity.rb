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
      reg_max: 260,
      ins_max: 452,
      grp_max: 6
    ],
    Crabstone::ARM => Hash[
      reg_max: 111,
      ins_max: 435,
      grp_max: 33
    ],
    Crabstone::MIPS => Hash[
      reg_max: 129,
      ins_max: 350,
      grp_max: 35
    ],
    Crabstone::PPC => Hash[
      reg_max: 178,
      ins_max: 769,
      grp_max: 12
    ],
    Crabstone::SysZ => Hash[
      reg_max: 35,
      ins_max: 682,
      grp_max: 7
    ],
    Crabstone::Sparc => Hash[
      reg_max: 87,
      ins_max: 277,
      grp_max: 9
    ],
    Crabstone::X86 => Hash[
      reg_max: 234,
      ins_max: 1298,
      grp_max: 47
    ],
    Crabstone::XCore => Hash[
      reg_max: 26,
      ins_max: 121,
      grp_max: 2
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
      p klass::REG_MAX
            p klass::GRP_MAX
                  p klass::INS_MAX
    else
      puts "\t#{__FILE__}: #{klass}: PASS"
    end

  end


end
