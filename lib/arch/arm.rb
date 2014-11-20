# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

require_relative 'arm_const'

module Crabstone
  module ARM

    class OperandShift < FFI::Struct
      layout(
        :type, :uint,
        :value, :uint
      )
    end

    class MemoryOperand < FFI::Struct
      layout(
        :base, :uint,
        :index, :uint,
        :scale, :int,
        :disp, :int
      )
    end

    class OperandValue < FFI::Union
      layout(
        :reg, :uint,
        :imm, :int32,
        :fp, :double,
        :mem, MemoryOperand,
        :setend, :int
      )
    end

    class Operand < FFI::Struct
      layout(
        :vector_index, :int,
        :shift, OperandShift,
        :type, :uint,
        :value, OperandValue,
        :subtracted, :bool
      )

      def value
        case self[:type]
        when *[OP_REG, OP_SYSREG]
          self[:value][:reg]
        when *[OP_IMM, OP_CIMM, OP_PIMM]
          self[:value][:imm]
        when OP_MEM
          self[:value][:mem]
        when OP_FP
          self[:value][:fp]
        when OP_SETEND
          self[:value][:setend]
        else
          nil
        end
      end

      def reg?
        [OP_REG, OP_SYSREG].include? self[:type]
      end

      def imm?
        [OP_IMM, OP_CIMM, OP_PIMM].include? self[:type]
      end

      def cimm?
        self[:type] == OP_CIMM
      end

      def pimm?
        self[:type] == OP_PIMM
      end

      def mem?
        self[:type] == OP_MEM
      end

      def fp?
        self[:type] == OP_FP
      end

      def sysreg?
        self[:type] == OP_SYSREG
      end

      def valid?
        [
          OP_MEM,
          OP_IMM,
          OP_CIMM,
          OP_PIMM,
          OP_FP,
          OP_REG,
          OP_SYSREG,
          OP_SETEND
        ].include? self[:type]
      end
    end

    class Instruction < FFI::Struct
      layout(
        :usermode, :bool,
        :vector_size, :int,
        :vector_data, :int,
        :cps_mode, :int,
        :cps_flag, :int,
        :cc, :uint,
        :update_flags, :bool,
        :writeback, :bool,
        :mem_barrier, :int,
        :op_count, :uint8,
        :operands, [Operand, 36]
      )

      def operands
        self[:operands].take_while {|op| op[:type].nonzero?}
      end

    end
  end
end
