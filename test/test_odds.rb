require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestOdds< Test::Unit::TestCase

  def setup
    @d4 = Dieroll::Odds.new [0,1,1,1,1]
    @two_d4 = @d4 * @d4
  end

  def teardown
  end

  def test_init
    assert_equal [0, 1, 1, 1, 1],
                  @d4.instance_variable_get("@combinations_array")
    assert_equal 4, @d4.instance_variable_get("@combinations_total")
    assert_equal [0, 0.25, 0.25, 0.25, 0.25],
                  @d4.instance_variable_get("@odds_array")
  end

  def test_equal
    assert_equal 0.25, @d4.equal(1)
    assert_equal 0, @d4.equal(6)
  end

  def test_greater_than
    assert_equal 0.75, @d4.greater_than(1)
    assert_equal 0, @d4.greater_than(4)
  end

  def test_greater_than_or_equal
    assert_equal 1.00, @d4.greater_than_or_equal(1)
    assert_equal 0.25, @d4.greater_than_or_equal(4)
  end

  def test_less_than
    assert_equal 0, @d4.less_than(1)
    assert_equal 0.75, @d4.less_than(4)
  end

  def test_less_than_or_equal
    assert_equal 0.25, @d4.less_than_or_equal(1)
    assert_equal 1.00, @d4.less_than_or_equal(4)
  end

  def test_multiply
    assert_equal [0.0, 0.0, 0.0625, 0.125, 0.1875, 0.25, 0.1875, 0.125, 0.0625],
                  @two_d4.instance_variable_get("@odds_array")
  end

  def test_exponentiate
    assert_equal [0.0, 0.0, 0.0625, 0.125, 0.1875, 0.25, 0.1875, 0.125, 0.0625],
                  (@d4**2).instance_variable_get("@odds_array")
  end

  def test_add
    assert_equal [0.0, 0.0, 0.25, 0.25, 0.25, 0.25],
                  (@d4+1).instance_variable_get("@odds_array")
    assert_equal [0.25, 0.25, 0.25, 0.25],
                  (@d4+(-1)).instance_variable_get("@odds_array")
  end

  def test_subtract
    assert_equal [0.25, 0.25, 0.25, 0.25],
                  (@d4-1).instance_variable_get("@odds_array")
    assert_equal [0.0, 0.0, 0.25, 0.25, 0.25, 0.25],
                  (@d4-(-1)).instance_variable_get("@odds_array")
    #need tests and a solution for negative results
  end

end
