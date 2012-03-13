require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'dieroll.rb'

class TestRoller < Test::Unit::TestCase

  def setup
    @test = Dieroll::Roller.new('1d6+2')
    @twodice = Dieroll::Roller.new('1d6+1d4-2')
  end

  def teardown
  end

  def test_class_roll
    roll = Dieroll::Roller.string('3d6+10')
    assert !roll.empty?
    assert_equal 2, roll.count
    assert_equal roll.first, roll[1].total+10

    roll = Dieroll::Roller.string('1d6+1d4+10')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+10

    roll = Dieroll::Roller.string('2+2d6+2+2d2+1')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total+roll[2].total+5

    roll = Dieroll::Roller.string('3d6-2d6+10-5')
    assert !roll.empty?
    assert_equal 3, roll.count
    assert_equal roll.first, roll[1].total-roll[2].total+5
  end
  
  def test_roll_init
    assert_equal '1d6+2', @test.string
    assert @test.results.empty?
    assert_equal [[1,6,'+'],2], @test.sets
    assert_equal 1, @test.dice_sets.count
    assert_equal [2], @test.mods
    assert_equal 1, @test.dice_sets.count
    assert_equal 1, @test.mods.count

    assert_equal '1d6+1d4-2', @twodice.string
    assert @twodice.results.empty?
    assert_equal [[1,6,'+'],[1,4,'+'],-2], @twodice.sets
    assert_equal 2, @twodice.dice_sets.count
    assert_equal 1, @test.mods.count
  end

  def test_obj_roll
    result = @test.roll!
    assert !@test.results.empty?
    assert_equal result, @test.total
    @test.roll!
    assert_equal 1, @test.results.count
  end
  
  def test_to_s
    @test.roll!
    assert_match %r{1d6\+2:\n\+1d6: \d+ \n\+\d+}, @test.to_s
  end

end
