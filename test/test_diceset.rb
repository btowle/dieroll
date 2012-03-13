require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestDiceSet< Test::Unit::TestCase

  def setup
    @one_d6 = Dieroll::DiceSet.new(1,6)
    @two_d10 = Dieroll::DiceSet.new(2,10)
  end

  def teardown
  end

  def test_init
    assert_equal 1, @one_d6.number_of_dice
    assert_equal 6, @one_d6.sides
    assert_equal 1, @one_d6.dice.count
    assert_equal 2, @two_d10.dice.count
    assert @one_d6.last_result.empty?
    assert_equal nil, @one_d6.last_total
  end

  def test_roll
    @one_d6.roll!
    @two_d10.roll!

    assert_equal 1, @one_d6.last_result.count
    assert_equal 2, @two_d10.last_result.count

    assert_equal @one_d6.last_total, @one_d6.last_result.inject(0){|sum, element| sum + element}
  end

  def test_to_s
  end

end
