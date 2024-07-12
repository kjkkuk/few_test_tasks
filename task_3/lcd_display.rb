require 'optparse'

class LCDDisplay
  DIGITS = [
    [" - ", "| |", "   ", "| |", " - "], # 0
    ["   ", "  |", "   ", "  |", "   "], # 1
    [" - ", "  |", " - ", "|  ", " - "], # 2
    [" - ", "  |", " - ", "  |", " - "], # 3
    ["   ", "| |", " - ", "  |", "   "], # 4
    [" - ", "|  ", " - ", "  |", " - "], # 5
    [" - ", "|  ", " - ", "| |", " - "], # 6
    [" - ", "  |", "   ", "  |", "   "], # 7
    [" - ", "| |", " - ", "| |", " - "], # 8
    [" - ", "| |", " - ", "  |", " - "]  # 9
  ]

  def initialize(size)
    @size = size
  end

  def render(number)
    rows = Array.new(2 * @size + 3) { "" }
    number.each_char do |digit|
      segments = DIGITS[digit.to_i]
      rows[0] += segments[0][0] + segments[0][1] * @size + segments[0][2] + " "

      (1..@size).each { |i| rows[i] += segments[1][0] + " " * @size + segments[1][2] + " " }
      rows[@size + 1] += segments[2][0] + segments[2][1] * @size + segments[2][2] + " "
      (1..@size).each { |i| rows[@size + 1 + i] += segments[3][0] + " " * @size + segments[3][2] + " " }
      rows[2 * @size + 2] += segments[4][0] + segments[4][1] * @size + segments[4][2] + " "
    end

    rows.each { |row| puts row.rstrip }
  end
end

options = { size: 2 }
OptionParser.new do |opts|
  opts.banner = "Usage: test3.rb [options] number"

  opts.on("-vSIZE", "--size=SIZE", Integer, "Задайте размер цифры (по умолчанию: 2)") do |v|
    options[:size] = v
  end
end.parse!

number = ARGV[0]
unless number =~ /^\d+$/
  puts "Введите правильное число"
  exit
end

lcd_display = LCDDisplay.new(options[:size])
lcd_display.render(number)

# HOW_TO_RUN: ruby 3_lcd_display.rb -v [size] [number]
