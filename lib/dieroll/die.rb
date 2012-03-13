module Dieroll
  class Die
    attr_accessor :sides
    attr_reader :last_result

    def initialize(sides)
      @sides = sides
      @last_result = nil
    end

    def roll!
      @last_result = rand(1..sides)
      @last_result
    end

    def to_s
      "#{@last_result}"
    end
  end
end
