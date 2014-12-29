require 'minitest/autorun'
require_relative '../../lib/sudoku/generator'

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

def complete? grid
  grid.array.flatten.count == 81
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

describe Sudoku::Generator do
  let(:generator) { Sudoku::Generator.new }

  describe "#seed" do
    let(:grid) { generator.seed }

    it "should seed the grid" do
      seeds = grid.to_a.flatten.reject { |n| n.nil? }
      assert_equal 5, seeds.count
    end

    it "should be a valid grid" do
      assert_equal true, valid?(grid)
    end
  end

  describe "#fill" do
    let(:grid) { generator.fill }

    it "should fill a grid" do
      assert_equal true, complete?(grid)
    end

    it "should be a valid grid" do
      assert_equal true, valid?(grid)
    end
  end

end
