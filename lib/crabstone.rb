# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

require_relative 'arch/x86'
require_relative 'arch/x86_registers'
require_relative 'arch/arm'
require_relative 'arch/arm_registers'
require_relative 'arch/arm64'
require_relative 'arch/arm64_registers'
require_relative 'arch/mips'
require_relative 'arch/mips_registers'

module Crabstone

  VERSION = '0.0.6'

  ARCH_ARM   = 0
  ARCH_ARM64 = 1
  ARCH_MIPS  = 2
  ARCH_X86   = 3

  MODE_LITTLE_ENDIAN = 0
  MODE_SYNTAX_INTEL  = 0
  MODE_ARM           = 0
  MODE_16            = 1 << 1
  MODE_32            = 1 << 2
  MODE_64            = 1 << 3
  MODE_THUMB         = 1 << 4
  MODE_SYNTAX_ATT    = 1 << 30
  MODE_BIG_ENDIAN    = 1 << 31

  # Option types and values ( so far ) for cs_option()
  OPT_SYNTAX = 1
  SYNTAX = {
    :intel => 1,
    :att   => 2
  }

  class ErrArch < StandardError; end
  class ErrCsh < StandardError; end
  class ErrHandle < StandardError; end
  class ErrMem < StandardError; end
  class ErrMode < StandardError; end
  class ErrOK < StandardError; end
  class ErrOption < StandardError; end

  ERRNO = {
    0 => ErrOK,
    1 => ErrMem,
    2 => ErrArch,
    3 => ErrHandle,
    4 => ErrCsh,
    5 => ErrMode,
    6 => ErrOption
  }

  module Binding

    extend FFI::Library
    ffi_lib 'capstone'

    # This is because JRuby FFI on x64 Windows thinks size_t is 32 bit
    case FFI::Platform::ADDRESS_SIZE
    when 64
      typedef :ulong_long, :size_t
    when 32
      typedef :ulong, :size_t
    else
      fail "Unsupported native address size"
    end

    typedef :size_t, :csh
    typedef :size_t, :cs_opt_value
    typedef :uint, :cs_opt_type
    typedef :uint, :cs_err
    typedef :uint, :cs_arch
    typedef :uint, :cs_mode

    class Architecture < FFI::Union
      layout(
        :x86, X86::Instruction,
        :arm64, ARM64::Instruction,
        :arm, ARM::Instruction,
        :mips, MIPS::Instruction
      )
    end

    class Instruction < FFI::Struct
      layout(
        :id, :uint,
        :address, :ulong_long,
        :size, :uint16,
        :bytes, [:uchar, 16],
        :mnemonic, [:char, 32],
        :op_str, [:char, 96],
        :regs_read, [:uint, 32],
        :regs_read_count, :uint,
        :regs_write, [:uint, 32],
        :regs_write_count, :uint,
        :groups, [:uint, 8],
        :groups_count, :uint,
        :arch, Architecture
      )
    end

    attach_function(
      :cs_disasm_dyn,
      [:csh, :pointer, :size_t, :ulong_long, :size_t, :pointer],
      :size_t
    )
    attach_function :cs_close, [:csh], :cs_err
    attach_function :cs_errno, [:csh], :cs_err
    attach_function :cs_free, [:pointer], :void
    attach_function :cs_insn_group, [:csh, Instruction, :uint], :bool
    attach_function :cs_insn_name, [:csh, :uint], :string
    attach_function :cs_op_count, [:csh, Instruction, :uint], :cs_err
    attach_function :cs_open, [:cs_arch, :cs_mode, :pointer], :cs_err
    attach_function :cs_option, [:csh, :cs_opt_type, :cs_opt_value], :cs_err
    attach_function :cs_reg_name, [:csh, :uint], :string
    attach_function :cs_reg_read, [:csh, Instruction, :uint], :bool
    attach_function :cs_reg_write, [:csh, Instruction, :uint], :bool
    attach_function :cs_version, [:pointer, :pointer], :void

  end # Binding

  class Instruction

    attr_reader :arch, :csh, :groups, :raw_insn, :regs_read, :regs_write
    ARCHS = { arm: ARCH_ARM, arm64: ARCH_ARM64, x86: ARCH_X86, mips: ARCH_MIPS}.invert
    ARCH_CLASSES = { ARCH_ARM => ARM, ARCH_ARM64 => ARM64, ARCH_X86 => X86, ARCH_MIPS => MIPS}

    def initialize csh, insn, arch
      @arch       = arch
      @csh        = csh
      @raw_insn   = insn
      @arch_insn  = raw_insn[:arch][ARCHS[arch]]
      @regs_read  = insn[:regs_read].first insn[:regs_read_count]
      @regs_write = insn[:regs_write].first insn[:regs_write_count]
      @groups     = insn[:groups].first insn[:groups_count]
    end

    def name
      name = Binding.cs_insn_name(csh, id)
      raise ErrCsh unless name
      name
    end

    def group? groupid
      Binding.cs_insn_group csh, raw_insn, groupid
    end

    def reads_reg? reg
      Binding.cs_reg_read csh, raw_insn, ARCH_CLASSES[arch].register( reg )
    end

    def writes_reg? reg
      Binding.cs_reg_write csh, raw_insn, ARCH_CLASSES[arch].register( reg )
    end

    def op_count op_type=nil
      if op_type
        Binding.cs_op_count csh, raw_insn, op_type
      else
        self.operands.size
      end
    end

    def method_missing meth, *args
      if raw_insn.members.include? meth
        # Dispatch to toplevel Instruction class ( this file )
        raw_insn[meth]
      else
        # Dispatch to the architecture specific Instruction ( in arch/ )
        if @arch_insn.respond_to? meth
          @arch_insn.send meth, *args
        elsif @arch_insn.members.include? meth
          @arch_insn[meth]
        else
          raise NoMethodError, "Unknown method #{meth} for #{self.class}"
        end
      end
    end
  end

  class Disassembler

    attr_reader :arch, :mode, :csh, :syntax

    def initialize arch, mode

      @arch    = arch
      @mode    = mode
      p_size_t = FFI::MemoryPointer.new :ulong_long
      p_csh    = FFI::MemoryPointer.new p_size_t
      if ( res = Binding.cs_open( arch, mode, p_csh )).nonzero?
        raise ERRNO[res]
      end
      @csh = p_csh.read_ulong_long
    end

    def close
      if (res = Binding.cs_close(csh) ).nonzero?
        raise ERRNO[res]
      end
    end

    def syntax= new_stx
      raise ErrOption, "Unknown Syntax. Try :intel or :att" unless SYNTAX[new_stx]
      if (res = Binding.cs_option(csh, OPT_SYNTAX, SYNTAX[new_stx])).nonzero?
        raise ERRNO[res]
      end
      @syntax = new_stx
    end

    def version
      maj = FFI::MemoryPointer.new(:int)
      min = FFI::MemoryPointer.new(:int)
      Binding.cs_version maj, min
      [ maj.read_int, min.read_int ]
    end

    def errno
      Binding.cs_errno(csh)
    end

    def reg_name regid
      name = Binding.cs_reg_name(csh, regid)
      raise ErrCsh unless name
      name
    end

    def disasm code, offset, count=0, &blk

      return [] if code.empty?

      begin

        insn       = Binding::Instruction.new
        insn_ptr   = FFI::MemoryPointer.new insn
        res        = []
        insn_count = Binding.cs_disasm_dyn(
          csh,
          code,
          code.bytesize,
          offset,
          count,
          insn_ptr
        )

        raise ERRNO[errno] if insn_count.zero?

        (0...insn_count * insn.size).step(insn.size).each {|insn_offset|
          cs_insn   = Binding::Instruction.new( (insn_ptr.read_pointer)+insn_offset ).clone
          this_insn = Instruction.new csh, cs_insn, arch
          if block_given?
            yield this_insn
          else
            res << this_insn
          end
        }

      ensure
        Binding.cs_free insn_ptr.read_pointer
      end

      return res unless block_given?
    end
  end
end
