require 'minitest/autorun'
require_relative '../../lib/sudoku/grid'

require 'pry'

def dup_array array
  array.map do |row|
    row.map do |value|
      value
    end
  end
end

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }
  
  let(:valid) do
    nums = (1..9).to_a
    [
      nums,
      nums.rotate(3),
      nums.rotate(6),
      nums.rotate(1),
      nums.rotate(4),
      nums.rotate(7),
      nums.rotate(2),
      nums.rotate(5),
      nums.rotate(8),
    ]
  end

  let(:invalid) do
    (1..9).map do
      (1..9).map { |n| n }
    end
  end
  
  let(:seeds_mvr) do
    [
      [  5,   3, nil,   6,   7,   8,   9,   1,   2],
      [  6, nil, nil,   1,   9,   5, nil, nil, nil],
      [  1,   9,   8, nil, nil, nil, nil,   6, nil],
      [  8, nil,   9, nil,   6, nil, nil, nil,   3],
      [  4, nil,   6,   8, nil,   3, nil, nil,   1],
      [  7, nil,   3, nil,   2, nil, nil, nil,   6],
      [nil,   6,   1, nil, nil, nil,   2,   8, nil],
      [nil, nil,   7,   4,   1,   9, nil, nil,   5],
      [nil, nil,   5, nil,   8, nil, nil,   7,   9],
    ]
  end

  it "should create a 9x9 grid" do
    assert_equal 9, grid.array.size 
    assert_equal 9, grid.array[0].size 
  end

  describe "#valid?" do
    it "should detect a valid puzzle" do
      grid.array = valid
      assert_equal true, grid.valid?
    end

    it "should detect an invalid puzzle" do
      grid.array = invalid
      assert_equal false, grid.valid?
    end
  end

  describe "#valid_square?" do
    let(:bad) do
      tmp = dup_array valid
      tmp[0][0] = 2
      Sudoku::Grid.new array: tmp
    end

    it "should detect that a square is valid" do
      assert_equal true, bad.valid_square?([8, 8])
    end

    it "should detect an invalid square" do
      assert_equal false, bad.valid_square?([0, 0])
    end
  end

  describe "#next_empty" do
    let(:first) do
      tmp = dup_array valid
      tmp[0][0] = nil
      Sudoku::Grid.new array: tmp
    end

    let(:other) do
      tmp = dup_array valid
      tmp[5][3] = nil
      Sudoku::Grid.new array: tmp
    end

    it "returns the next 'sequential' empty cell" do
      assert_equal [0,0], first.first_empty
      assert_equal [5,3], other.first_empty
    end
  end

  describe "#complete" do
    let(:complete) do
      Sudoku::Grid.new array: valid
    end

    let(:incomplete) do
      tmp = dup_array valid
      tmp[0][0] = nil
      Sudoku::Grid.new array: tmp
    end

    it "should detect a complete grid" do
      assert_equal true, complete.complete?
    end

    it "should detect an incomplete grid" do
      assert_equal false, incomplete.complete?
    end
  end

  describe "#dup" do
    let(:grid_clone) { grid.dup }

    it "should create a new object" do
      refute_same grid, grid_clone
    end

    it "they should be equivalent" do
      assert_equal true, grid == grid_clone
    end
  end

  describe "#==" do
    let(:first)     { Sudoku::Grid.new(array: valid) }    
    let(:same)      { Sudoku::Grid.new(array: valid) }    
    let(:different) { Sudoku::Grid.new(array: invalid) }

    it "should detect similar grids" do
      assert_equal true, first == same
    end

    it "should detect dissimilar grids" do
      assert_equal false, first == different
    end
  end

  describe "#minimum_remaining" do
    let(:seeded) { Sudoku::Grid.new(array: seeds_mvr) }

    it "should return a list of empty cells sorted by their constraints" do
      assert_equal [0,2], seeded.minimum_remaining
    end
  end
end
