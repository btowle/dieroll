module Dieroll
  class Die

    def initialize(sides)
      @sides = sides
      @last_result = nil
    end

    def roll!
      roll(true)
    end

    def roll(save=false)
      result = rand(1..@sides)
      @last_result = result  if save

      result
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
