require_relative '../sudoku'

class Sudoku::Solver

  attr_accessor :grid, :solutions

  def initialize options = {}
    defaults = {}
    config = defaults.merge(options)

    @grid = config[:grid].dup
    @solutions = []
  end

  def solve
    cell = grid.all_empty.first

    (1..9).to_a.each do |n|
      grid[cell] = n

      if grid.valid?
        if grid.complete?
          solutions << grid.dup 
          break
        else
          solve
        end
      end
    end

    grid[cell] = nil
  end

  def unique?
    solutions.count == 1
  end

end
