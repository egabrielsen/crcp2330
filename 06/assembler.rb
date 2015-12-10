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

File.open(asm_filename) do |asm_file|
  asm_basename = File.basename(asm_filename, '.asm')
  path = File.split(asm_filename)[0]
  hack_filename = "#{path}/#{asm_basename}.hack"
  puts hack_filename
  File.open(hach_filename, 'w') do |hack_file|
    assembler = Assembler.new(asm_filename, hack_file)
    assembler.assemble!
  end
end
