# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'ffi'

require_relative 'x86_const'

module Crabstone
    module X86

        class  MemoryOperand < FFI::Struct
            layout(
                :base, :uint,
                :index, :uint,
                :scale, :int,
                :disp, :int64
            )
        end

        class OperandValue < FFI::Union
            layout(
                :reg, :uint,
                :imm, :long_long,
                :fp, :double,
                :mem, MemoryOperand
            )
        end

        class Operand < FFI::Struct
            layout(
                :type, :uint,
                :value, OperandValue
            )

            # A spoonful of sugar...

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

            def reg?
                self[:type] == OP_REG
            end

            def imm?
                self[:type] == OP_IMM
            end

            def mem?
                self[:type] == OP_MEM
            end

            def fp?
                self[:type] == OP_FP
            end

            def valid?
                [OP_MEM, OP_IMM, OP_FP, OP_REG].include? self[:type]
            end

        end

        class Instruction < FFI::Struct

            layout(
                :prefix, [:uint8, 5],
                :segment, :uint,
                :opcode, [:uint8, 3],
                :op_size, :uint8,
                :addr_size, :uint8,
                :disp_size, :uint8,
                :imm_size, :uint8,
                :modrm, :uint8,
                :sib, :uint8,
                :disp, :int32,
                :sib_index, :uint,
                :sib_scale, :int8,
                :sib_base, :uint,
                :op_count, :uint8,
                :operands, [Operand, 8]
            )

            def operands
                self[:operands].first self[:op_count]
            end

        end
    end
end
