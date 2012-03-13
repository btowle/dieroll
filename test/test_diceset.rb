require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestDiceSet< Test::Unit::TestCase

  def setup
    @one_d6 = Dieroll::DiceSet.new(1,6,'+',nil)
    @two_d10 = Dieroll::DiceSet.new(2,10,'+',nil)
    @minus_two_d8_drop_low = Dieroll::DiceSet.new(2,8,'-','l')
  end

  def teardown
  end

  def test_init
    assert_equal 1, @one_d6.instance_variable_get("@number_of_dice")
    assert_equal 6, @one_d6.instance_variable_get("@sides")
    assert_equal 1, @one_d6.instance_variable_get("@dice").count
    assert_equal 2, @two_d10.instance_variable_get("@dice").count
    assert @one_d6.instance_variable_get("@last_result").empty?
    assert_equal nil, @one_d6.instance_variable_get("@last_total")
  end

  def test_roll
    @one_d6.roll!
    @two_d10.roll!
    @minus_two_d8_drop_low.roll!

    assert_equal 1, @one_d6.instance_variable_get("@last_result").count
    assert_equal 2, @two_d10.instance_variable_get("@last_result").count

    assert_equal @one_d6.instance_variable_get("@last_total"),
                  @one_d6.instance_variable_get("@last_result").
                  inject(0){|sum, element| sum + element}

    assert_equal 2, @minus_two_d8_drop_low.
                    instance_variable_get("@last_result").count
    assert_equal 1, @minus_two_d8_drop_low.
                    instance_variable_get("@last_non_dropped").count
    assert_equal @minus_two_d8_drop_low.
                  instance_variable_get("@last_non_dropped")[0],
                  @minus_two_d8_drop_low.
                  instance_variable_get("@last_result")[1]
  end

  def test_to_s
  end

end
