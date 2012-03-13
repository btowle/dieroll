require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestRoller < Test::Unit::TestCase

  def setup
    @one_d6_plus_one = Dieroll::Roller.new('1d6+1')
    @one_d6_plus_one_d4_minus_two = Dieroll::Roller.new('1d6+1d4-2')
  end

  def teardown
  end

  def test_class_roll
    roll = Dieroll::Roller.from_string('3d6+10')
    assert !roll.empty?
    assert_equal 2, roll.count
    assert_equal roll.first, roll[1].total+10

    roll = Dieroll::Roller.from_string('1d6+1d4+10')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+10

    roll = Dieroll::Roller.from_string('2+2d6+2+2d2+1')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+5

    roll = Dieroll::Roller.from_string('3d6-2d6+10-5')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total-roll[2].total+5
  end
  
  def test_roll_init
    assert_equal '1d6+1', @one_d6_plus_one.string
    assert_equal [[1,6,'+',nil],1], @one_d6_plus_one.sets
    assert_equal 1, @one_d6_plus_one.dice_sets.count
    assert_equal [1], @one_d6_plus_one.mods
    assert_equal 1, @one_d6_plus_one.dice_sets.count
    assert_equal 1, @one_d6_plus_one.mods.count

    assert_equal '1d6+1d4-2', @one_d6_plus_one_d4_minus_two.string
    assert_equal [[1,6,'+',nil],[1,4,'+',nil],-2], @one_d6_plus_one_d4_minus_two.sets
    assert_equal 2, @one_d6_plus_one_d4_minus_two.dice_sets.count
    assert_equal 1, @one_d6_plus_one.mods.count
  end

  def test_obj_roll
    result = @one_d6_plus_one.roll!
    assert_equal result, @one_d6_plus_one.total
  end
  
  def test_to_s
    @one_d6_plus_one.roll!
    assert_match %r{1d6\+1:\n\+1d6: \d+ \n\+\d+}, @one_d6_plus_one.to_s
  end
  
  def test_string=
    @one_d6_plus_one_d4_minus_two.string = @one_d6_plus_one.string
    assert_equal '1d6+1', @one_d6_plus_one_d4_minus_two.string
    assert_equal [[1,6,'+',nil],1], @one_d6_plus_one_d4_minus_two.sets
    assert_equal 1, @one_d6_plus_one_d4_minus_two.dice_sets.count
    assert_equal [1], @one_d6_plus_one_d4_minus_two.mods
    assert_equal 1, @one_d6_plus_one_d4_minus_two.dice_sets.count
    assert_equal 1, @one_d6_plus_one_d4_minus_two.mods.count
  end

end
