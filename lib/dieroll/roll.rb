module Dieroll
  class Roll
    def self.d(sides)
      rand(1..sides)
    end

    def self.string(string)
      num, sides, mod = string.match(/^(\d+)d(\d+)\+?(\d+)?/).captures
      num = num.to_i
      sides = sides.to_i
      mod = mod.to_i

      total = 0
      num.times do
        total += d(sides)
      end
      return total + mod
    end
  end
end
