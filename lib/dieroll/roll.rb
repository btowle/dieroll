module Dieroll
  class Roll
    attr_accessor :num, :sides, :mod
    
    #class methods to roll 1dX and an arbitrary 'XdY+Z' string
    def self.d(sides)
      rand(1..sides)
    end

    def self.string(string)
      num, sides, mod, mod = string.match(/^(\d+)d(\d+)(\+(\d+))?/).captures
      num = num.to_i
      sides = sides.to_i
      mod = mod.to_i
      roll(num, sides, mod)
    end
    
    #methods for a Roll object
    def initialize(num=1, sides=1, mod=0)
      @num = num;
      @sides = sides;
      @mod = mod;
    end

    def roll
      roll(@num, @sides, @mod)
    end
    
    private

    def self.roll(num, sides, mod=0)
    total = 0;
      num.times do
        total += d(sides)
      end
      return total + mod
    end

  end
end
