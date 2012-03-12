require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestResult < Test::Unit::TestCase

  def setup
    @result = Dieroll::Result.new(6, [1,5,4])
  end

  def teardown
  end

  def test_init
    assert_equal [1,5,4], @result.dice
    assert_equal 6, @result.sides
    assert_equal 10, @result.total
    assert_equal '3d6', @result.string
  end

  def test_to_s
    assert_equal "10:3d6:1,5,4", @result.to_s
  end

end
