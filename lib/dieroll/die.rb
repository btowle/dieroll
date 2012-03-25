module Dieroll
  class Die

    #Create Die object
    def initialize(sides)
      @sides = sides
      @last_result = nil
    end

    #Roll the Die. Returns the result.
    def roll(save=false)
      result = rand(1..@sides)
      @last_result = result  if save

      result
    end

    #Roll the Die. Returns the result. Saves last_result.
    def roll!
      roll(true)
    end

    #Returns the Die's Odds object. Creates Odds if it doesn't exist.
    def odds
      calculate_odds unless !!@odds

      @odds
    end

    #Return last_result as a string
    def to_s
      @last_result.to_s
    end

    private

    #Create a new Odds object for the Die.
    def calculate_odds
      combinations_array = []
      
      @sides.times do
        combinations_array << 1
      end
      @odds = Dieroll::Odds.new(combinations_array)
    end

  end
end
