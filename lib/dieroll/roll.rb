module Dieroll
  class Roll
    attr_accessor :string
    attr_reader :results, :sets, :plusminus

    # Roll 1dX
    def self.d(sides)
      rand(1..sides)
    end

    # Roll arbitrary 'XdY+Z' string
    def self.string(string)
      rolls = [0]
      sets, plusminus = s_to_set(string)
      sets.count.times do |i|
        if(sets[i].count == 1)
          val = sets[i][0]
          rolls[0] += val if plusminus[i] == '+'
          rolls[0] -= val if plusminus[i] == '-'
        elsif(sets[i].count == 2)
          rolls << roll(sets[i][0], sets[i][1])
          rolls[0] += rolls.last.total if plusminus[i] == '+'
          rolls[0] -= rolls.last.total if plusminus[i] == '-'
        end
      end
      rolls
    end
    
    # Create roll object
    def initialize(string)
      @string = string
      @sets, @plusminus = Roll.s_to_set(string)
      @results = []
    end

    # Determine results of roll
    def roll!
      @results << Roll.string(@string)
      @results.last.first
    end

    # Return roll result as string
    def to_s
      ret = "Rolled #{@string} #{@results.count} times:\n"
      i = 1
      @results.each do |result|
        ret += "Result #{i}:\n"
        ret += "Total: " + result[0].to_s + "\n"
        (result.count-1).times do |r|
          ret += result[r + 1].to_s + "\n"
        end
        ret += "\n"
        i += 1
      end
      ret
    end

    private

    def self.roll(num, sides)
      total = 0
      dice = []
      num.times do
        dice << d(sides)
      end
      Dieroll::Result.new(sides, dice)
    end
    
    def self.s_to_set(str)
      setstring = str.split(%r{\+|-})
      plusminus = str.scan(%r{\+|-})
      plusminus.unshift('+')
      sets = []
      setstring.each do |s|
        m = s.match(/^(\d+)d(\d+)/)
        m = s.match(/^(\d+)$/) || m
        if(!!m[2])
          sets << [m[1].to_i, m[2].to_i]
        elsif(!!m[1])
          sets << [m[1].to_i]
        end
      end
      [sets, plusminus]
    end

  end
end
