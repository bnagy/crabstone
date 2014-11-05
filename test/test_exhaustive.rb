#!/usr/bin/env ruby

# Library by Nguyen Anh Quynh
# Original binding by Nguyen Anh Quynh and Tan Sheng Di
# Additional binding work by Ben Nagy
# (c) 2013 COSEINC. All Rights Reserved.

require 'crabstone'
require 'stringio'

module TestExhaustive

	include Crabstone

	@files = Dir['**/*.cs']
	check = pass = fail = error = 0
	@files.each do |fn|

		lines = File.readlines fn
		arch, mode, syntax = lines.shift.delete('# ').split(',')

		archnum = Crabstone.const_get arch.sub('CS_','')

		begin
			modenum = Integer(mode)
		rescue
			modenum = mode.gsub('CS_','').split('+').map {|m| Crabstone.const_get(m)}.inject(:+)
		end

		begin
			cs = Disassembler.new(archnum, modenum)
			check +=1
		rescue
			warn "Error #{$!} processing #{fn}"
		end

		if syntax =~ /ATT/
			cs.syntax = :att
		end
		if arch =~ /arm/i
			cs.syntax = :no_regname
		end

		lines.each.with_index {|l, i|

			bytes, text = l.chomp.split(' = ')
			bytes = bytes.split(',').map {|b| b.to_i(16)}.pack('c*')
			# #32 or $32 -> #0x20 #-32 -> #-0x20
			want = text.gsub(/([\$#])(-?)([0-9]{2,})/) {|s| "#{$1}#{$2}0x#{$3.to_i.to_s(16)}"}.downcase
			
			begin
				disasm = cs.disasm(bytes,0).map {|i|"#{i.mnemonic} #{i.op_str}"}
			rescue
				puts "[**] #{fn}:#{i+2} want #{text}, got #{$!} with #{bytes.inspect}, #{arch}, #{mode}"
				error += 1
				next
			end

			if disasm.size > 1
				puts "[!!] #{fn}:#{i+2} disasm too big"
				fail += 1
				next
			end
			if disasm.first != want
				puts "[!!] #{fn}:#{i+2} want #{want.inspect}, got #{disasm.first.inspect}"
				fail +=1
				next
			end

			puts "[OK] #{fn}:#{i+2} #{bytes.inspect} = #{text}"
			pass += 1

		}
	end

	if check != @files.size
		warn "Missed some: #{check} vs #{@files.size}"
	end
	puts "Files: #{check}, Pass: #{pass}, Fail: #{fail}, Error: #{error}"
end
