module Dieroll
  class Result
    attr_reader :total, :dice, :sides, :string
    
    def initialize(sides, dice)
      @sides = sides
      @dice = dice
      @total = dice.inject(0){|sum, x| sum+x}
      @string = "#{@dice.count}d#{@sides}"
    end
    
    def to_s
      "#{@total}:#{@string}:#{@dice.join(",")}"
    end

  end
end
