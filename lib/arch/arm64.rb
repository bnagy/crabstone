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
                :imm, :int64,
                :fp, :double,
                :mem, MemoryOperand,
                :pstate, :int,
                :sys, :uint,
                :prefetch, :int,
                :barrier, :int
            )
        end

        class Operand < FFI::Struct

            layout(
                :vector_index, :int,
                :vas, :int,
                :vess, :int,
                :shift, OperandShift,
                :ext, :uint,
                :type, :uint,
                :value, OperandValue
            )

            def value
                case self[:type]
                when *[OP_REG, OP_REG_MRS, OP_REG_MSR]  # Register operand.
                    self[:value][:reg]
                when *[OP_IMM, OP_CIMM]                 # Immediate operand.
                    self[:value][:imm]
                when OP_FP                              # Floating-Point immediate operand.
                    self[:value][:fp]
                when OP_MEM                             # Memory operand
                    self[:value][:mem]
                when OP_PSTATE                          # PState operand.
                    self[:value][:pstate]
                when OP_SYS                             # SYS operand for IC/DC/AT/TLBI instructions.
                    self[:value][:sys]
                when OP_PREFETCH                        # Prefetch operand (PRFM).
                    self[:value][:prefetch]
                when OP_BARRIER                         # Memory barrier operand (ISB/DMB/DSB instructions).
                    self[:value][:barrier]
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

            def pstate?
                self[:type] == OP_PSTATE
            end

            def msr?
                self[:type] == OP_REG_MSR
            end

            def mrs?
                self[:type] == OP_REG_MRS
            end

            def barrier?
                self[:type] == OP_BARRIER
            end

            def prefetch?
                self[:type] == OP_PREFETCH
            end

            def valid?
                [
                    OP_INVALID,
                    OP_REG,
                    OP_CIMM,
                    OP_IMM,
                    OP_FP,
                    OP_MEM,
                    OP_REG_MRS,
                    OP_REG_MSR,
                    OP_PSTATE,
                    OP_SYS,
                    OP_PREFETCH,
                    OP_BARRIER
                ].include? self[:type]
            end

        end

        class Instruction < FFI::Struct
            layout(
                :cc, :uint,
                :update_flags, :bool,
                :writeback, :bool,
                :op_count, :uint8,
                :operands, [Operand, 8]
            )

            def operands
                self[:operands].take_while {|op| op[:type].nonzero?}
            end

        end
    end
end
