require_relative '../sudoku'
require_relative '../sudoku/solver'
require_relative '../sudoku/grid'
require_relative 'grid'

class Sudoku::Generator
  attr_accessor :givens 

  def initialize options = {}
    defaults = {
      givens: 5,
    }
    config = defaults.merge(options)

    @givens = config[:givens]
  end

  def fill
    solver = Sudoku::Solver.new 

    loop do
      solver.grid = Sudoku::Grid.new
      solver.solve
      break unless solver.unsolvable?
    end
    
    solver.solution
  end
  
  def random_set count, &block
    set = Sudoku::Grid::ALL_ORDS.sample(count)

    count.times do |n|
      block.call(n, set[n])
    end

    set.first(count)
  end

  def seed 
    grid = Sudoku::Grid.new

    loop do
      grid.clear

      values = (1..81).to_a.map { |v| (v % 9) + 1 }.sample(givens)
      random_set(givens) do |n, ord|
        grid[ord] = values[n]
      end

      break if grid.valid?
    end

    grid
  end
end
