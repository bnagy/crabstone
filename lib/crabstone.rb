# Library by Ngyuen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# © 2013 COSEINC

require 'ffi'

require_relative 'arch/x86'
require_relative 'arch/x86_registers'
require_relative 'arch/arm'
require_relative 'arch/arm_registers'
require_relative 'arch/arm64'
require_relative 'arch/arm64_registers'

module Crabstone

  VERSION = '0.0.2'

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

  module Binding

    extend FFI::Library
    ffi_lib 'capstone'

    class Architecture < FFI::Union
      layout(
        :x86, X86::Instruction,
        :arm64, ARM64::Instruction,
        :arm, ARM::Instruction
        #mips
      )
    end

    class Instruction < FFI::Struct
      layout(
        :id, :uint,
        :address, :ulong_long,
        :size, :uint16,
        :mnemonic, [:char, 32],
        :operand_string, [:char, 96],
        :regs_read, [:uint, 32],
        :regs_write, [:uint, 32],
        :groups, [:uint, 8],
        :arch, Architecture
      )
    end

    attach_function :cs_disasm_dyn, [:ulong_long, :pointer, :ulong_long, :ulong_long, :ulong_long, :pointer], :ulong_long
    attach_function :cs_open, [:int, :ulong, :pointer], :bool
    attach_function :cs_free, [:pointer], :void
    attach_function :cs_close, [:ulong_long], :bool
    attach_function :cs_reg_name, [:ulong_long, :uint], :pointer
    attach_function :cs_insn_name, [:ulong_long, :uint], :pointer
    attach_function :cs_insn_group, [:ulong_long, :pointer, :uint], :bool
    attach_function :cs_reg_read, [:ulong_long, :pointer, :uint], :bool
    attach_function :cs_reg_write, [:ulong_long, :pointer, :uint], :bool
    attach_function :cs_op_count, [:ulong_long, :pointer, :uint], :int
    attach_function :cs_op_index, [:ulong_long, :pointer, :uint, :uint], :int

  end # Binding

  class Instruction

    attr_reader :arch, :csh, :groups, :raw_insn, :regs_read, :regs_write
    ARCHS = { arm: ARCH_ARM, arm64: ARCH_ARM64, x86: ARCH_X86, mips: ARCH_MIPS}.invert

    def initialize csh, insn, arch
      @arch       = arch
      @csh        = csh
      @groups     = insn[:groups].take_while( &:nonzero? )
      @raw_insn   = insn
      @regs_read  = insn[:regs_read].take_while( &:nonzero? )
      @regs_write = insn[:regs_write].take_while( &:nonzero? )
      @arch_insn  = raw_insn[:arch][ARCHS[arch]]
    end

    def reg_name regid
      Binding.cs_reg_name(csh, regid).read_string
    end

    def insn_name
      Binding.cs_insn_name(csh, id).read_string
    end

    def group? groupid
      Binding.cs_insn_group csh, raw_insn, groupid
    end

    def reads? regid
      # If they gave us a register as a string...
      if regid.respond_to?( &:upcase )
        regid = ARCHS[arch].register regid.upcase
      end
      Binding.cs_reg_read csh, raw_insn, regid
    end

    def writes? regid
      if regid.respond_to?( &:upcase )
        regid = ARCHS[arch].register regid.upcase
      end
      Binding.cs_reg_write csh, raw_insn, regid
    end

    def op_count op_type=nil
      if op_type
        Binding.cs_op_count csh, raw_insn, op_type
      else
        self.operands.size
      end
    end

    def op_index op_type, position
      Binding.cs_op_index csh, raw_insn, op_type, position
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

    attr_reader :arch, :mode, :csh, :cs_hptr

    def initialize arch, mode

      @arch    = arch
      @mode    = mode
      @csh     = FFI::MemoryPointer.new :ulong_long
      @cs_hptr = FFI::MemoryPointer.new @csh

      Binding.cs_open arch, mode, @cs_hptr
    end

    def close
      Binding.cs_close cs_hptr.read_ulong_long
    end

    def disasm code, offset, count=0, &blk
      begin

        insn       = Binding::Instruction.new
        insn_ptr   = FFI::MemoryPointer.new insn
        res        = []
        insn_count = Binding.cs_disasm_dyn(
          cs_hptr.read_ulong_long,
          code,
          code.bytesize,
          offset,
          count,
          insn_ptr
        )

        (0...insn_count * insn.size).step(insn.size).each {|off|
          cs_insn   = Binding::Instruction.new( insn_ptr.read_pointer+off ).clone
          this_insn = Instruction.new cs_hptr.read_ulong_long, cs_insn, arch
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
