module Dieroll
  class Roll
    attr_accessor :string
    attr_reader :results

    #class methods to roll 1dX and an arbitrary 'XdY+Z' string
    def self.d(sides)
      rand(1..sides)
    end

    def self.string(string)
      rolls = [0]
      dice = string.split('+')

      dice.each do |str|
        match = str.match(/^(\d+)d(\d+)/)
        match = str.match(/^(\d+)$/) || match
        if(match[2])
          num = match[1].to_i
          sides = match[2].to_i
          rolls << roll(num, sides)
          rolls[0] += rolls.last.total
        elsif(match[1])
          mod = match[1]
          rolls[0] += mod.to_i
        end
      end
      return rolls
    end
    
    #methods for a Roll object
    def initialize(string)
      @string = string
      @results = []
    end

    def roll
      @results << Roll.string(@string)
      @results.last.first
    end
    
    private

    def self.roll(num, sides)
      total = 0;
      dice = [];
      num.times do
        dice << d(sides)
      end
      return Dieroll::Result.new(sides, dice)
    end

  end
end
