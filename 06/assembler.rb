require_relative 'parser'

class Assembler

  LABELS = {
			'SP' => 0,
			'LCL' => 1,
			'ARG' => 2,
			'THIS' => 3,
			'THAT' => 4,
			'SCREEN' => 16384,
			'KBD' => 24576
		}

  def initialize(asm_file, hack_file)
    @asm_file = asm_file
    @hack_file = hack_file
    @parser = Parser.new(instructions_from_file)
  end

  def assemble!
    hack_instructions = @parser.parse!
    hack_instructions.each do |instruction|
      @hack_file << instruction << "\n"
    end
  end

  def instructions_from_file
    lines = @asm_file.readlines
    lines.each do |line|
      line.gsub! /\/\/.*/, ''
      line.strip!
    end
    lines.delete("")
    labels = get_labels(lines)
		numVariables = 0
		lines.each do |line|
			if line.include?('(')
				line.gsub! /.+/, ''
			elsif line.include?('@')
				if line.match(/R[\d]{1,2}/)
					line.gsub! /R[\d]+/, line[2..-1]
				elsif labels.has_key?(line[1..-1])
					line.gsub! line[1..-1], labels[line[1..-1]].to_s
				elsif not line.match(/@\d+/)
					labels[line[1..-1]] = 16 + numVariables
					line.gsub! line[1..-1], labels[line[1..-1]].to_s
					numVariables += 1
				end
			end
		end
		lines.delete('')
    return lines
  end

  def get_labels(lines)
		lineNum = 0
		numLabels = 0
		lines.each do |line|
			if line.include?('(')
				LABELS[line[1..-2]] = lineNum - numLabels
				numLabels += 1
			end
			lineNum += 1
		end
		LABELS
	end

end
