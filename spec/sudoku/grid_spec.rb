require 'minitest/autorun'
require_relative '../../lib/sudoku/grid'

require 'pry'

def all_sets 
  cols = (0...9).to_a.map do |x|
    (0...9).to_a.map do |y|
      [x, y]
    end
  end

  rows = (0...9).to_a.map do |y|
    (0...9).to_a.map do |x|
      [x, y]
    end
  end

  small_grid = (0..2).to_a.map do |x|
    (0..2).to_a.map do |y|
      [x, y]
    end
  end.flatten(1)

  grids = small_grid.map do |x_offset, y_offset|
    x_offset *= 3
    y_offset *= 3

    small_grid.map do |x, y|
      [x + x_offset, y + y_offset]
    end
  end

  rows + cols + grids
end

def dup_array array
  array.map do |row|
    row.map do |value|
      value
    end
  end
end

def valid? grid
  all_sets.all? do |set|
    no_dups? grid, set
  end
end

def no_dups? grid, set
  count = Hash.new { 0 }

  set.reject do |ord|
    grid[ord].nil?
  end.each do |ord|
    count[grid[ord]] += 1
  end

  count.values.all? { |value| value <= 1 }
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

  describe "#seed" do
    before :each do 
      grid.seed
    end

    it "should seed the grid" do
      seeds = grid.to_a.flatten.reject { |n| n.nil? }
      assert_equal 11, seeds.count
    end

    it "should be a valid grid" do
      assert_equal true, valid?(grid)
    end
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
