module Dieroll
  class Odds
    attr_reader :combinations_array

    def initialize(combinations_array)
      @combinations_array = combinations_array
      sum_combinations
      calculate_odds
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

      Odds.new(result_array)
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
      if(mod < 0)
        return self.-(-mod)
      end

      result_array = @combinations_array.dup
      mod.times do
        result_array.unshift 0.0
      end

      Odds.new(result_array)
    end

    def -(mod)
      if(mod < 0)
        return self.+(-mod)
      end

      result_array = @combinations_array.dup
      mod.times do
        result_array.shift
      end

      Odds.new(result_array)
    end

    def equal(result)
      if(!!@odds_array[result])
        @odds_array[result]
      else
        0
      end
    end

    def greater_than(result)
      total_chance = 0
      @odds_array.each_with_index do |chance, index|
        if(index > result)
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

    private

    def sum_combinations
      @combinations_total = @combinations_array.inject(0) do |sum, element|
        sum + element
      end
    end

    def calculate_odds
      @odds_array = @combinations_array.map do |combination|
        (combination.to_f / @combinations_total.to_f).round(4)
      end
    end

  end
end
