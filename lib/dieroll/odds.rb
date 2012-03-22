module Dieroll class Odds
    attr_reader :combinations_array, :max_result, :variance,
                :standard_deviation, :mean
    attr_accessor :offset

    def initialize(combinations_array, offset=1)
      @combinations_array = combinations_array
      @offset = offset
      sum_combinations
      calculate_odds
      calculate_statistics
    end

    def *(other)
      result_array = []
      @combinations_array.each_with_index do |combination_one, index_one|
        other.combinations_array.each_with_index do |combination_two, index_two|
          result_array[index_one + index_two] ||= 0
          result_array[index_one + index_two] +=
            combination_one * combination_two
        end
      end

      offset = @offset + other.offset

      Odds.new(result_array, offset)
    end

    def **(number)
      original = Odds.new(@combinations_array)
      result = Odds.new(@combinations_array)
      number -= 1
      number.times do
        result *= original
      end

      result
    end

    def +(mod)
      mod += @offset

      Odds.new(@combinations_array, mod)
    end

    def -(mod)
      mod = @offset - mod

      Odds.new(@combinations_array, mod)
    end

    def equal(result)
      if(result-@offset >= 0 && !!@odds_array[result-@offset])
        @odds_array[result-@offset]
      else
        0
      end
    end
    
    def not_equal(result)
      1 - equal(result)
    end

    def greater_than(result)
      total_chance = 0
      @odds_array.each_with_index do |chance, index|
        if(index+@offset > result)
          total_chance += chance
        end
      end

      total_chance
    end

    def greater_than_or_equal(result)
      self.greater_than(result) + self.equal(result)
    end

    def less_than(result)
      1 - greater_than_or_equal(result)
    end

    def less_than_or_equal(result)
      1 - greater_than(result)
    end

    def to_s
      "#{@odds_array}"
    end
    
    def table(value, comparison_array, header=false)
      valid_comparisons = [:not_equal, :equal,
                            :less_than, :less_than_or_equal,
                            :greater_than_or_equal, :greater_than]
      if value == :all
        range = (@offset..@max_result)
      else
        if value.kind_of?(Array)
          range = value
        else
          range = [value]
        end
      end

      result_lines = []
      if header
        result_lines << comparison_array
        result_lines[0].unshift "result"
      end

      range.each do |result|
        result_line = [result]
        comparison_array.each do |comparison|
          if valid_comparisons.include?(comparison)
            result_line << self.send(comparison, result).round(4)
          end
        end
        result_lines << result_line
      end

      result_lines
    end

    private

    def sum_combinations
      @combinations_total = @combinations_array.inject(0) do |sum, element|
        sum + element
      end
    end

    def calculate_odds
      @odds_array = @combinations_array.map do |combination|
        (combination.to_f / @combinations_total.to_f)
      end
    end
    
    def calculate_statistics
      @max_result = @combinations_array.size + @offset - 1

      results_sum = 0
      (@offset..@max_result).each do |result|
        results_sum += result  
      end
      @mean = results_sum  / @combinations_array.size

      variance_sum = 0
      (@offset..@max_result).each do |result|
        variance_sum += (result - @mean)**2 *
                        @combinations_array[result - @offset]
      end
      @variance = (variance_sum.to_f / @combinations_total)

      @standard_deviation = (Math.sqrt @variance)
    end
  end
end
