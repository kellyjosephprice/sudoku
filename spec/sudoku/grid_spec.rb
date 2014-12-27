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

def valid? grid
  all_sets.all? do |set|
    complete? grid, set
  end
end

def complete? grid, ords
  nums = (0...9).to_a

  values = ords.map do |ord|
    grid.to_a[ord[0]][ord[1]]
  end

  values.sort == nums
end

describe Sudoku::Grid do
  let(:grid) { Sudoku::Grid.new }

  it "should create a 9x9 grid" do
    assert_equal 9, grid.array.size 
    assert_equal 9, grid.array[0].size 
  end

  describe "#seed" do
    it "should seed the grid" do
      grid.seed
      seeds = grid.to_a.flatten.reject { |n| n.nil? }

      assert_equal 11, seeds.count
    end
  end

  describe "#fill" do
    before do
      grid.fill
    end

    it "should be a valid puzzle" do
      assert_equal true, valid?(grid)
    end
  end
end
