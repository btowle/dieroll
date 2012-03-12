require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestRoll < Test::Unit::TestCase
  def test_roll_init
    test = Dieroll::Roll.new(1,6,2)
    assert_equal 1, test.num
    assert_equal 6, test.sides
    assert_equal 2, test.mod
  end
end
