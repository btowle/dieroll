module::Dieroll
  class Roller

    attr_reader :total

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
          rolls << roll(set[0], set[1])
          rolls[0] += rolls.last.total  if set[2] == '+'
          rolls[0] -= rolls.last.total  if set[2] == '-'
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
      @total = 0

      @sets.each do |set|
        if(set.respond_to?(:count))
          @dice_sets << Dieroll::DiceSet.new(set[0], set[1],
                                              set[2], set[3])
        else
          @mods << set
        end
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
    def report
      output = "#{@total}\n"
      output += "#{@string}:\n"
      @dice_sets.each do |set|
        output += "#{set.to_s}\n"
      end
      @mods.each do |mod|
        output += "+"  if mod >= 0
        output += "#{mod}\n"
      end
      
      output
    end
    
    def to_s
      "#{@total}"
    end

    def string=(string)
      @string = string
      initialize(@string)
    end
    
    def odds
      @odds = calculate_odds unless !!@odds

      @odds
    end


    private

    def calculate_odds
      @dice_sets.each_with_index do |set, index|
        if(index == 0)
          @odds = set.odds
        else
          @odds *= set.odds
        end
      end

      @mods.each do |mod|
        @odds += mod
      end

      @odds
    end

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
        set_string =~ /^([^\/]+)\/?([^\/]*)$/
        set_string, drop_string = $1, $2
        drop_string = nil  if drop_string.empty?

        set_string =~ /^([+|-]?)(\d+)(d\d+)?/
        sign, num, sides = $1, $2, $3
        sign = '+'  if sign.empty?

        set = []
        if(!!sides)
          sides.delete! "d"
          set = [num.to_i, sides.to_i, sign, drop_string]
        else
          set = num.to_i
          set *= -1  if sign == '-'
        end

        sets << set
      end
      
      sets
    end

  end
end
