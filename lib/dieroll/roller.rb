module Dieroll
  class Roller
    attr_reader :sets, :dice_sets, :mods, :total, :string

    # Roll 1dX
    def self.d(sides)
      rand(1..sides)
    end

    # Roll arbitrary 'XdY+Z' string
    def self.from_string(string)
      rolls = [0]
      sets = s_to_set(string)
      sets.each do |set|
        if(set.respond_to?(:count) && set.count == 4)
          rolls << roll(set[0].to_i, set[1].to_i)
          rolls[0] += rolls.last.total if set[2] == '+'
          rolls[0] -= rolls.last.total if set[2] == '-'
        elsif
          rolls[0] += set
        end
      end
      rolls
    end
    
    # Create roller object
    def initialize(string)
      @string = string
      @sets = Roller.s_to_set(string)
      
      @dice_sets = []
      @mods = []
      @sets.each do |set|
        if(set.respond_to?(:count))
          @dice_sets << Dieroll::DiceSet.new(set[0].to_i, set[1].to_i, set[2], set[3])
        else
          @mods << set
        end
        @total = 0
      end
    end

    # Determine results of roll
    def roll!
      @total = 0
      @dice_sets.each do |set|
        @total += set.roll!
      end
      @mods.each do |mod|
        @total += mod
      end
      @total
    end

    # Return roll result as string
    def to_s
      output = ""
      output += "#{@string}:\n"
      @dice_sets.each do |set|
        output += "#{set.to_s}\n"
      end
      @mods.each do |mod|
        output += "+" if mod >= 0
        output += "#{mod}\n"
      end
      output
    end
    
    def string=(string)
      @string = string
      initialize(@string)
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
      sets = []
      set_strings = str.scan(/^[^+|-]+|[+|-][^+|-]+/)
      set_strings.each do |set_string|
        match = set_string.match(/[+|-]/)
        if(!!match)
          sign = match[0]
        else
          sign = '+'
        end
        
        set_string, drop_string = set_string.split("/")
        dice_set_string = set_string.match(/^[+|-]?(\d+)d(\d+)/)
        mod_string = set_string.match(/^[+|-]?(\d+)/)
        set = []
        if(!!dice_set_string)
          set << dice_set_string.captures[0].to_i
          set << dice_set_string.captures[1].to_i
          set << sign
          set << drop_string
        else
          mod = mod_string.captures[0]
          set = mod.to_i
          set *= -1 if sign == '-'
        end
        sets << set
      end
      sets
    end

  end
end
