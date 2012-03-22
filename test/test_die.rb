require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestDie< Test::Unit::TestCase

  def setup
    @d6 = Dieroll::Die.new(6)
  end

  def teardown
  end

  def test_init
    assert_equal 6, @d6.instance_variable_get("@sides")
    assert_equal nil, @d6.instance_variable_get("@last_result")
    assert_equal [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667],
                  @d6.odds.instance_variable_get("@odds_array").
                  map{|value| value.round(4)}
    assert_equal [1, 1, 1, 1, 1, 1], @d6.odds.combinations_array
    assert_equal 1, @d6.odds.offset
  end

  def test_roll
    roll_result = @d6.roll!
    assert_equal roll_result, @d6.instance_variable_get("@last_result")
  end

  def test_to_s
  end

end
