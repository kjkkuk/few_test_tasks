class WordBreaker
  def initialize(string, dictionary)
    @string = string
    @dictionary = dictionary.to_set
  end

  def can_break?
    n = @string.length
    dp = Array.new(n + 1, false)
    dp[0] = true

    (1..n).each do |i|
      (0...i).each do |j|
        if dp[j] && @dictionary.include?(@string[j...i])
          dp[i] = true
          break
        end
      end
    end

    dp[n]
  end
end

puts "Введите строку:"
string = gets.chomp

puts "Введите слова словаря, разделенные пробелами:"
dictionary = gets.chomp.split

breaker = WordBreaker.new(string, dictionary)
if breaker.can_break?
  puts "Строку '#{string}' можно разбить на слова из словаря."
else
  puts "Строку '#{string}' нельзя разбить на слова из словаря."
end

# HOW_TO_RUN: ruby 2_dictionary.rb
