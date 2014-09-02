# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

require_relative 'arm64_const'

module Crabstone
    module ARM64


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
                :disp, :int32
            )
        end

        class OperandValue < FFI::Union
            layout(
                :reg, :uint,
                :imm, :int32,
                :fp, :double,
                :mem, MemoryOperand
            )
        end

        class Operand < FFI::Struct

            layout(
                :shift, OperandShift,
                :ext, :uint,
                :type, :uint,
                :value, OperandValue
            )

            def value
                case self[:type]
                when OP_REG
                    self[:value][:reg]
                when OP_IMM
                    self[:value][:imm]
                when OP_MEM
                    self[:value][:mem]
                when OP_FP
                    self[:value][:fp]
                else
                    nil
                end
            end

            def shift_type
                self[:shift][:type]
            end

            def shift_value
                self[:shift][:value]
            end

            def shift?
                self[:shift][:type] != SFT_INVALID
            end

            def ext?
                self[:ext] != EXT_INVALID
            end

            def reg?
                self[:type] == OP_REG
            end

            def imm?
                self[:type] == OP_IMM
            end

            def cimm?
                self[:type] == OP_CIMM
            end

            def mem?
                self[:type] == OP_MEM
            end

            def fp?
                self[:type] == OP_FP
            end

            def valid?
                [OP_MEM, OP_IMM, OP_CIMM, OP_FP, OP_REG].include? self[:type]
            end

        end

        class Instruction < FFI::Struct
            layout(
                :cc, :uint,
                :writeback, :bool,
                :update_flags, :bool,
                :op_count, :uint8,
                :operands, [Operand, 8]
            )

            def operands
                self[:operands].take_while {|op| op[:type].nonzero?}
            end

        end
    end
end
