module::Dieroll
  class Roller

    attr_reader :total

    # Roll 1dX
    def self.d(sides)
      rand(1..sides)
    end

    # Roll arbitrary dice notation string
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

    # Updates the object to use a new dice notation string
    def string=(string)
      @string = string
      @odds = nil
      initialize(@string)
    end

    # Rolls the Roller. Returns the total.
    def roll(save=false)
      total = 0
      @dice_sets.each do |set|
        if save
          total += set.roll!
        else
          total += set.roll
        end
      end
      @mods.each do |mod|
        total += mod
      end

      @total = total  if save

      total
    end

    # Rolls the Roller. Returns the total. Sets @total.
    def roll!
      roll(true)
    end

    # Return roll result as string
    def report
      output = @total.to_s + "\n"
      output += @string.to_s + ":\n"
      @dice_sets.each do |set|
        output += set.report + "\n"
      end
      @mods.each do |mod|
        output += "+"  if mod >= 0
        output += mod.to_s + "\n"
      end
      
      output
    end

    # Returns @odds. Creates an Odds object if !@odds.
    def odds
      calculate_odds unless !!@odds

      @odds
    end

    # Returns @total as a string
    def to_s
      @total.to_s
    end

    private

    # Creates the the Odds object for the roller.
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
    end

    def self.roll(num, sides)
      total = 0
      dice = []
      num.times do
        dice << d(sides)
      end
      Dieroll::Result.new(sides, dice)
    end

    # Parse str and return an array to create DiceSets.
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
