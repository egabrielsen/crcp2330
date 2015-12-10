#! /usr/bin/env ruby

def args_valid?
  ARGV[0] && ARGV[0].end_with?(".asm") && ARGV.length == 1
end

def is_readable?(file)
  File.readable?(file)
end

unless args_valid?
  abort("Usage: ./assember.rb Prog.asm")
end

asm_filename = ARGV[0]

unless is_readable?(asm_filename)
  abort("#{asm_filename} is not readable or is not found")
end

puts "The contents of #{asm_filename}"
