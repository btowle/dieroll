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
      roll(true)
    end

    def roll(save=false)
      result = []
      @dice.each do |die|
        if save
          result << die.roll!
        else
          result << die.roll
        end
      end
      
      result.sort!
      last_non_dropped = result.dup
      if !!@drops
        @drops.each do |drop|
          last_non_dropped.shift  if drop == 'l'
          last_non_dropped.pop  if drop == 'h'
        end
      end

      total = last_non_dropped.inject(0){|sum, element| sum + element}
      total *= -1  if @sign == '-'

      @last_result = result  if save
      @last_non_dropped = last_non_dropped  if save
      @last_total = total  if save

      total
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
