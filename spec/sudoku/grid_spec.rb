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
end
