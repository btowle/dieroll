module Dieroll
  class DiceSet
    attr_accessor :number_of_dice, :sides
    attr_reader :last_result, :last_total, :dice, :sign

    def initialize(number_of_dice, sides, sign='+')
      @number_of_dice = number_of_dice
      @sides = sides
      @sign = sign

      @dice = []
      
      @number_of_dice.times do
        @dice << Dieroll::Die.new(sides)
      end

      @last_result = []
      @last_total = nil
    end

    def roll!
      @last_result = []
      @dice.each do |die|
        @last_result << die.roll!
      end
      @last_total = @last_result.inject(0){|sum, element| sum + element}
      @last_total *= -1 if @sign == '-'
      @last_total
    end

    def to_s
      output = "#{@sign}#{@number_of_dice}d#{@sides}: "
      @dice.each do |die|
        output += die.to_s + " "
      end
      output
    end

  end
end
