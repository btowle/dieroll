module Dieroll
  class Result
    attr_reader :total, :dice, :sides, :string
    
    # Create result object
    def initialize(sides, dice)
      @sides, @dice = sides, dice
      @total = dice.inject(0) { |sum, x| sum + x }
      @string = "#{@dice.count}d#{@sides}"
    end
    
    # Return result as string
    def to_s
      "#{@total}:#{@string}:#{@dice.join(",")}"
    end

  end
end
