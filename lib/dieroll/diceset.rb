module Dieroll
  class DiceSet
  
    def initialize(number_of_dice, sides, sign='+', drop_string=nil)
      @number_of_dice, @sides, @sign = number_of_dice, sides, sign
      @drop_string = drop_string
      @drops = @drop_string.scan(/[l|h]/)  if !!@drop_string
      @dice = []
      
      @number_of_dice.times do
        @dice << Dieroll::Die.new(@sides)
      end

      @last_result = []
      @last_total = nil
      
    end

    def roll!
      @last_result = []
      @dice.each do |die|
        @last_result << die.roll!
      end
      
      @last_result.sort!
      @last_non_dropped = @last_result.dup
      if !!@drops
        @drops.each do |drop|
          @last_non_dropped.shift  if drop == 'l'
          @last_non_dropped.pop  if drop == 'h'
        end
      end

      @last_total = @last_non_dropped.inject(0){|sum, element| sum + element}
      @last_total *= -1  if @sign == '-'

      @last_total
    end

    def to_s
      output = "#{@sign}#{@number_of_dice}d#{@sides}"
      output += "/#{@drop_string}"  if !!@drop_string
      output += ": "
      @dice.each do |die|
        output += die.to_s + " "
      end

      output
    end
    
    def odds
      @odds = calculate_odds unless !!@odds

      @odds
    end

    private

    def calculate_odds
      @odds = @dice[0].odds ** @number_of_dice
      if(@sign == '-')
        @odds.offset = @sides * @number_of_dice * -1
      end

      @odds
    end
  end
end
