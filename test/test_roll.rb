require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestRoll < Test::Unit::TestCase

  def setup
    @test = Dieroll::Roll.new(1,6,2)
  end

  def teardown
  end

  def test_rolls
    roll = Dieroll::Roll.string('3d6+10')
    assert !roll.empty?
    assert_equal 4, roll.count
    assert_equal roll.first, roll[1]+roll[2]+roll[3]+10
  end
  
  def test_roll_init
    assert_equal 1, @test.num
    assert_equal 6, @test.sides
    assert_equal 2, @test.mod
    assert @test.results.empty?
  end

  def test_obj_roll
    result = @test.roll
    assert !@test.results.empty?
    assert_equal result, @test.results.last.first
    4.times do
      @test.roll
    end
    assert_equal 5, @test.results.count
  end
end
