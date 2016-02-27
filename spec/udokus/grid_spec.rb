require 'spec_helper'

def dup_array array
  array.map do |row|
    row.map do |value|
      value
    end
  end
end

describe Udokus::Grid do
  let(:grid) { Udokus::Grid.new }
  
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

  let(:swap) do
    nums = [2, 1, 3, 4, 5, 6, 7, 8, 9]
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

  it "should create a 9x9 grid" do
    expect(grid.array.size).to eq(9)
    expect(grid.array[0].size).to eq(9)
  end

  describe "#valid?" do
    it "should detect a valid puzzle" do
      grid.array = valid
      expect(grid.valid?).to be true
    end

    it "should detect an invalid puzzle" do
      grid.array = invalid
      expect(grid.valid?).to be false
    end
  end

  describe "#valid_square?" do
    let(:bad) do
      tmp = dup_array valid
      tmp[0][0] = 2
      Udokus::Grid.new array: tmp
    end

    it "should detect that a square is valid" do
      expect(bad.valid_square?([8, 8])).to be true
    end

    it "should detect an invalid square" do
      expect(bad.valid_square?([0, 0])).to be false
    end
  end

  describe "#next_empty" do
    let(:first) do
      tmp = dup_array valid
      tmp[0][0] = nil
      Udokus::Grid.new array: tmp
    end

    let(:other) do
      tmp = dup_array valid
      tmp[5][3] = nil
      Udokus::Grid.new array: tmp
    end

    it "returns the next 'sequential' empty cell" do
      expect(first.first_empty).to eq([0,0])
      expect(other.first_empty).to eq([5,3])
    end
  end

  describe "#complete" do
    let(:complete) do
      Udokus::Grid.new array: valid
    end

    let(:incomplete) do
      tmp = dup_array valid
      tmp[0][0] = nil
      Udokus::Grid.new array: tmp
    end

    it "should detect a complete grid" do
      expect(complete.complete?).to be true
    end

    it "should detect an incomplete grid" do
      expect(incomplete.complete?).to be false
    end
  end

  describe "#dup" do
    let(:grid_clone) { grid.dup }

    it "should create a new object" do
      expect(grid.__id__).not_to eq(grid_clone.__id__)
    end

    it "they should be equivalent" do
      expect(grid).to eq(grid_clone)
    end
  end

  describe "#==" do
    let(:first)     { Udokus::Grid.new(array: valid) }    
    let(:same)      { Udokus::Grid.new(array: valid) }    
    let(:different) { Udokus::Grid.new(array: invalid) }

    it "should detect similar grids" do
      expect(first).to eq(same)
    end

    it "should detect dissimilar grids" do
      expect(first).not_to eq(different)
    end
  end

  describe "#minimum_remaining" do
    let(:seeded) { Udokus::Grid.new(array: seeds_mvr) }

    it "should return a list of empty cells sorted by their constraints" do
      expect(seeded.minimum_remaining).to eq([0,2])
    end
  end

  describe "#swap_values!" do
    let (:grid) { Udokus::Grid.new(array: valid) }
    let (:swapped) { Udokus::Grid.new(array: swap) }

    it "should swap values" do
      grid.swap_values! 1, 2
      expect(swapped).to eq(grid)
    end
  end

  describe "#shuffle!" do
    let (:grid) { Udokus::Grid.new(array: valid) }

    it "should still be valid" do
      grid.shuffle!
      expect(grid).to be_valid
    end
  end
end
