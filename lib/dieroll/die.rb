module Dieroll
  class Die
    attr_reader :odds

    def initialize(sides)
      @sides = sides
      @last_result = nil
    end

    def roll!
      @last_result = rand(1..@sides)

      @last_result
    end

    def to_s
      "#{@last_result}"
    end



    def odds
      @odds = calculate_odds unless !!@odds

      @odds
    end

    private

    def calculate_odds
      combinations_array = []
      
      @sides.times do
        combinations_array << 1
      end
      @odds = Dieroll::Odds.new(combinations_array)
    end
  end
end
