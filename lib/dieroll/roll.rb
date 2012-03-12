module Dieroll
  class Roll
    attr_accessor :num, :sides, :mod
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
          rolls[0] += rolls.last.first
        elsif(match[1])
          mod = match[1]
          rolls[0] += mod.to_i
        end
      end
      return rolls
    end
    
    #methods for a Roll object
    def initialize(num=1, sides=1, mod=0)
      @num = num;
      @sides = sides;
      @mod = mod;
      @results = []
    end

    def roll
      @results << Roll.roll(@num, @sides, @mod)
      @results.last.first
    end
    
    private

    def self.roll(num, sides, mod=0)
      total = 0;
      ret = [];
      num.times do
        result = d(sides)
        total += result
        ret << result
      end
      ret.unshift total + mod
    end

  end
end
