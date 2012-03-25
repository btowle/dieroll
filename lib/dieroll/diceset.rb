module Dieroll
  class DiceSet

    #Create DiceSet object
    def initialize(number_of_dice, sides, sign='+', drop_string=nil)
      @number_of_dice, @sides, @sign = number_of_dice, sides, sign
      @drop_string = drop_string
      @drops = @drop_string.scan(/[l|h]/)  if !!@drop_string
      @dice = []
      
      @number_of_dice.times do
        @dice << Dieroll::Die.new(@sides)
      end

      @last_results = []
      @last_total = nil
    end

    #Rolls the DiceSet. Returns the result.
    def roll(save=false)
      results = []
      @dice.each do |die|
        if save
          results << die.roll!
        else
          results << die.roll
        end
      end
      
      results.sort!
      last_non_dropped = results.dup
      if !!@drops
        @drops.each do |drop|
          last_non_dropped.shift  if drop == 'l'
          last_non_dropped.pop  if drop == 'h'
        end
      end

      total = last_non_dropped.inject(0){|sum, element| sum + element}
      total *= -1  if @sign == '-'

      @last_results = results  if save
      @last_non_dropped = last_non_dropped  if save
      @last_total = total  if save

      total
    end

    #Rolls the DiceSet. Returns the result.
    #Updates @last_total, @last_result, @last_non_dropped
    def roll!
      roll(true)
    end

    #Returns a string with details of the last roll.
    def report
      output = "#{@sign}#{@number_of_dice}d#{@sides}"
      output += "/#{@drop_string}"  if !!@drop_string
      output += ": "
      @dice.each do |die|
        output += die.to_s + " "
      end

      output
    end

    #Returns the Odds for the DiceSet. Creates Odds if it doesn't exist.
    def odds
      calculate_odds unless !!@odds

      @odds
    end

    #Returns @last_total as a string.
    def to_s
      @last_total.to_s
    end

    private

    #Creates a new Odds object for the DiceSet.
    def calculate_odds
      if !@drops
        @odds = @dice[0].odds ** @number_of_dice
        if(@sign == '-')
          @odds.offset = @sides * @number_of_dice * -1
        end
      else
        possibilities = []
        num_possibilities = @sides ** @number_of_dice

        current_side = 1

        @number_of_dice.times do |dice|
          possibilities.sort!
          num_possibilities.times do |possibility|
            possibilities[possibility] ||= []
            possibilities[possibility] << current_side
            current_side += 1
            current_side = 1  if current_side > @sides
          end
        end
        
        combinations_array = []
        possibilities.each do |possibility|
          possibility.sort!
          @drops.each do |drop|
            possibility.shift  if drop == 'l'
            possibility.pop  if drop == 'h'
          end
          total = possibility.inject(0) {|sum, element| sum + element}
          combinations_array[total] ||= 0
          combinations_array[total] += 1
        end
        offset = @number_of_dice - @drops.size
        offset.times do
          combinations_array.shift
        end
        @odds = Dieroll::Odds.new(combinations_array, offset)
        p @odds
        p @odds.offset
      end
    end

  end
end
