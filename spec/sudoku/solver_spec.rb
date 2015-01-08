require 'minitest/autorun'
require_relative '../../lib/sudoku/solver'

require 'pry'

describe Sudoku::Solver do
  let(:seeds) do
    [
      [  5,   3, nil, nil,   7, nil, nil, nil, nil],
      [  6, nil, nil,   1,   9,   5, nil, nil, nil],
      [nil,   9,   8, nil, nil, nil, nil,   6, nil],
      [  8, nil, nil, nil,   6, nil, nil, nil,   3],
      [  4, nil, nil,   8, nil,   3, nil, nil,   1],
      [  7, nil, nil, nil,   2, nil, nil, nil,   6],
      [nil,   6, nil, nil, nil, nil,   2,   8, nil],
      [nil, nil, nil,   4,   1,   9, nil, nil,   5],
      [nil, nil, nil, nil,   8, nil, nil,   7,   9],
    ]
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
  
  let(:complete) do
    [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 9],
    ]
  end



  describe "#solve" do
    let(:seeded)   { Sudoku::Grid.new(array: seeds) }
    let(:finished) { Sudoku::Grid.new(array: complete) }

    it "should find a unique solution" do
      solver = Sudoku::Solver.new(grid: seeded)
      solver.solve

      assert solver.unique?, "not unique"
      assert solver.solution == finished, "wrong solution"
    end

    it "should generate a unique solution from empty" do
      solver1 = Sudoku::Solver.new
      solver2 = Sudoku::Solver.new

      solver1.solve
      solver2.solve

      assert_operator solver1.grid, :!=, solver2.grid
    end
  end

  describe "#minimum_remaining" do
    let(:seeded) { Sudoku::Grid.new(array: seeds_mvr) }

    it "should return a list of empty cells sorted by their constraints" do
      solver = Sudoku::Solver.new grid: seeded

      assert_equal [0,2], solver.minimum_remaining
    end
  end

end
