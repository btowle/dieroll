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
    assert_equal 6, @d6.sides
    assert_equal nil, @d6.last_result
  end

  def test_roll
    roll_result = @d6.roll!
    assert_equal roll_result, @d6.last_result
  end

  def test_to_s
  end

end
