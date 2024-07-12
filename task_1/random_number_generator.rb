class RandomNumberGenerator
  def initialize(count, upper_limit)
    @count = count
    @upper_limit = upper_limit
    validate_parameters
  end

  def generate
    random_numbers = Set.new
    while random_numbers.size < @count
      random_numbers << rand(@upper_limit)
    end
    random_numbers.to_a.sort
  end

  private

  def validate_parameters
    if @count > @upper_limit
      raise ArgumentError, "Количество уникальных чисел не может быть больше верхней границы диапазона."
    end
  end
end

class RandomNumberApp
  def self.run
    begin
      print "Введите количество элементов: "
      count = gets.chomp.to_i

      print "Введите верхнюю границу диапазона: "
      upper_limit = gets.chomp.to_i

      generator = RandomNumberGenerator.new(count, upper_limit)
      random_numbers = generator.generate

      random_numbers.each do |number|
        puts number
      end
    rescue ArgumentError => e
      puts "Ошибка: #{e.message}"
    rescue => e
      puts "Произошла ошибка: #{e.message}"
    end
  end
end

RandomNumberApp.run

# HOW_TO_RUN: ruby 1_random_number_generator.rb
